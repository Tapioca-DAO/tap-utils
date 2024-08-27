// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// External
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// Tapioca
import {Pearlmit, IPearlmit, PearlmitHash} from "tap-utils/pearlmit/Pearlmit.sol";
import {PearlmitBaseTest, ERC20Mock, ERC721Mock, ERC1155Mock} from "./PearlmitBase.t.sol";

import "forge-std/console.sol";

contract PearlmitTest is PearlmitBaseTest {
    struct test_hashBatchTransferFrom_MemoryData {
        address erc20Addr;
        address batchOwner;
        uint256 nonce;
        uint48 sigDeadline;
        address executor;
        bytes32 hashedData;
    }

    function test_hashBatchTransferFrom() public {
        address erc20Addr = _deployNew20(alice, 1000);
        test_hashBatchTransferFrom_MemoryData memory data;

        {
            data.batchOwner = alice;
            data.nonce = 0; // Can be random, it's unordered
            data.sigDeadline = uint48(block.timestamp);
            data.executor = address(this); // Who is expected execute the permit
            data.hashedData = keccak256("0x"); // Extra data

            // Create approvals + their hashes
            IPearlmit.SignatureApproval[] memory approvals = new IPearlmit.SignatureApproval[](1);
            approvals[0] =
                IPearlmit.SignatureApproval({tokenType: 20, token: erc20Addr, id: 0, amount: 100, operator: bob});
            bytes32[] memory hashApprovals = new bytes32[](1);
            {
                for (uint256 i = 0; i < 1; ++i) {
                    hashApprovals[i] = keccak256(
                        abi.encode(
                            PearlmitHash._PERMIT_SIGNATURE_APPROVAL_TYPEHASH,
                            approvals[i].tokenType,
                            approvals[i].token,
                            approvals[i].id,
                            approvals[i].amount,
                            approvals[i].operator
                        )
                    );
                }
            }

            // Create batch digest and sign it
            bytes32 digest = ECDSA.toTypedDataHash(
                pearlmit.domainSeparatorV4(),
                keccak256(
                    abi.encode(
                        PearlmitHash._PERMIT_BATCH_TRANSFER_FROM_TYPEHASH,
                        keccak256(abi.encodePacked(hashApprovals)),
                        data.batchOwner,
                        data.nonce,
                        data.sigDeadline,
                        pearlmit.masterNonce(data.batchOwner),
                        data.executor,
                        data.hashedData
                    )
                )
            );

            bytes memory signedPermit;
            {
                (uint8 v, bytes32 r, bytes32 s) = vm.sign(aliceKey, digest);
                signedPermit = abi.encodePacked(r, s, v);
            }

            // Execute the permit
            IPearlmit.PermitBatchTransferFrom memory batch = IPearlmit.PermitBatchTransferFrom({
                approvals: approvals,
                owner: data.batchOwner,
                nonce: data.nonce,
                sigDeadline: uint48(data.sigDeadline),
                masterNonce: pearlmit.masterNonce(data.batchOwner),
                signedPermit: signedPermit,
                executor: data.executor,
                hashedData: data.hashedData
            });

            vm.prank(bob); // Can't be called by bob
            vm.expectRevert();
            pearlmit.permitBatchApprove(batch, data.hashedData);

            vm.prank(data.executor);
            pearlmit.permitBatchApprove(batch, data.hashedData);
        }
        // Check the allowance
        {
            (uint256 allowedAmount, uint256 expiration) = pearlmit.allowance(alice, bob, 20, erc20Addr, 0);
            assertEq(allowedAmount, 100);
            assertEq(expiration, block.timestamp);
        }

        // Clear the allowance
        uint256 snapshot = vm.snapshot();
        {
            vm.prank(bob);
            pearlmit.clearAllowance(alice, 20, erc20Addr, 0);
            (uint256 allowedAmount, uint256 expiration) = pearlmit.allowance(alice, bob, 20, erc20Addr, 0);
            assertEq(allowedAmount, 0);
            assertEq(expiration, 0);
        }
        vm.revertTo(snapshot);

        // ERC20 transfer
        {
            ERC20Mock erc20 = ERC20Mock(erc20Addr);
            vm.prank(alice);
            erc20.approve(address(pearlmit), type(uint256).max); // Pearlmit needs to have allowance

            assertEq(erc20.balanceOf(bob), 0);
            vm.prank(bob);
            pearlmit.transferFromERC20(alice, bob, erc20Addr, 100);
            assertEq(erc20.balanceOf(bob), 100);
        }
    }
}

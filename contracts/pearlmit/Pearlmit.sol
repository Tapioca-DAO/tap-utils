// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// External
import {PermitC, PermitC__SignatureTransferExceededPermitExpired} from "permitc/PermitC.sol";

// Tapioca
import {PearlmitHash} from "./PearlmitHash.sol";
import {IPearlmit} from "./IPearlmit.sol";

/*
__/\\\\\\\\\\\\\\\_____/\\\\\\\\\_____/\\\\\\\\\\\\\____/\\\\\\\\\\\_______/\\\\\_____________/\\\\\\\\\_____/\\\\\\\\\____        
 _\///////\\\/////____/\\\\\\\\\\\\\__\/\\\/////////\\\_\/////\\\///______/\\\///\\\________/\\\////////____/\\\\\\\\\\\\\__       
  _______\/\\\________/\\\/////////\\\_\/\\\_______\/\\\_____\/\\\_______/\\\/__\///\\\____/\\\/____________/\\\/////////\\\_      
   _______\/\\\_______\/\\\_______\/\\\_\/\\\\\\\\\\\\\/______\/\\\______/\\\______\//\\\__/\\\_____________\/\\\_______\/\\\_     
    _______\/\\\_______\/\\\\\\\\\\\\\\\_\/\\\/////////________\/\\\_____\/\\\_______\/\\\_\/\\\_____________\/\\\\\\\\\\\\\\\_    
     _______\/\\\_______\/\\\/////////\\\_\/\\\_________________\/\\\_____\//\\\______/\\\__\//\\\____________\/\\\/////////\\\_   
      _______\/\\\_______\/\\\_______\/\\\_\/\\\_________________\/\\\______\///\\\__/\\\_____\///\\\__________\/\\\_______\/\\\_  
       _______\/\\\_______\/\\\_______\/\\\_\/\\\______________/\\\\\\\\\\\____\///\\\\\/________\////\\\\\\\\\_\/\\\_______\/\\\_ 
        _______\///________\///________\///__\///______________\///////////_______\/////_____________\/////////__\///________\///__
*/

/**
 * @title Pearlmit
 * @author Limit Break Inc., Tapioca
 * @notice Pearlmit inherit PermitC and implements a new `permitBatchTransferFrom()` function
 * to allow batch transfer of multiple token types.
 */
contract Pearlmit is PermitC {
    constructor(string memory name, string memory version) PermitC(name, version) {}

    /**
     * @notice Permit batch transfer of multiple token types.
     * @dev Check the validity of a permit batch transfer.
     *      - Reverts if the permit is invalid.
     *      - Reverts if the permit is expired.
     * @dev Invalidate the nonce after checking it.
     *
     * @param batch PermitBatchTransferFrom struct containing all necessary data for batch transfer.
     * batch.approvals - array of SignatureApproval structs.
     *      * batch.approvals.tokenType - type of token (0 = ERC20, 1 = ERC721, 2 = ERC1155).
     *      * batch.approvals.token - address of the token.
     *      * batch.approvals.id - id of the token (0 if ERC20).
     *      * batch.approvals.amount - amount of the token (0 if ERC721).
     *      * batch.approvals.operator - address of the operator to transfer the tokens to.
     *      * batch.approvals.approvalExpiration - expiration of the approval.
     * batch.owner - address of the owner of the tokens.
     * batch.nonce - nonce of the owner.
     * batch.sigDeadline - deadline for the signature.
     * batch.signedPermit - signature of the permit.
     */
    function permitBatchTransferFrom(IPearlmit.PermitBatchTransferFrom calldata batch) external {
        _checkPermitBatchApproval(batch);

        uint256 numPermits = batch.approvals.length;
        for (uint256 i = 0; i < numPermits; ++i) {
            IPearlmit.SignatureApproval calldata approval = batch.approvals[i];
            if (approval.tokenType == uint8(IPearlmit.TokenType.ERC20)) {
                _transferFromERC20(approval.token, batch.owner, approval.operator, 0, approval.amount);
            } else if (approval.tokenType == uint8(IPearlmit.TokenType.ERC721)) {
                _transferFromERC721(batch.owner, approval.operator, approval.token, approval.id);
            } else if (approval.tokenType == uint8(IPearlmit.TokenType.ERC1155)) {
                _transferFromERC1155(approval.token, batch.owner, approval.operator, approval.id, approval.amount);
            }
        }
    }

    /**
     * @dev Generate the digest and check its validity against the permit.
     */
    function _checkPermitBatchApproval(IPearlmit.PermitBatchTransferFrom calldata batch) internal {
        bytes32 digest = _hashTypedDataV4(
            PearlmitHash.hashBatchTransferFrom(
                batch.approvals, batch.nonce, batch.sigDeadline, masterNonce(batch.owner)
            )
        );

        _checkBatchPermitData(batch.nonce, batch.sigDeadline, batch.owner, digest, batch.signedPermit);
    }

    /**
     * @dev Check the validity of a permit batch transfer.
     *      - Reverts if the permit is invalid.
     *      - Reverts if the permit is expired.
     * @dev Invalidate the nonce after checking it.
     */
    function _checkBatchPermitData(
        uint256 nonce,
        uint256 expiration,
        address owner,
        bytes32 digest,
        bytes calldata signedPermit
    ) internal {
        if (block.timestamp > expiration) {
            revert PermitC__SignatureTransferExceededPermitExpired();
        }

        _verifyPermitSignature(digest, signedPermit, owner);
        _checkAndInvalidateNonce(owner, nonce);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// External
import {OracleChainlinkSingle, OracleChainlinkSingleConstructorData} from "tap-utils/oracle/OracleChainlinkSingle.sol";
import {StargateV2TokenToUsdcOracle} from "tap-utils/oracle/StargateV2TokenToUsdcOracle.sol";
import {ITapiocaOracle} from "tap-utils/interfaces/periph/ITapiocaOracle.sol";
import {SeerCLSolo} from "tap-utils/oracle/SeerCLSolo.sol";

// hardcoded for arbitrum
contract StargateV2ArbToUsdcOracle is Test {
    address binanceWalletAddr = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D;
    address usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address arb = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    SeerCLSolo arbToUsd;
    SeerCLSolo usdcToUsd;
    StargateV2TokenToUsdcOracle arbToUsdcOracle;
    function setUp() public {
        // fork
        uint256 forkingBlockNumber = 224034540;
        vm.createSelectFork(getChain("arbitrum").rpcUrl, forkingBlockNumber);

        // create ARB to USD and USDC to USD oracles
        address[] memory guardians = new address[](1);
        guardians[0] = address(this);

        // ARB to USD
      
        arbToUsd = new SeerCLSolo(
            "CL ARB/USD", 
            "ARB/USD", 
            18,
            OracleChainlinkSingleConstructorData({
                _poolChainlink: 0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6, // CL Pool
                _isChainlinkMultiplied: uint8(1), // Multiply/divide Uni
                _inBase: 1e18, // In base
                stalePeriod: uint32(86400), // CL stale period, 1 day on prod. max uint32 on testnet
                guardians: guardians, // Guardians
                _description: bytes32("ARB/USD"), // Description,
                _sequencerUptimeFeed: address(0), // CL Sequencer
                _admin: address(this)  // Owner
            }) 
        );

        usdcToUsd = new SeerCLSolo(
            "CL UDSC/USD", 
            "UDSC/USD", 
            18,
            OracleChainlinkSingleConstructorData({
                _poolChainlink: 0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3, // CL Pool
                _isChainlinkMultiplied: uint8(1), // Multiply/divide Uni
                _inBase: 1e18, // In base
                stalePeriod: uint32(86400), // CL stale period, 1 day on prod. max uint32 on testnet
                guardians: guardians, // Guardians
                _description: bytes32("USDC/USD"), // Description,
                _sequencerUptimeFeed: address(0), // CL Sequencer
                _admin: address(this)  // Owner
            }) 
        );

        arbToUsdcOracle = new StargateV2TokenToUsdcOracle(ITapiocaOracle(address(arbToUsd)), ITapiocaOracle(address(usdcToUsd)), address(this));
    }

    function test_Rate_StargateV2_Arb_to_Usdc() public {
        (, uint256 arbToUsdPrice)= arbToUsd.peek("");
        (, uint256 usdcToUsdPrice)= usdcToUsd.peek("");
        (, uint256 arbToUsdcPrice)= arbToUsdcOracle.peek("");

        if (usdcToUsdPrice < 1e18) {
            assertGt(arbToUsdcPrice * 1e12, arbToUsdPrice);
        } else {
            assertGt(arbToUsdPrice, arbToUsdcPrice * 1e12);
        }

        uint256 priceShouldBe = (arbToUsdPrice  * 1e18 / usdcToUsdPrice) / 1e12;
        assertEq(arbToUsdcPrice, priceShouldBe);
    }
}

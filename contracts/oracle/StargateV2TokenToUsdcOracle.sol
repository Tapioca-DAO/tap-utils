// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// External
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Tapioca
import {AccessControlDefaultAdminRules} from "./external/AccessControlDefaultAdminRules.sol";
import {ITapiocaOracle} from "tap-utils/interfaces/periph/ITapiocaOracle.sol";

contract StargateV2TokenToUsdcOracle is ITapiocaOracle, AccessControlDefaultAdminRules, ReentrancyGuard {
    ITapiocaOracle public immutable tokenToUsdOracle;
    ITapiocaOracle public immutable usdcToUsdOracle;

    error AddressNotValid();
    error DecimalsNotValid();
    error OracleCallFailed();

    constructor(ITapiocaOracle _tokenToUsdOracle, ITapiocaOracle _usdcToUsdOracle, address _admin) AccessControlDefaultAdminRules(3 days, _admin) {
        if (address(_tokenToUsdOracle) == address(0)) revert AddressNotValid();
        if (address(_usdcToUsdOracle) == address(0)) revert AddressNotValid();

        if (_tokenToUsdOracle.decimals() != 18 || _usdcToUsdOracle.decimals() != 18) revert DecimalsNotValid();

        tokenToUsdOracle = _tokenToUsdOracle;
        usdcToUsdOracle = _usdcToUsdOracle;
    }

    function decimals() external pure returns (uint8) {
        return 6;
    }

    /// @inheritdoc ITapiocaOracle
    function name(bytes calldata) public view override returns (string memory) {
        return string.concat( tokenToUsdOracle.name(""), " -> (Inverse) " , usdcToUsdOracle.name(""));
    }

    /// @inheritdoc ITapiocaOracle
    function symbol(bytes calldata) public view override returns (string memory) {
        return string.concat( tokenToUsdOracle.symbol(""), " -> (Inverse) " , usdcToUsdOracle.symbol(""));
    }


    // Get the latest exchange rate
    /// @inheritdoc ITapiocaOracle
    function get(bytes calldata) public override nonReentrant returns (bool success, uint256 rate) {
        uint256 tokenToUsdPrice;
        uint256 usdcToUsdPrice;
        (success, tokenToUsdPrice) = tokenToUsdOracle.get("");
        if (!success) revert OracleCallFailed();
        (success, usdcToUsdPrice) = usdcToUsdOracle.get("");
        if (!success) revert OracleCallFailed();

        rate = ((tokenToUsdPrice * 1e18) / usdcToUsdPrice) / 1e12;
        return (true, rate);
    }

    // Check the last exchange rate without any state changes
    /// @inheritdoc ITapiocaOracle
    function peek(bytes calldata) public view override returns (bool success, uint256 rate) {
        uint256 tokenToUsdPrice;
        uint256 usdcToUsdPrice;
        (success, tokenToUsdPrice) = tokenToUsdOracle.peek("");
        if (!success) revert OracleCallFailed();
        (success, usdcToUsdPrice) = usdcToUsdOracle.peek("");
        if (!success) revert OracleCallFailed();

        rate = ((tokenToUsdPrice * 1e18) / usdcToUsdPrice) / 1e12;
        return (true, rate);
    }

    // Check the current spot exchange rate without any state changes
    /// @inheritdoc ITapiocaOracle
    function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
        (, rate) = peek(data);
    }
}
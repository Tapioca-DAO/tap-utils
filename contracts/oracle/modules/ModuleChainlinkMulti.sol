// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.22;

// External
import {AggregatorV3Interface} from "tap-utils/interfaces/external/chainlink/IAggregatorV3Interface.sol";

// Tapioca
import {ChainlinkUtils} from "../utils/ChainlinkUtils.sol";

/// @title ModuleChainlinkMulti
/// @author Angle Core Team, modified by Tapioca
/// @notice Module Contract that is going to be used to help compute Chainlink prices
/// @dev This contract helps for an oracle using a Chainlink circuit composed of multiple pools
/// @dev An oracle using Chainlink is either going to be a `ModuleChainlinkSingle` or a `ModuleChainlinkMulti`
abstract contract ModuleChainlinkMulti is ChainlinkUtils {
    /// @notice Chanlink pools, the order of the pools has to be the order in which they are read for the computation
    /// of the price
    AggregatorV3Interface[] public circuitChainlink;
    /// @notice Whether each rate for the pairs in `circuitChainlink` should be multiplied or divided
    uint8[] public circuitChainIsMultiplied;
    /// @notice Decimals for each Chainlink pairs
    uint8[] public chainlinkDecimals;

    /// @notice Constructor for an oracle using only Chainlink with multiple pools to read from
    /// @param _circuitChainlink Chainlink pool addresses (in order)
    /// @param _circuitChainIsMultiplied Whether we should multiply or divide by this rate when computing Chainlink price
    constructor(
        address[] memory _circuitChainlink,
        uint8[] memory _circuitChainIsMultiplied,
        address[] memory guardians
    ) {
        uint256 circuitLength = _circuitChainlink.length;
        require(circuitLength > 0, "106");
        require(circuitLength == _circuitChainIsMultiplied.length, "104");
        // There is no `GOVERNOR_ROLE` in this contract, governor has `GUARDIAN_ROLE`
        require(guardians.length > 0, "101");
        for (uint256 i; i < guardians.length; i++) {
            require(guardians[i] != address(0), "0");
            _grantRole(GUARDIAN_ROLE_CHAINLINK, guardians[i]);
        }
        _setRoleAdmin(GUARDIAN_ROLE_CHAINLINK, GUARDIAN_ROLE_CHAINLINK);

        for (uint256 i; i < circuitLength; i++) {
            AggregatorV3Interface _pool = AggregatorV3Interface(_circuitChainlink[i]);
            circuitChainlink.push(_pool);
            chainlinkDecimals.push(_pool.decimals());
        }

        circuitChainIsMultiplied = _circuitChainIsMultiplied;
    }

    /// @notice Reads oracle price using Chainlink circuit
    /// @param quoteAmount The amount for which to compute the price expressed with base decimal
    /// @return The `quoteAmount` converted in `out-currency`
    /// @return The value obtained with the last Chainlink feed queried casted to uint
    /// @dev If `quoteAmount` is `BASE_TOKENS`, the output is the oracle rate
    function _quoteChainlink(uint256 quoteAmount) internal view returns (uint256, uint256) {
        uint256 castedRatio;
        // An invariant should be that `circuitChainlink.length > 0` otherwise `castedRatio = 0`
        for (uint256 i; i < circuitChainlink.length; i++) {
            (quoteAmount, castedRatio) = _readChainlinkFeed(
                quoteAmount, circuitChainlink[i], circuitChainIsMultiplied[i], chainlinkDecimals[i], 0
            );
        }
        return (quoteAmount, castedRatio);
    }
}

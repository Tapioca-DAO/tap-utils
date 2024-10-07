// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
/*

████████╗ █████╗ ██████╗ ██╗ ██████╗  ██████╗ █████╗ 
╚══██╔══╝██╔══██╗██╔══██╗██║██╔═══██╗██╔════╝██╔══██╗
   ██║   ███████║██████╔╝██║██║   ██║██║     ███████║
   ██║   ██╔══██║██╔═══╝ ██║██║   ██║██║     ██╔══██║
   ██║   ██║  ██║██║     ██║╚██████╔╝╚██████╗██║  ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝
   
*/

interface ITapiocaOptionLiquidityProvision is IERC721 {
    function yieldBox() external view returns (address);

    function activeSingularities(address singularity)
        external
        view
        returns (uint256 sglAssetId, uint256 totalDeposited, uint256 poolWeight, bool rescue);

    function lock(address to, address singularity, uint128 lockDuration, uint256 amount, address _for)
        external
        returns (uint256 tokenId);

    function unlock(uint256 tokenId, address singularity) external returns (uint256 sharesOut);

    function lockPositions(uint256 tokenId)
        external
        view
        returns (uint128 sglAssetID, uint256 ybShares, uint128 lockTime, uint128 lockDuration);
}

struct IOptionsLockData {
    bool lock;
    address target;
    address tAsset;
    uint128 lockDuration;
    uint256 amount; // @dev: in case of a previous `YB` deposit, this amount is replaced by the obtained shares
    uint256 fraction;
    uint256 minDiscountOut;
}

struct IOptionsUnlockData {
    bool unlock;
    address target;
    uint256 tokenId;
}

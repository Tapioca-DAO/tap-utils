// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "./IMarket.sol";
import "./ISingularity.sol";
import "./ITapiocaOptionsBroker.sol";
import "./ITapiocaOptionLiquidityProvision.sol";
import "./ICommonData.sol";

interface IUSDOBase {
    // remove and repay
    struct ILeverageExternalContractsData {
        address swapper;
        address magnetar;
        address tOft;
        address srcMarket;
    }

    struct IRemoveAndRepay {
        bool removeAssetFromSGL;
        uint256 removeAmount; //slightly greater than repayAmount to cover the interest
        bool repayAssetOnBB;
        uint256 repayAmount; // on BB
        bool removeCollateralFromBB;
        uint256 collateralAmount; // from BB
        ITapiocaOptionsBroker.IOptionsExitData exitData;
        ITapiocaOptionLiquidityProvision.IOptionsUnlockData unlockData;
        ICommonData.IWithdrawParams assetWithdrawData;
        ICommonData.IWithdrawParams collateralWithdrawData;
    }

    // lend or repay
    struct ILendOrRepayParams {
        bool repay;
        uint256 depositAmount;
        uint256 repayAmount;
        address marketHelper;
        address market;
        bool removeCollateral;
        uint256 removeCollateralAmount;
        ITapiocaOptionLiquidityProvision.IOptionsLockData lockData;
        ITapiocaOptionsBroker.IOptionsParticipateData participateData;
    }

    //leverage data
    struct ILeverageLZData {
        uint256 srcExtraGasLimit;
        uint16 lzSrcChainId;
        uint16 lzDstChainId;
        address zroPaymentAddress;
        bytes dstAirdropAdapterParam;
        bytes srcAirdropAdapterParam;
        address refundAddress;
    }

    struct ILeverageSwapData {
        address tokenOut;
        uint256 amountOutMin;
        bytes data;
    }

    struct IMintData {
        bool mint;
        uint256 mintAmount;
        ICommonData.IDepositData collateralDepositData;
    }

    function mint(address _to, uint256 _amount) external;

    function burn(address _from, uint256 _amount) external;

    function setFlashloanHelper(address _helper) external;

    function addFlashloanFee(uint256 _fee) external; //onlyOwner

    function paused() external view returns (bool);

    function sendAndLendOrRepay(
        address _from,
        address _to,
        uint16 lzDstChainId,
        address zroPaymentAddress,
        ILendOrRepayParams calldata lendParams,
        ICommonData.IApproval[] calldata approvals,
        ICommonData.IApproval[] calldata revokes,
        ICommonData.IWithdrawParams calldata withdrawParams, //collateral remove data
        bytes calldata adapterParams
    ) external payable;

    function sendForLeverage(
        uint256 amount,
        address leverageFor,
        ILeverageLZData calldata lzData,
        ILeverageSwapData calldata swapData,
        ILeverageExternalContractsData calldata externalData
    ) external payable;

    function removeAsset(
        address from,
        address to,
        uint16 lzDstChainId,
        address zroPaymentAddress,
        bytes calldata adapterParams,
        ICommonData.ICommonExternalContracts calldata externalData,
        IUSDOBase.IRemoveAndRepay calldata removeAndRepayData,
        ICommonData.IApproval[] calldata approvals,
        ICommonData.IApproval[] calldata revokes
    ) external payable;

    function triggerSendFrom(
        address from,
        uint16 dstChainId,
        bytes32 to,
        uint256 amount,
        ICommonOFT.LzCallParams calldata callParams
    ) external payable;

    function triggerApproveOrRevoke(
        uint16 lzDstChainId,
        ICommonOFT.LzCallParams calldata lzCallParams,
        ICommonData.IApproval[] calldata approvals
    ) external payable;
}

interface IUSDO is IUSDOBase, IERC20Metadata {}
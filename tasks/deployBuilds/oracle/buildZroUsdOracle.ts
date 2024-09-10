import { SeerCLSolo__factory } from '@typechain/index';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { IDeployerVMAdd } from 'tapioca-sdk/dist/ethers/hardhat/DeployerVM';
import { DEPLOYMENT_NAMES, DEPLOY_CONFIG } from 'tasks/deploy/DEPLOY_CONFIG';

export const buildZROCLOracle = async (
    hre: HardhatRuntimeEnvironment,
    owner: string,
    isTestnet: boolean,
): Promise<IDeployerVMAdd<SeerCLSolo__factory>> => {
    const chainID = hre.SDK.eChainId;

    const args: Parameters<SeerCLSolo__factory['deploy']> = [
        'CL ZRO/USD', // Name
        'ZRO/USD', // Symbol
        18, // Decimals
        {
            _poolChainlink:
                DEPLOY_CONFIG.POST_LBP[chainID]!.ZRO_USD_CL_DATA_FEED_ADDRESS, // CL Pool
            _isChainlinkMultiplied: 1, // Multiply/divide Uni
            _inBase: (1e18).toString(), // In base
            stalePeriod: isTestnet ? 4294967295 : 86400, // CL stale period, 1 day on prod. max uint32 on testnet
            guardians: [owner], // Guardians
            _description: hre.ethers.utils.formatBytes32String('ZRO/USD'), // Description,
            _sequencerUptimeFeed: DEPLOY_CONFIG.MISC[chainID]!.CL_SEQUENCER, // CL Sequencer
            _admin: owner, // Owner
        },
    ];

    return {
        contract: await hre.ethers.getContractFactory('SeerCLSolo'),
        deploymentName: DEPLOYMENT_NAMES.ZRO_USD_SEER_ORACLE,
        args,
    };
};
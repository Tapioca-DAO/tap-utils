import { IDependentOn } from '@tapioca-sdk/ethers/hardhat/DeployerVM';
import { StargateV2ArbToUsdcOracle__factory } from '@typechain/index';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { IDeployerVMAdd } from 'tapioca-sdk/dist/ethers/hardhat/DeployerVM';

export const buildStargateV2StratOracle = async (
    hre: HardhatRuntimeEnvironment,
    params: {
        deploymentName: string;
        args: Parameters<StargateV2ArbToUsdcOracle__factory['deploy']>;
        dependsOn: IDependentOn[];
    },
): Promise<IDeployerVMAdd<StargateV2ArbToUsdcOracle__factory>> => {
    return {
        contract: new StargateV2ArbToUsdcOracle__factory().connect(
            hre.ethers.provider.getSigner(),
        ),
        deploymentName: params.deploymentName,
        args: params.args,
        dependsOn: params.dependsOn,
    };
};

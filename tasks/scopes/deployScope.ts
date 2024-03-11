import { scope } from 'hardhat/config';
import { deployPreLbpStack__task } from 'tasks/deploy/1-deployPreLbpStack';
import { deployPostLbpStack__task } from 'tasks/deploy/2-deployPostLbpStack';

const deployScope = scope('deploys', 'Deployment tasks');

deployScope
    .task(
        'preLbp',
        'Deploy Cluster, Pearlmit and Magnetar',
        deployPreLbpStack__task,
    )
    .addOptionalParam(
        'tag',
        'The tag to use for the deployment. Defaults to "default" if not specified.',
        'default',
    )
    .addFlag(
        'load',
        'Load the contracts from the database instead of building them.',
    )
    .addFlag('verify', 'Add to verify the contracts after deployment.');

deployScope
    .task('postLbp', 'Deploy Oracles', deployPostLbpStack__task)
    .addOptionalParam(
        'tag',
        'The tag to use for the deployment. Defaults to "default" if not specified.',
        'default',
    )
    .addFlag(
        'load',
        'Load the contracts from the database instead of building them.',
    )
    .addFlag('verify', 'Add to verify the contracts after deployment.');

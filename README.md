All rights are reserved and the Tapioca codebase is not Open Source or Free. You cannot modify or redistribute this code without explicit written permission from the copyright holder (Tapioca Foundation & BoringCrypto [where applicable]).

# tapioca-utils 🍹 🤙

The `tapioca-utils` is a repository containing contracts that are not used as core functionalities of the protocol but are still needed in order for it to work, It includes;

- Helper contracts that helps transfer messages and automate certain tasks.
- Util contracts to help deploy contracts and bundle transactions
- A whitelisting contract that keeps track of protocol owned and validated contract addresses, on each chain the protocol operates.
- Swapper contracts to facilitates AMMs swapping.
- Oracle base contracts and implementation to be used by the core contracts.


## Install

To install this repository:

```bash
yarn
```
This will install the necessary npm packages, forge-std and close the submodule dependencies.

## Compile

This behavior will change once we move in from hardhat (currently used for deployments only), for now we need to compile hardhat to generate an intermediary folder which contains the actual folder used by the forge to compile from. This folder is `./gen`, which is generated only after a hardhat compilation. This is a temporary solution to a remapping problem because of the other repos using `tap-utils`.

First, copy the content of `.env.example` to a `.env/` folder, the filename should be `localhost.env` 

next, run

```bash
npx hardhat compile && forge compile
```

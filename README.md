All rights are reserved and the Tapioca codebase is not Open Source or Free. You cannot modify or redistribute this code without explicit written permission from the copyright holder (Tapioca Foundation & BoringCrypto [where applicable]).

# tapioca-utils 🍹 🤙

The `tapioca-utils` is a repository containing contracts that are not used as core functionalities of the protocol but are still needed in order for it to work, It includes;

- Helper contracts that helps transfer messages and automate certain tasks.
- Util contracts to help deploy contracts and bundle transactions
- A whitelisting contract that keeps track of protocol owned and validated contract addresses, on each chain the protocol operates.
- Swapper contracts to facilitates AMMs swapping.
- Oracle base contracts and implementation to be used by the core contracts.


## Usage

To install Foundry:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

This will download foundryup. To start Foundry, run:

```sh
foundryup
```

To clone the repo:

```sh
git clone https://github.com/Tapioca-DAO/tap-utils.git && cd tap-utils
```

To install as a submodule:
    
```sh
git submodule add https://github.com/Tapioca-DAO/tap-utils.git
```

## Install

To install this repository:

```bash
git submodule update --init --recursive
yarn
forge build
```
# OracleChainlinkSingle

*Angle Core Team*

> OracleChainlinkSingle

Oracle contract, one contract is deployed per collateral/stablecoin pair

*This contract concerns an oracle that only uses Chainlink and a single poolThis is mainly going to be the contract used for the USD/EUR pool (or for other fiat currencies)Like all oracle contracts, this contract is an instance of `OracleAstract` that contains some base functions*

## Methods

### BASE

```solidity
function BASE() external view returns (uint256)
```

Base used for computation




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### GUARDIAN_ROLE_CHAINLINK

```solidity
function GUARDIAN_ROLE_CHAINLINK() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### chainlinkDecimals

```solidity
function chainlinkDecimals() external view returns (uint8)
```

Decimals for each Chainlink pairs




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | undefined |

### changeStalePeriod

```solidity
function changeStalePeriod(uint32 _stalePeriod) external nonpayable
```

Changes the Stale Period



#### Parameters

| Name | Type | Description |
|---|---|---|
| _stalePeriod | uint32 | New stale period (in seconds) |

### description

```solidity
function description() external view returns (bytes32)
```

Description of the assets concerned by the oracle and the price outputted




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### getRoleAdmin

```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32)
```



*Returns the admin role that controls `role`. See {grantRole} and {revokeRole}. To change a role&#39;s admin, use {_setRoleAdmin}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### grantRole

```solidity
function grantRole(bytes32 role, address account) external nonpayable
```



*Grants `role` to `account`. If `account` had not been already granted `role`, emits a {RoleGranted} event. Requirements: - the caller must have ``role``&#39;s admin role.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### hasRole

```solidity
function hasRole(bytes32 role, address account) external view returns (bool)
```



*Returns `true` if `account` has been granted `role`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### inBase

```solidity
function inBase() external view returns (uint256)
```

Unit of the in-currency




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### isChainlinkMultiplied

```solidity
function isChainlinkMultiplied() external view returns (uint8)
```

Whether the rate computed using the Chainlink pool should be multiplied to the quote amount or not




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | undefined |

### poolChainlink

```solidity
function poolChainlink() external view returns (contract AggregatorV3Interface)
```

Chainlink pool to look for in the contract




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract AggregatorV3Interface | undefined |

### read

```solidity
function read() external view returns (uint256 rate)
```

Reads the rate from the Chainlink feed




#### Returns

| Name | Type | Description |
|---|---|---|
| rate | uint256 | The current rate between the in-currency and out-currency |

### readAll

```solidity
function readAll() external view returns (uint256, uint256)
```

Read rates from the circuit of both Uniswap and Chainlink if there are both circuits else returns twice the same price

*The rate returned is expressed with base `BASE` (and not the base of the out-currency)*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Return all available rates (Chainlink and Uniswap) with the lowest rate returned first. |
| _1 | uint256 | undefined |

### readLower

```solidity
function readLower() external view returns (uint256 rate)
```

Reads rates from the circuit of both Uniswap and Chainlink if there are both circuits and returns either the highest of both rates or the lowest

*If there is only one rate computed in an oracle contract, then the only rate is returned regardless of the value of the `lower` parameterThe rate returned is expressed with base `BASE` (and not the base of the out-currency)*


#### Returns

| Name | Type | Description |
|---|---|---|
| rate | uint256 | The lower rate between Chainlink and Uniswap |

### readQuote

```solidity
function readQuote(uint256 quoteAmount) external view returns (uint256)
```

Converts an in-currency quote amount to out-currency using Chainlink&#39;s feed

*The amount returned is expressed with base `BASE` (and not the base of the out-currency)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| quoteAmount | uint256 | Amount (in the input collateral) to be converted in out-currency |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Quote amount in out-currency from the base amount in in-currency |

### readQuoteLower

```solidity
function readQuoteLower(uint256 quoteAmount) external view returns (uint256)
```

Returns the lowest quote amount between Uniswap and Chainlink circuits (if possible). If the oracle contract only involves a single feed, then this returns the value of this feed

*The rate returned is expressed with base `BASE` (and not the base of the out-currency)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| quoteAmount | uint256 | Amount (in the input collateral) to be converted |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The lowest quote amount from the quote amount in in-currency |

### readUpper

```solidity
function readUpper() external view returns (uint256 rate)
```

Reads rates from the circuit of both Uniswap and Chainlink if there are both circuits and returns either the highest of both rates or the lowest

*If there is only one rate computed in an oracle contract, then the only rate is returned regardless of the value of the `lower` parameterThe rate returned is expressed with base `BASE` (and not the base of the out-currency)*


#### Returns

| Name | Type | Description |
|---|---|---|
| rate | uint256 | The upper rate between Chainlink and Uniswap |

### renounceRole

```solidity
function renounceRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from the calling account. Roles are often managed via {grantRole} and {revokeRole}: this function&#39;s purpose is to provide a mechanism for accounts to lose their privileges if they are compromised (such as when a trusted device is misplaced). If the calling account had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must be `account`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### revokeRole

```solidity
function revokeRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from `account`. If `account` had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must have ``role``&#39;s admin role.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### stalePeriod

```solidity
function stalePeriod() external view returns (uint32)
```

Represent the maximum amount of time (in seconds) between each Chainlink update before the price feed is considered stale




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint32 | undefined |



## Events

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
```



*Emitted when `newAdminRole` is set as ``role``&#39;s admin role, replacing `previousAdminRole` `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite {RoleAdminChanged} not being emitted signaling this. _Available since v3.1._*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| previousAdminRole `indexed` | bytes32 | undefined |
| newAdminRole `indexed` | bytes32 | undefined |

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
```



*Emitted when `account` is granted `role`. `sender` is the account that originated the contract call, an admin role bearer except when using {_setupRole}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
```



*Emitted when `account` is revoked `role`. `sender` is the account that originated the contract call:   - if using `revokeRole`, it is the admin role bearer   - if using `renounceRole`, it is the role bearer (i.e. `account`)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |



## Errors

### InvalidChainlinkRate

```solidity
error InvalidChainlinkRate()
```







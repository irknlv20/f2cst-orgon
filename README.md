📄 This README is also available in: [🇷🇺 Russian](README.ru.md)

# F2CST Token

F2CST is an **oRC20** standard token for the **ORGON** blockchain.  
The contract implements standard token functions and additional features such as:  
- Minting (creating new tokens)  
- Burning (destroying tokens)  
- Rewards for token holders  
- Administrator management  
- Contract pausing/resuming  
- Token and fund withdrawals by the contract owner

---

## Basic Information

| Parameter         | Value              |
|------------------|--------------------|
| Token Name       | F2CST              |
| Symbol           | F2CST              |
| Decimals         | 4                  |
| Standard         | oRC20              |
| Max Supply (Cap) | 100,000.0000 F2CST |

---

## Deployment

- Blockchain: **ORGON**
- Standard: **oRC20 (IoRC20 interface)**

---

## Public Contract Functions

### Standard oRC20 Functions

- `transfer(address payable to, uint256 value)`: Transfer tokens to another address.
- `approve(address spender, uint256 value)`: Approve a third-party address to spend tokens.
- `transferFrom(address payable from, address payable to, uint256 value)`: Transfer tokens on behalf of another user.
- `totalSupply()`: Get the total number of issued tokens.
- `balanceOf(address owner)`: Get token balance of an address.
- `allowance(address owner, address spender)`: Check how many tokens are allowed for spending by a third-party.

---

### Additional Functions

#### Token Management

- `mint(address to, uint256 value)`: (Owner only) Mint new tokens.
- `burn(uint256 value)`: Burn tokens from own address.
- `burnFrom(address from, uint256 value)`: Burn tokens from another address (if approved).

#### Contract Management

- `finishMinting()`: (Owner only) Permanently disable further token minting.
- `pause()`: (Owner only) Pause the contract.
- `unpause()`: (Owner only) Resume the contract.
- `withdrawOrgon(address payable to, uint value)`: (Owner only) Withdraw ORGON (native tokens) from the contract.
- `withdrawTokensTransfer(IoRC20 token, address payable to, uint256 value)`: (Owner only) Transfer IoRC20 tokens from the contract.
- `withdrawTokensTransferFrom(IoRC20 token, address payable from, address payable to, uint256 value)`: (Owner only) Transfer tokens between third-party addresses.
- `withdrawTokensApprove(IoRC20 token, address spender, uint256 value)`: (Owner only) Approve token spending for a third-party address.

#### Administrator Management

- `addManager(address manager)`: (Owner only) Add a manager.
- `removeManager(address manager)`: (Owner only) Remove a manager.
- `isManager(address manager)`: Check if an address is a manager.
- `getManagers()`: Get the list of managers.

#### Reward System

- `repayment(uint amount)`: (Owner only) Load funds for reward distribution.
- `reward()`: Claim your reward based on token ownership.
- `availableRewards(address account)`: View available rewards for an address.

---

## Important Events

- `Transfer(address from, address to, uint256 value)`: Token transfer event.
- `Approval(address owner, address spender, uint256 value)`: Token approval event.
- `MintFinished(address account)`: Minting disabled.
- `Paused(address account)`: Contract paused.
- `Unpaused(address account)`: Contract resumed.
- `Repayment(address from, uint256 amount)`: Rewards funded.
- `Reward(address to, uint256 amount)`: Reward claimed by a holder.
- `WithdrawOrgon(address to, uint256 value)`: ORGON withdrawn from the contract.

---

## Notes

- After calling `finishMinting()`, token minting is permanently disabled.
- `pause()` can restrict contract functions to protect in critical situations.
- All administrative operations are restricted to the contract **Owner**.

---

## About the Project

The F2CST token is a flexible financial instrument with reward support, a secure management system, and compliance with the oRC20 standard for the ORGON blockchain.

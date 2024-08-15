# Crowdfunding Smart Contract

## Overview

This Crowdfunding smart contract allows users to create fundraising campaigns, contribute funds to campaigns, and withdraw funds if the campaign reaches its goal. The contract is written in Clarity language and designed for the Stacks blockchain.

## Features

- **Create a Campaign**: Initiate a new crowdfunding campaign with a specified goal and duration.
- **Contribute to Campaign**: Users can contribute funds to an active campaign.
- **Withdraw Funds**: Campaign creators can withdraw funds if their campaign meets the goal.
- **Query Campaign Details**: Check campaign status and contribution details.

## Contract Functions

### `create-campaign(goal: uint, duration: uint)`

- **Description**: Creates a new crowdfunding campaign.
- **Parameters**:
    - `goal`: The fundraising goal for the campaign (uint).
    - `duration`: The number of blocks until the campaign ends (uint).
- **Returns**: Campaign ID (uint).

### `contribute(campaign-id: uint, amount: uint)`

- **Description**: Contributes funds to a specified campaign.
- **Parameters**:
    - `campaign-id`: The ID of the campaign to contribute to (uint).
    - `amount`: The amount of STX to contribute (uint).
- **Returns**: `true` if successful.

### `withdraw-funds(campaign-id: uint)`

- **Description**: Withdraws funds from a campaign if the goal is reached.
- **Parameters**:
    - `campaign-id`: The ID of the campaign to withdraw funds from (uint).
- **Returns**: `true` if successful.

### `get-campaign(campaign-id: uint)`

- **Description**: Retrieves details of a specific campaign.
- **Parameters**:
    - `campaign-id`: The ID of the campaign (uint).
- **Returns**: A map containing campaign details (creator, goal, raised, end-block, active).

### `get-contribution(campaign-id: uint, contributor: principal)`

- **Description**: Checks the amount contributed by a user to a campaign.
- **Parameters**:
    - `campaign-id`: The ID of the campaign (uint).
    - `contributor`: The principal address of the contributor (principal).
- **Returns**: The amount contributed (uint).

## Deployment

To deploy this contract, follow these steps:

1. **Install Dependencies**: Ensure you have the Clarity REPL or Clarinet installed.

2. **Load the Contract**: If using the Clarity REPL, start it and load the contract:

   ```bash
   clarity-repl
   (load-contract 'crowdfunding.clar)
   ```

3. **Deploy with Clarinet**:
    - Initialize a Clarinet project if you haven't already.

      ```bash
      clarinet new my-crowdfunding
      ```

    - Place `crowdfunding.clar` in the `contracts` directory.
    - Run the Clarinet commands to deploy and test the contract.

## Testing

To test the contract, use the Clarinet framework:

1. **Install Clarinet**:

   ```bash
   npm install -g @clarigen/clarinet
   ```

2. **Initialize a Clarinet Project**:

   ```bash
   clarinet new my-crowdfunding
   ```

3. **Copy Contract**:
    - Place `crowdfunding.clar` in the `contracts` directory.

4. **Write Tests**: Create test files in the `tests` directory. Example:

   ```typescript
   import { Clarinet, Tx, Chain, Account, types } from "@clarigen/clarinet";

   Clarinet.test({
     name: "Ensure campaign can be created and contributions can be made",
     async fn(chain: Chain, accounts: Map<string, Account>) {
       let deployer = accounts.get("deployer")!;
       let wallet_1 = accounts.get("wallet_1")!;

       // Create a new campaign
       let block = chain.mineBlock([
         Tx.contractCall(
           "crowdfunding",
           "create-campaign",
           [types.uint(1000), types.uint(10)],
           deployer.address
         ),
       ]);

       block.receipts[0].result.expectOk().expectUint(0);

       // Contribute to the campaign
       block = chain.mineBlock([
         Tx.contractCall(
           "crowdfunding",
           "contribute",
           [types.uint(0), types.uint(500)],
           wallet_1.address
         ),
       ]);

       block.receipts[0].result.expectOk().expectBool(true);
     },
   });
   ```

5. **Run Tests**:

   ```bash
   clarinet test
   ```

## Example Usage

Here are some example interactions with the contract using the Clarity REPL or Clarinet:

**Create a Campaign**:

```lisp
(contract-call? .crowdfunding create-campaign u1000 u10)
```

**Contribute to a Campaign**:

```lisp
(contract-call? .crowdfunding contribute u0 u500)
```

**Withdraw Funds**:

```lisp
(contract-call? .crowdfunding withdraw-funds u0)
```

**Check Campaign Details**:

```lisp
(contract-call? .crowdfunding get-campaign u0)
```

**Check Contribution Amount**:

```lisp
(contract-call? .crowdfunding get-contribution u0 tx-sender)
```

## License

This contract is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing

Contributions are welcome! Please submit issues and pull requests to improve the contract or documentation.

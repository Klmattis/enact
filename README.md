# Enact
Referendum contract for provably fair voting

## Background
Voting is a form of consensus that has stood the test of time. It allows every person involved have an equal say in what should, or should not, happen in some environment.
But how can one ensure a vote is fair, while retaining the anonymity of the voters? This project, "enact", seeks to solve this problem by giving users the ability to create referendums that can only be voted on by approved voters.
Enact also allows for public referendums for more open (and less secure) votes. Referendums cannot be modified after creation, even by the manager, and will start and end at the times specified on creation.
After voting ends, the manager may close the referendum to finalize the outcome.

## Implementation
The project uses the contract factory design pattern to allow other users the ability to create their own referendum contracts.
Restrictions are placed such that noone may change an existing contract, including the contract owner. Enact is a submodule of the Portfolio project,
which interacts with the contract through a user interface.

A live version of the project can be found at https://port-fol.io/enact.

## Install
Use the following steps to install the application locally:
1. Clone this repository under your portfolio/ethereum/ directory.
2. Run the following in the enact directory:
```bash
npm install 
```

## Compile
Use the following steps to compile the enact smart contract:
1. Run the following in the enact directory:
```bash
node compile.js
```
2. Confirm that the vitae/build/ directory contains Referendum.json and ReferendumFactory.json.

## Deploy
Use the following steps to compile the enact smart contract:
1. Run the following in the enact directory:
```bash
node deploy.js
```
2. In your terminal, take note of the address of the newly deployed contract.
3. Within /enact/factory.js, replace the existing contract address with your own from step 2.

See Klmattis/portfolio for instructions on running the application used to view this project.


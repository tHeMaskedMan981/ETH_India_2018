## Starting with Ethereum development

#### Installing Geth:
1. Go to [link](https://geth.ethereum.org/downloads/) and download Geth for Windows/Linux.
2. In Windows, go to Environment Variables and add “C:\Program Files\Geth” to the “Paths” variable under System Variables
3. Type `geth version` on cmd to check if Geth is working or not.

#### Installing Truffle:
1. If you don’t have NODE.js, download it from [link](https://nodejs.org/en/) & install it.
2. Use `npm install -g truffle` to install “Truffle”.
3. For `rollbackFailedOptional: verb npm-session xxxxxxx` error, unset the proxy using:
```
npm config rm proxy
npm config rm https-proxy
```
#### Installing Ganache-CLI:
1. Type the following on the terminal: `npm install -g ganache-cli`

#### Creating a TestNet with Geth:

1. Create an empty folder to contain the TestNet (eg: "C:/XYZ/TestNet")
2. create a `mygenesis.json` file with the parameters shown.
```
{
     "config": {
          "chainId": 15,
          "homesteadBlock": 0,
          "eip155Block": 0,
          "eip158Block": 0
     },
     "nonce": "0x0000000000000042",
     "timestamp": "0x0",
     "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
     "gasLimit": "0x8000000",
     "difficulty": "0x400",
     "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
     "coinbase": "0x3333333333333333333333333333333333333333",
     "alloc": {
     }
}
```
3. Setup the Genesis File using:
```
geth --datadir <path to an empty folder>(eg: "C:/XYZ/TestNet") init mygenesis.json
```
4. Once you have setup your `mygenesis.json` file, type the following command at the terminal to start your testnet chain. This command opens a geth console session, which can be used for creating accounts, carrying transactions and any other blockchain interactions.
```
geth --datadir <folder specified in earlier command> --networkid 12345 --rpc --rpcaddr "localhost" --rpcport 8545 --rpccorsdomain "*" --rpcapi "eth,net,web3,personal,admin,mine" --nodiscover --maxpeers 0 console
```
5. Create a new Ethereum account in your testnet chain by typing `personal.newAccount()` in the Geth console
6. This will request for a passphrase. Enter the passphrase and keep it safe for future transactions.
7. Once the account has been generated, quit Geth console with `ctrl+c`. Now remove every folder except keystore from your datadir.
8. Add the following command to your `mygenesis.json` file:
```
“alloc”:
{ 
    “<your account address e.g. 0x1fb891f92eb557f4d688463d0d7c560552263b5a>”:{
    “balance”:“20000000000000000000”
    } 
}
```
9. Save your genesis file and re-run your testnet chain command.
10. Go to the Geth Console and type the following to check the balanvce of the newly created account:
```
var primary = “0x2…021516”;
balance = web3.fromWei(eth.getBalance(primary), “ether”); //Should show 20 Ether
```
11. For all the transactions to get executed and included in the Blockchain, mining session needs to be enabled. Start a miner instance for your custom testnet chain by typing the following in another terminal:
```
geth --data dir <path to your testnet directory> --networkid 12345 --rpc --rpcaddr “localhost” --rpcport 8545 --rpccorsdomain “*” --rpcapi “eth,net,web3,personal,admin,mine” --mine --minerthreads 1 --nodiscover --maxpeers 0 miner
```
12. Open another console/terminal and type `geth --datadir <path to test network directory> --networkid 12345 attach ipc:geth.ipc`
    If you are unable to attach to remote geth (Error: Invalid pipe address '...'), use `geth attach ipc:\\.\pipe\geth.ipc`
13. Now you can carry all your transactions and run commands from this session. For making a transaction, each time the account should be unlocked using `personal.unlockAccount(‘<Your account address>’)`

#### Creating a TestNet with Truffle:
1. Create a new folder and type `truffle init` on a command line window.
2. Copy the contents of an a [Wrestling Smart Contract](https://github.com/devzl/ethereum-walkthrough-1/blob/master/Wrestling.sol, "smart contract") and save it in "contracts" folder.
3. Open the folder “migrations” and create a new file named "2_deploy_contracts.js". Migrations are simply scripts that’ll help us deploy our contracts to a blockchain. Paste the following code inside, and save.
```
const Wrestling = artifacts.require("./Wrestling.sol")
module.exports = function(deployer) {
	deployer.deploy(Wrestling);
};
```
4. If you are on Windows, remove “truffle.js” (due to naming issues in Windows), if you are on another system, remove one of them, or keep them both, it’s not important. 
5. Then put this code inside of “truffle-config.js”:
```
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    }
  }
};
```
6. Fire a new command-line and type in the following command: `ganache-cli -p 7545`. Ganache will generate test accounts for us, they have 100 ether by default, and are unlocked so we can send ether from them freely. Ganache basically emulates the EVM here.
7. On the first command-line interface, we execute two commands (On the command-line interface where ganache-cli is run, you can see the transactions being executed):
```
truffle compile
truffle migrate --network development
```
8. Start the truffle console using the following command: `truffle console --network development`
9. After this, type the following lines of code in the truffle console to test the working of the deployed smart contract:
```
// Web3 is a JavaScript API that wraps RPC calls to help us 
// interact with a blockchain in an easy way.
account0 = web3.eth.accounts[0]
account1 = web3.eth.accounts[1]

// assign a reference to the instance of the contract 
// that truffle deployed to the variable “WrestlingInstance”
Wrestling.deployed().then(inst => { WrestlingInstance = inst })
WrestlingInstance.wrestler1.call() //Returns address of wrestler1 (first account)
WrestlingInstance.registerAsAnOpponent({from: account1})
WrestlingInstance.wrestler2.call() //Retrieve address of 2nd wrestler

// Now players can wrestle
WrestlingInstance.wrestle({from: account0, value: web3.toWei(2, "ether")})
WrestlingInstance.wrestle({from: account1, value: web3.toWei(3, "ether")})
// End of the first round
WrestlingInstance.wrestle({from: account0, value: web3.toWei(5, "ether")})
WrestlingInstance.wrestle({from: account1, value: web3.toWei(20, "ether")})
// End of the wrestling (wrestler2 wins)

 WrestlingInstance.withdraw({from:account1}) //wrestler2 owns account1
 ```
 


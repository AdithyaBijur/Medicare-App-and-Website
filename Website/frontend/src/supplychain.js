import web3 from './web3';

//const address = '0x7B56A9A6e7c20d865D7486Da64310BEE0bC8Ee1a';
//const address = '0x34d848c48EEc33C040Ea2Ea0B5F30dF90972d1f3';
//const address = '0x9ee9ca71adb5bf25eab0a6383300e1a94a45b8b4';
const address = '0x74A104CA9ABD573FD43C38E77Acb732B6665426A';
const abi=[
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_from",
				"type": "address"
			}
		],
		"name": "acceptdist",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			}
		],
		"name": "backtrack",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_from",
				"type": "address"
			}
		],
		"name": "decline",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_from",
				"type": "address"
			}
		],
		"name": "rdist",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_from",
				"type": "address"
			}
		],
		"name": "rman",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_id",
				"type": "uint256"
			}
		],
		"name": "sell",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			}
		],
		"name": "setdistdetails",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_medName",
				"type": "string"
			},
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "expiryd",
				"type": "uint256"
			},
			{
				"name": "expirydate",
				"type": "string"
			}
		],
		"name": "setmed",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sid",
				"type": "uint256"
			},
			{
				"name": "lid",
				"type": "uint256"
			},
			{
				"name": "_dist",
				"type": "address"
			}
		],
		"name": "setretaildetails",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_role",
				"type": "string"
			},
			{
				"name": "_user",
				"type": "address"
			},
			{
				"name": "name",
				"type": "string"
			}
		],
		"name": "setuser",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "checkex",
		"outputs": [
			{
				"name": "res",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_id",
				"type": "uint256"
			}
		],
		"name": "getmed",
		"outputs": [
			{
				"name": "medName",
				"type": "string"
			},
			{
				"name": "mname",
				"type": "string"
			},
			{
				"name": "dname",
				"type": "string"
			},
			{
				"name": "rname",
				"type": "string"
			},
			{
				"name": "soldstatus",
				"type": "bool"
			},
			{
				"name": "expsts",
				"type": "bool"
			},
			{
				"name": "expdate",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "readd",
				"type": "address[]"
			},
			{
				"name": "medname",
				"type": "string"
			}
		],
		"name": "stockcheck",
		"outputs": [
			{
				"name": "st",
				"type": "uint24[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
// const abi = [
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "sid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "lid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "_from",
// 				"type": "address"
// 			}
// 		],
// 		"name": "acceptdist",
// 		"outputs": [],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "_id",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "sell",
// 		"outputs": [],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "_to",
// 				"type": "address"
// 			},
// 			{
// 				"name": "sid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "lid",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "setdistdetails",
// 		"outputs": [],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "_medName",
// 				"type": "string"
// 			},
// 			{
// 				"name": "sid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "lid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "_to",
// 				"type": "address"
// 			},
// 			{
// 				"name": "expiryd",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "setmed",
// 		"outputs": [
// 			{
// 				"name": "st",
// 				"type": "int8"
// 			}
// 		],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "sid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "lid",
// 				"type": "uint256"
// 			},
// 			{
// 				"name": "_dist",
// 				"type": "address"
// 			}
// 		],
// 		"name": "setretaildetails",
// 		"outputs": [],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": false,
// 		"inputs": [
// 			{
// 				"name": "_role",
// 				"type": "string"
// 			},
// 			{
// 				"name": "_user",
// 				"type": "address"
// 			},
// 			{
// 				"name": "name",
// 				"type": "string"
// 			}
// 		],
// 		"name": "setuser",
// 		"outputs": [],
// 		"payable": false,
// 		"stateMutability": "nonpayable",
// 		"type": "function"
// 	},
// 	{
// 		"constant": true,
// 		"inputs": [
// 			{
// 				"name": "id",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "checkex",
// 		"outputs": [
// 			{
// 				"name": "res",
// 				"type": "bool"
// 			}
// 		],
// 		"payable": false,
// 		"stateMutability": "view",
// 		"type": "function"
// 	},
// 	{
// 		"constant": true,
// 		"inputs": [
// 			{
// 				"name": "_id",
// 				"type": "uint256"
// 			}
// 		],
// 		"name": "getmed",
// 		"outputs": [
// 			{
// 				"name": "medName",
// 				"type": "string"
// 			},
// 			{
// 				"name": "manufacture",
// 				"type": "address"
// 			},
// 			{
// 				"name": "mname",
// 				"type": "string"
// 			},
// 			{
// 				"name": "d",
// 				"type": "address"
// 			},
// 			{
// 				"name": "dname",
// 				"type": "string"
// 			},
// 			{
// 				"name": "rname",
// 				"type": "string"
// 			},
// 			{
// 				"name": "soldstatus",
// 				"type": "bool"
// 			}
// 		],
// 		"payable": false,
// 		"stateMutability": "view",
// 		"type": "function"
// 	}
// ]
export default new web3.eth.Contract(abi, address);


//import 'dart:io';

import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';

var apiUrl =
    'https://rinkeby.infura.io/v3/82908567feb74d73a047d4413d1e9f1e'; //Replace with your API

final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0x6Ac91336a0459A5640a4159e662e82816a78dA00');

var httpClient = new Client();
var ethClient = new Web3Client(apiUrl, httpClient);

Future<List> stocks( id,medname) async {
  const String abiCode ='[{"constant":false,"inputs":[{"name":"sid","type":"uint256"},{"name":"lid","type":"uint256"},{"name":"_from","type":"address"}],"name":"acceptdist","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"sid","type":"uint256"},{"name":"lid","type":"uint256"},{"name":"_from","type":"address"}],"name":"decline","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"}],"name":"sell","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"sid","type":"uint256"},{"name":"lid","type":"uint256"}],"name":"setdistdetails","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_medName","type":"string"},{"name":"sid","type":"uint256"},{"name":"lid","type":"uint256"},{"name":"_to","type":"address"},{"name":"expiryd","type":"uint256"},{"name":"expirydate","type":"string"}],"name":"setmed","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"sid","type":"uint256"},{"name":"lid","type":"uint256"},{"name":"_dist","type":"address"}],"name":"setretaildetails","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_role","type":"string"},{"name":"_user","type":"address"},{"name":"name","type":"string"}],"name":"setuser","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"id","type":"uint256"}],"name":"checkex","outputs":[{"name":"res","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"getmed","outputs":[{"name":"medName","type":"string"},{"name":"mname","type":"string"},{"name":"dname","type":"string"},{"name":"rname","type":"string"},{"name":"soldstatus","type":"bool"},{"name":"expsts","type":"bool"},{"name":"expdate","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"readd","type":"address[]"},{"name":"medname","type":"string"}],"name":"stockcheck","outputs":[{"name":"st","type":"uint24[]"}],"payable":false,"stateMutability":"view","type":"function"}]';
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Supplychain'), contractAddr);
  final stockcheck = contract.function('stockcheck');

  var x = new BigInt.from(5);
   List stock =
      await ethClient.call(function: stockcheck, params: [id,medname], contract: contract);

  return stock;
}

import 'package:flutter/foundation.dart';

class Transactions {
  final String id;
  final did;
  final String name;
  final String manufacturer;
  final String distributer;
  final String retailer;
  final bool soldstatus;
  final bool expired;
  final String expiry;

  Transactions({
    @required this.id,
    this.did,
    @required this.name,
    @required this.manufacturer,
    @required this.distributer,
    @required this.retailer,
    @required this.soldstatus,
    @required this.expired,
    @required this.expiry,
  });
  factory Transactions.fromJson(Map<String, dynamic> parsedJson) {
    return Transactions(
      did: parsedJson['did'],
      id: parsedJson['mid'].toString(),
      name: parsedJson['name'].toString(),
      manufacturer: parsedJson['manufacturer'].toString(),
      distributer: parsedJson['distributer'].toString(),
      retailer: parsedJson['retailer'].toString(),
      soldstatus: parsedJson['soldstatus'],
      expired: parsedJson['expiry'],
      expiry: parsedJson['expirydate'].toString(),
    );
  }
}

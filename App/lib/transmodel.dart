import 'package:flutter/material.dart';

class Model extends StatelessWidget {
  final TextStyle st = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 2);
  final TextStyle stt =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20, height: 2);
  final name;
  final manufacturer;
  final distributer;
  final retailer;
  final soldstatus;
  final expired;
  final expirydate;
  final id;
  final color=  Colors.white;
  Model(
      {this.id,
      this.name,
      this.manufacturer,
      this.distributer,
      this.retailer,
      this.soldstatus,
      this.expired,
      this.expirydate});
  @override
  Widget build(BuildContext context) {
    return Container(
     color: Colors.white,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                  elevation: 0,
                color:color,
                child: ListTile(
                  leading: Icon(Icons.add_to_queue,color: Colors.greenAccent),
                  title: Text(
                    'Name: ${name}',
                    style: stt,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                 color:color,
                child: ListTile(
                  leading: Icon(Icons.perm_identity,color: Colors.greenAccent,),
                  title: Text(
                    'ID: ${id.toString()}',
                    style: stt,
                  ),
                ),
              ),
              Card(
                  elevation: 0,
                 color:color,
                child: ListTile(
                  leading: Icon(Icons.business,color: Colors.greenAccent,),
                  title: Text(
                    'Manufacturer:  ${manufacturer}',
                    style: stt,
                  ),
                ),
              ),
              Card(
                  elevation: 0,
                 color:color,
                child: ListTile(
                  leading: Icon(Icons.perm_identity,color: Colors.greenAccent,),
                  title: Text(
                    'Distributer: ${distributer}',
                    style: stt,
                  ),
                ),
              ),
              Card(
                  elevation: 0,
                 color:color,
                child: ListTile(
                  leading: Icon(Icons.perm_identity,color: Colors.greenAccent,),
                  title: Text(
                    'Retailer: ${retailer}',
                    style: stt,
                  ),
                ),
              ),
              Card(
                  elevation: 0,
                 color:color,
                child: ListTile(
                  leading: Icon(Icons.perm_identity,color: Colors.greenAccent,),
                  title: Text(
                    'Expiry Date: ${expirydate.split(' ')[0]}',
                    style: stt,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}








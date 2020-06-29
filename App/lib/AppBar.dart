import 'package:flutter/material.dart';
class MyAppBar extends StatelessWidget {
  const MyAppBar();


  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
        decoration: BoxDecoration(
          color: Colors.blue[700],
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)
            ) ),
      //color: Colors.greenAccent,
      width: double.infinity,
      padding: EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 45,
          ),
          Text(
            'Medicine Reminder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: deviceWidth * .085,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 45,
          )
        ],
      ),
    );
  }
}

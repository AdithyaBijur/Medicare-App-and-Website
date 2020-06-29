import 'package:flutter/material.dart';
// import 'package:medicare/barcode.dart';
import 'package:medicare/homepage.dart';
import 'package:medicare/loginhome.dart';
import './splashpage.dart';
import './loginpage.dart';
import './registration.dart';
import './success.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

 
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Medicare',
        theme: ThemeData(
          primarySwatch:Colors.lightGreen
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/success': (BuildContext context) => SuccessScreen(),
        });
  }
}

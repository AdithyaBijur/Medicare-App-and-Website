// import 'dart:html';
import 'package:mongo_dart_query/mongo_dart_query.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicare/transmodel.dart';
import './success.dart';
import 'package:medicare/web3.dart';
import 'package:medicare/stocks.dart';
import 'package:web3dart/web3dart.dart';
import './models/transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'details.dart';
import 'dart:async';
import './MedReminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final String uid;
  final String uname;

  HomePage({this.uid,this.uname});
}

enum Answers { YES, NO }

class _HomePageState extends State<HomePage> {
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  var _db;
  String _currentAddress;
  var medicalsNearUser = [];

  final firestore = Firestore.instance;
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  var shown = [];
  List<Transactions> transactions = [
// Transactions(id:'101',name:'Vicks',manufacturer: 'adithya',distributer: 'dist',retailer: 're',soldstatus:true,expired: true,expiry:''),
// Transactions(id:'102',name:'Crocin',manufacturer: 'adithya',distributer: 'dist',retailer: 're',soldstatus:true,expired: true,expiry:'')
// ,Transactions(id:'103',name:'Zzzzz',manufacturer: 'adithya',distributer: 'dist',retailer: 're',soldstatus:true,expired: true,expiry: '')
// ,Transactions(id:'104',name:'Halls',manufacturer: 'adithya',distributer: 'dist',retailer: 're',soldstatus:true,expired: true,expiry: '')
  ];
  getdate(String d) {
    //   Sun Jan 05 2020 16:14:14 GMT+0530 (India Standard Time)
    List arr = d.split(' ');
    String month, day, year, date;
    day = arr[2];
    year = arr[3];
    switch (arr[1]) {
      case "Jan":
        {
          month = '01';
          break;
        }
      case 'Feb':
        {
          month = '02';
          break;
        }
      case 'Mar':
        {
          month = '03';
          break;
        }
      case 'Apr':
        {
          month = '04';
          break;
        }
      case 'May':
        {
          month = '05';
          break;
        }
      case 'Jun':
        {
          month = '06';
          break;
        }

      case 'Jul':
        {
          month = '07';
          break;
        }
      case 'Aug':
        {
          month = '08';
          break;
        }
      case 'Sep':
        {
          month = '09';
          break;
        }
      case 'Oct':
        {
          month = '10';
          break;
        }
      case 'Nov':
        {
          month = '11';
          break;
        }
      case 'Dec':
        {
          month = '12';
          break;
        }
    }

    date = year + '-' + month + '-' + day + ' ' + arr[4];
    return (date);
  }

  checkexpiry(String d, String name, String id) {
    //   Sun Jan 05 2020 16:14:14 GMT+0530 (India Standard Time)
    String date = getdate(d);
    DateTime myDatetime = DateTime.parse(date);
    if (DateTime.now().isAfter(myDatetime)) {
      if (!shown.contains(id)) {
        _showNotificationWithDefaultSound(name, id);
        shown.add(id);
      }
      return true;
    } else
      return false;
  }

  cexp(String d) //for medicine add bug..
  {
    String date = getdate(d);
    DateTime myDatetime = DateTime.parse(date);
    if (DateTime.now().isAfter(myDatetime))
      return true;
    else
      return false;
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      this.getConnection(place.locality);
    } catch (e) {
      print(e);
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();

      var x = new BigInt.from(int.parse(qrResult));
      Future<List> a = web(x);
      a.then((value) async {
        print(value);
        if (value[0] != '') {
          Text exp;
          if (cexp(value[6].toString())) {
            exp = new Text("Expiry Status : True",
                style: TextStyle(fontSize: 17));
            value[5] = true;
          } else {
            exp = new Text("Expiry Status : False",
                style: TextStyle(fontSize: 17));
            value[5] = false;
          }

          await showDialog(
              context: context,
              child: new SimpleDialog(
                title: new Text("Medicine Details"),
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(30.0),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            "Name : " + value[0],
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 5),
                          new Text(
                            "Manufacture : " + value[1],
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 5),
                          Text("Distributor : " + value[2],
                              style: TextStyle(fontSize: 17)),
                          SizedBox(height: 5),
                          new Text("Retailer : " + value[3],
                              style: TextStyle(fontSize: 17)),
                          SizedBox(height: 5),
                          new Text("Sell status : " + value[4].toString(),
                              style: TextStyle(fontSize: 17)),
                          SizedBox(height: 5),
                          exp,
                          SizedBox(height: 5),
                          new Text("Expiry Date : " + value[6].toString(),
                              style: TextStyle(fontSize: 17)),
                          SizedBox(height: 5),
                          new Text(""),
                          value[4]
                              ? new Text("")
                              : new Text(
                                  "This Medicine is not allowed to sell please return it",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.red)),
                          value[5]
                              ? new Text("This Medicine is Expired",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.red))
                              : new Text(""),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                      padding: new EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          value[4]
                              ? value[5]
                                  ? new SimpleDialogOption(
                                      child: new Text(""),
                                      onPressed: null,
                                    )
                                  : new SimpleDialogOption(
                                      child: new Text("Save"),
                                      onPressed: () {
                                        bool dup = false;
                                        // Navigator.pop(context, Answers.YES);
                                        for (int i = 0; //checking duplicates
                                            i < transactions.length;
                                            i++) {
                                          if (transactions[i].id == qrResult) {
                                            dup = true;
                                          }
                                        }

                                        if (dup) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        Text("Medicine Alert"),
                                                    content: Text(
                                                        "Medicine Already Scanned"),
                                                  ));
                                        } else if (value[4] == true) {
                                          Firestore.instance
                                              .collection("users")
                                              .document(widget.uid)
                                              .collection('medicine')
                                              .document()
                                              .setData({
                                            "mid": qrResult,
                                            "name": value[0],
                                            "manufacturer": value[1],
                                            "distributer": value[2],
                                            "retailer": value[3],
                                            "soldstatus": value[4],
                                            "expiry": value[5],
                                            "expirydate": value[6],
                                          });
                                          print("Successfully Stored");
                                          this.setState(() {
                                            this.getmedicine();
                                          });
                                          // Navigator.pop(context, Answers.YES);
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return SuccessScreen();
                                            },
                                          ));
                                        } else {
                                          print("sold status is not true");
                                          Navigator.pop(context, Answers.YES);
                                        }
                                      },
                                    )
                              : new SimpleDialogOption(
                                  child: new Text(""),
                                  onPressed: null,
                                ),
                          new SimpleDialogOption(
                            child: new Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context, Answers.NO);
                            },
                          ),
                        ],
                      ))
                ],
              ));
        } else {
          await showDialog(
              context: context,
              child: new SimpleDialog(
                title: new Text(
                  "No Such Medicine",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(30.0),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            "This medicine is not registered",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                      padding: new EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new SimpleDialogOption(
                            child: new Text(
                              "ok",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, Answers.NO);
                            },
                          ),
                        ],
                      ))
                ],
              ));
        }
      }).catchError((error) => print(error));
      // You can call your etherium method with id of qrResult

    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        print("Camera Permission Denied");
        setState(() {});
      } else {
        print("unknown error");
        setState(() {});
      }
    } on FormatException {
      print("You pressed back button");
      setState(() {});
    } catch (e) {
      print("Unknown error");
      setState(() {});
    }
  }

  Future getConnection(String city) async {
    try {
      _db = Db("mongodb://moksh:moksh123@ds043324.mlab.com:43324/medsdapp");
      await _db.open();
    } catch (e) {
      print(e);
    }
    print(city);
    var coll = _db.collection('users');
    var tp = medicalsNearUser = await coll
        .find(where.eq("city", city).eq("typeofuser", "Retailer"))
        .toList();

    this.setState(() {
      medicalsNearUser = tp;
    });
    print(medicalsNearUser);
    blockchain();
  }

  Future blockchain() async {
    var medi = myController.text;
    var list = [];

    for (var i = 0; i < medicalsNearUser.length; i++) {
      list.add(EthereumAddress.fromHex(medicalsNearUser[i]['address']));
    }
    print('zzzz');
    print(medi);
    print(list);
    Future<List> a = stocks(list, medi);
    a.then((value) async {
      print('hello');
      print(value);
      var count = 0;
      var temp = value[0];
      if (medi == '') {
        print('inside');
        return;
      } else {
        print('insidesss');

        for (int i = 0; i < value[0].length; i++) {
          print(temp[i]);
          if (int.parse(temp[i].toString()) == 0) {
            print('yes');
            medicalsNearUser.removeAt(i - count);
            count += 1;
          }
        }
        this.setState(() {
          medicalsNearUser = [...medicalsNearUser];
        });
        print(medicalsNearUser);
      }
    });

    this.setState(() {
      medicalsNearUser = [...medicalsNearUser];
    });
  }

  @override
  initState() {
    print('sdgdfg');
    this._getCurrentLocation();
    this.getmedicine();
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("PayLoad"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
  }

  Future _showNotificationWithDefaultSound(String name, String id) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      int.parse(id),
      'Expiry Alert',
      'Your medicine ${name} with ID ${id} is expired!',
      platformChannelSpecifics,
      payload: 'Your medicine ${name} with ID ${id} is expired!',
    );
  }

  void getmedicine() {
    setState(() {
      transactions = [];
    });
    final messages = Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection('medicine')
        .getDocuments();
    messages.then((onValue) {
      var t = onValue.documents;
      for (var i in t) {
        print(i.documentID);
        transactions
            .add(new Transactions.fromJson({...i.data, 'did': i.documentID}));
      }
      setState(() {
        transactions = transactions;
      });
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  void _startAddNewTransaction(BuildContext ctx, trans) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Model(
            id: trans.id,
            name: capitalize(trans.name),
            manufacturer: trans.manufacturer,
            retailer: trans.retailer,
            distributer: trans.distributer,
            soldstatus: trans.soldstatus,
            expired: trans.expired,
            expirydate: this.getdate(trans.expiry).toString(),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _showinfo(BuildContext ctx, name) {
    var detail;
    const n = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const d = TextStyle(fontSize: 17, fontStyle: FontStyle.normal);
    final detaill = Firestore.instance
        .collection("medicined")
        .where('name', isEqualTo: name)
        .snapshots()
        .listen((data) {
      if (data.documents.isEmpty)
        detail = 'No detail available';
      else
        data.documents.forEach((doc) => detail = doc['detail']);
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: n,
                  ),
                  SizedBox(height: 30),
                  Center(child: Text(detail, style: d)),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Details(medName: capitalize(name));
                        },
                      ));
                    },
                    child: Text('More Info'),
                  )
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        },
      );
    });
  }

  void delete(String id) async {
    print(id);
    await Firestore.instance
        .collection("users")
        .document(widget.uid)
        .collection('medicine')
        .document(id)
        .delete();
    setState(() {
      transactions.removeWhere((tx) {
        return tx.did == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        semanticLabel: 'Medicare',
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 10),
                    Text('Welcome '+widget.uname,
                        style: TextStyle(fontSize: 23, color: Colors.white)),
                    SizedBox(height: 10)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                "Scanner",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacement(context,   MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(uname: widget.uname,uid:widget.uid)));
                      
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Medicine Reminder", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MedReminder(uname: widget.uname,uid:widget.uid,)));
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Logout", style: TextStyle(fontSize: 20)),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) => Navigator.pushNamed(context, "/login"))
                    .catchError((err) => print(err));
              },
            ),
          ],
        ),
      ),
      // appBar: AppBar(
      //   title: Text('Your History'),
      //   actions: <Widget>[
      //     FlatButton(
      //         onPressed: () {
      //           FirebaseAuth.instance
      //               .signOut()
      //               .then((result) =>
      //                   Navigator.pushReplacementNamed(context, "/login"))
      //               .catchError((err) => print(err));
      //         },
      //         child: Icon(Icons.exit_to_app))
      //   ],
      // ),
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        color: Colors.black,
                        onPressed: () {
                          FirebaseAuth.instance
                              .signOut()
                              .then((result) => Navigator.pushReplacementNamed(
                                  context, "/login"))
                              .catchError((err) => print(err));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Your History',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color.fromRGBO(68, 215, 168, 1)),
                  ),
                  SizedBox(height: 10),
                  //    Text('Medicines Scanned',style:TextStyle(fontSize: 15,color: Color.fromRGBO(68, 215, 168,1)))
                  Expanded(
                    child: Container(
                      child: transactions.isEmpty
                          ? Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'No transactions added yet!',
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    height: 200,
                                    child: Image.asset(
                                      'assets/images/waiting.png',
                                      fit: BoxFit.cover,
                                    )),
                              ],
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _startAddNewTransaction(
                                        ctx, transactions[index]);
                                  },
                                  onLongPress: () {
                                    // _showinfo(ctx, transactions[index].name);
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Details(
                                            medName: capitalize(
                                                transactions[index].name));
                                      },
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 5,
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(10),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: FittedBox(
                                              child:
                                                  Text(transactions[index].id),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          capitalize(transactions[index].name),
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 5),
                                            Text(
                                                'Expiry: ${this.getdate(transactions[index].expiry)}'),
                                            SizedBox(height: 5),
                                            this.checkexpiry(
                                                    transactions[index].expiry,
                                                    transactions[index].name,
                                                    transactions[index].id)
                                                ? Text(
                                                    'Status : Expired',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                : Text('Status: Not expired'),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () =>
                                              delete(transactions[index].did),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: transactions.length,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Scaffold(
              backgroundColor: Color.fromRGBO(68, 215, 168, 1),
              body: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0))),
                  margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
                    child: Column(children: <Widget>[
                      Column(
                        children: <Widget>[
                          if (_currentPosition != null &&
                              _currentAddress != null)
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text(
                                  ' ${_currentAddress.split(',')[0]}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green.shade400),
                                ),
                              ],
                            ),
                          SizedBox(height: 50),
                          // Text('Enter the medicine name',style: TextStyle(fontSize: 20),),
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Search Location ",
                                // fillColor: Colors.white

                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                fillColor: Colors.green),
                            controller: myController1,
                            onFieldSubmitted: (text) {
                              getConnection(myController1.text); //Change
                            },
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 25),
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Search Medicine ",
                                // fillColor: Colors.white

                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                fillColor: Colors.green),
                            controller: myController,
                            onFieldSubmitted: (text) {
                              if (myController1.text == '')
                                getConnection('Vasai-Virar');
                              else
                                getConnection(myController1.text); //Change
                            },
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Expanded(
                        child: medicalsNearUser.isEmpty
                            ? Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      'No stores in your area!',
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      height: 200,
                                      child: Image.asset(
                                        'assets/images/waiting2.png',
                                        fit: BoxFit.cover,
                                      )),
                                ],
                              )
                            : ListView.builder(
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // _startAddNewTransaction(ctx, transactions[index]);
                                    },
                                    onDoubleTap: () {
                                      // _showinfo(ctx, transactions[index].name);
                                    },
                                    child: Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 5,
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.business,
                                          color: Colors.green.shade400,
                                        ),
                                        title: Text(
                                          capitalize(
                                              medicalsNearUser[index]['name']),
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.directions,
                                                color: Colors.green.shade400),
                                            onPressed: () => {}),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: medicalsNearUser.length,
                              ),
                      )
                    ]),
                  )),
            ),
          ],
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Scan",
          style: TextStyle(fontSize: 18),
        ),
        icon: Icon(Icons.camera_alt),
        onPressed: _scanQR,
      ),
    );
  }
}

//  if (_currentPosition != null && _currentAddress != null)
//                   Text('Your current location is ${_currentAddress}'),
//                 Text('Enter the medicine name'),
//                 TextField(
//                   controller: myController,
//                   onSubmitted: (text) {
//                     print(text + myController.text);
//                   },
//                 )

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './AddMedicine.dart';
import './MedicineGrid.dart';
import './AppBar.dart';
import 'NotificationManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
class MedReminder extends StatefulWidget {
  @override
final String uname;
final String uid;
  _MedReminderState createState() => _MedReminderState();
MedReminder({this.uname,this.uid});
}

class _MedReminderState extends State<MedReminder> {
  void initState()
  {
    getshared();
    
  final NotificationManager notif= new NotificationManager();
  }
  void getshared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey('mid');
    if(CheckValue==false) { prefs.setInt('mid',1);}
 
     }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                        builder: (BuildContext context) => HomePage(uname: widget.uname,uid: widget.uid,)));
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Medicine Reminder", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MedReminder(uname: widget.uname,uid: widget.uid,)));
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
      body: 

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        Container(
          
          child: Column(
            
       
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               MyAppBar(),
               SizedBox(height:0),
             MedicineGrid()
            ],
          ),
        ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>buildBottomSheet(context),
        tooltip: 'Add Medicine',
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


  void buildBottomSheet(BuildContext context) async {
      showModalBottomSheet(
        isScrollControlled:true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (_) {
        return GestureDetector(
          
          onTap: () {},
          child:AddMedicine(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
        
        
}
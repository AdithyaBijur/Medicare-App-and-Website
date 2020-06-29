import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './success.dart';
import 'NotificationManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MultiSelect.dart';

class AddMedicine extends StatefulWidget {
  AddMedicine();

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  List<String> reportList = [
    "4 hrs",
    "6 hrs",
    "8 hrs",
    "12 hrs",
    "16 hrs",
    "24 hrs",
  ];
  String selectedChoice = "0";
  // List<String> selectedReportList = List();

  static final _formKey = new GlobalKey<FormState>();
  NotificationManager notif = new NotificationManager();
  String _name;
  String _dose;
  FirebaseUser user;
  SharedPreferences prefs;
  String _desc;
  int mid;
  TimeOfDay _time = TimeOfDay.now();

  Future selectTime(BuildContext context) async {
    _time = await showTimePicker(context: context, initialTime: _time);
    if (_time == null) _time = TimeOfDay.now();
  }

  void initState() {
    getUser();
  }

  void getUser() async {
    prefs = await SharedPreferences.getInstance();
    mid = prefs.getInt('mid');
    user = await FirebaseAuth.instance.currentUser();
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          label: Text(
            item,
            style: TextStyle(fontSize: 20),
          ),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  int _selectedIndex = 0;
  List<String> _icons = [
    'drug.png',
    'pill_rounded.png',
    'pill.png',
    'syringe.png',
    'ointment.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.fromLTRB(25, 20, 25, 5),
      child: SafeArea(
         
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
               
                    'Add New Medicine',
                    
                    style: TextStyle(
                      
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // back to main screen
                      Navigator.pop(context, null);
                    },
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: Theme.of(context).primaryColor.withOpacity(.65),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              _buildForm(),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shape',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              _buildShapesList(),
              SizedBox(
                height: 35,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start Time:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  )),
              Container(
                child: IconButton(
                    icon: Icon(Icons.alarm),
                    tooltip: "Select Time",
                    iconSize: 50,
                    onPressed: () {
                      selectTime(context);
                    }),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Interval:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  )),
              SizedBox(height: 20),
              Wrap(children: _buildChoiceList()),

              // MultiSelectChip(
              //   reportList,
              //   onSelectionChanged: (selectedList) {
              //     setState(() {
              //       selectedReportList = selectedList;
              //     });
              //   },
              // ),

              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    int interval = 0;
                    if (selectedChoice.length > 4)
                      interval = int.parse(
                          selectedChoice.substring(0, selectedChoice.length - 4));
                    // print(selectedReportList);
                    if (_formKey.currentState.validate()) {
                      // form is validated
                      _formKey.currentState.save();
                      print('hello');
                      print(mid);
                      if (interval == 0) {
                        notif.showNotificationDaily(
                            mid + 1,
                            _name,
                            'Take ${_dose} of ${_name} for ${_desc}',
                            _time.hour,
                            _time.minute);
                        prefs.setInt('mid', mid + 1);
                      } else {
                        int hour = _time.hour;
                        int minute = _time.minute;
                        int i;
                        for (i = 0; i < (24 / interval).floor(); i++) {
                          if ((hour + (interval * i) > 23)) {
                            hour = hour + (interval * i) - 24;
                          } else {
                            hour = hour + (interval * i);
                          }
                          notif.showNotificationDaily(
                              mid + 1 + i,
                              _name,
                              'Take ${_dose} of ${_name} for ${_desc}',
                              hour,
                              minute);
                          hour=_time.hour;
                        }
                        prefs.setInt('mid', mid + i + 1);
                      }
                      String time;
                      if (selectedChoice != '0' && selectedChoice != '24 hrs') {
                        time = selectedChoice;
                      } else
                        time = _time.toString().substring(10, 15);

                      //  print(_name);
                      //  print(_dose);
                      //  print(_time);
                      //  print(_icons[_selectedIndex]);
                      Firestore.instance.collection("reminders").add({
                        "mid": mid + 1,
                        "user": user.uid,
                        "name": _name,
                        "dose": _dose,
                        "desc": _desc,
                        "type": _icons[_selectedIndex],
                        "time": time,
                      });

                      print('zzzzzz');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SuccessScreen();
                        },
                      ));
                    }
                  },
                  color: Colors.blue[700],
                  textColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Add Medicine'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildShapesList() {
    return Container(
      width: double.infinity,
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _icons
            .asMap()
            .entries
            .map((MapEntry map) => _buildIcons(map.key))
            .toList(),
      ),
    );
  }

  Form _buildForm() {
    TextStyle labelsStyle =
        TextStyle(fontWeight: FontWeight.w400, fontSize: 25);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(fontSize: 25),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input.length < 3) ? 'Name is short' : null,
            onChanged: (input) => _name = input,
          ),
          TextFormField(
            style: TextStyle(fontSize: 25),
            decoration: InputDecoration(
              labelText: 'Dose',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input.length < 1) ? 'Dose is empty' : null,
            onChanged: (input) => _dose = input,
          ),
          TextFormField(
            style: TextStyle(fontSize: 25),
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input.length < 1) ? 'Desc is empty' : null,
            onChanged: (input) => _desc = input,
          )
        ],
      ),
    );
  }

  // void _submit(NotificationManager manager) async {
  //   if (_formKey.currentState.validate()) {
  //     // form is validated
  //     _formKey.currentState.save();
  //     print(_name);
  //     print(_dose);
  //     //show the time picker dialog
  //     showTimePicker(
  //       initialTime: TimeOfDay.now(),
  //       context: context,
  //     ).then((selectedTime) async {
  //       int hour = selectedTime.hour;
  //       int minute = selectedTime.minute;
  //       print(selectedTime);
  //       // insert into database
  //       // var medicineId = await widget._database.insertMedicine(                       //1
  //       //     MedicinesTableData(
  //       //         name: _name,
  //       //         dose: _dose,
  //       //         image: 'assets/images/' + _icons[_selectedIndex]));
  //       // // sehdule the notification
  //       // manager.showNotificationDaily(medicineId, _name, _dose, hour, minute);
  //       // // The medicine Id and Notitfaciton Id are the same
  //       // print('New Med id' + medicineId.toString());
  //       // // go back
  //       // Navigator.pop(context);
  //     });
  //   }
  // }

  Widget _buildIcons(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(11),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: (index == _selectedIndex)
              ? Colors.greenAccent.withOpacity(.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset(
          'assets/images/' + _icons[index],
          color: Colors.blue[700],
        ),
      ),
    );
  }
}

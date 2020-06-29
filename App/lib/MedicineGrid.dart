import 'package:flutter/material.dart';
import 'MedicineCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MedicineGrid extends StatefulWidget {
  @override
  _MedicineGridState createState() => _MedicineGridState();
  
}

class _MedicineGridState extends State<MedicineGrid> {
  // final _listItem=[MedicineCard(medName: 'Crocin',medDose: '5',medTime: '8:30',),];
  String uid=' ';
    user() {
     
    FirebaseAuth.instance.currentUser().then((result){ 
      setState(() {
         this.uid=result.uid;
         
      });    });
     
  
  }

void initState(){
  user();
}

  Widget build(BuildContext context) {
    return Expanded(
               
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    
                    child:
                    StreamBuilder(stream:Firestore.instance.collection('reminders').where('user',isEqualTo: this.uid).snapshots(),
                    builder:(context,snapshot)
                    {
                      if(!snapshot.hasData) return const Text('Loading..');
                      if (snapshot.data.documents.length==0)
                      return (
                        Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'No medicines added yet!',
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
                            );
                      return new GridView.builder(
    itemCount:snapshot.data.documents.length,
    gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(
                                   
                       childAspectRatio: (180 / 220),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20, ),
    itemBuilder: (BuildContext context, int index) {
      
     return MedicineCard(medName: snapshot.data.documents[index]['name'],
     mid:snapshot.data.documents[index]['mid'] ,
      medDose: snapshot.data.documents[index]['dose'] ,
      desc: snapshot.data.documents[index]['desc'],
      type: snapshot.data.documents[index]['type'],
      document: snapshot.data.documents[index],
       medTime:snapshot.data.documents[index]['time']);
    });
                    }
                    ))
                    // GridView.count(
                      // padding: EdgeInsets.all(2),
                      //  childAspectRatio: (180 / 250),
                      // crossAxisCount: 2,
                      // crossAxisSpacing: 20,
                      // mainAxisSpacing: 20,
                    //   children: _listItem
                    //       ),
                  ),
                )
                    ;
  }
}
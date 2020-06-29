import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'NotificationManager.dart';

class MedicineCard extends StatelessWidget {
  DocumentSnapshot document;
  final int mid;
  NotificationManager notif= NotificationManager();
  final String medName;
  final String medDose;
  final String medTime;
  final String type;
  final String desc;
  
  MedicineCard({
   this.mid, this.medName,this.medDose,this.medTime,this.desc,this.type,this.document
  });
showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.pop(context);},
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      document.reference.delete();
      notif.removeReminder(mid);
      
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete"),
    content: Text("Would you like to delete?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress:(){showAlertDialog(context);} ,
          child: Container(
            padding: EdgeInsets.all(3),
  
        width: 180,
        height: 180,
        color: Colors.white,
        child: Container(
        
          decoration: BoxDecoration(
             boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0, // has the effect of softening the shadow
          spreadRadius: 0, // has the effect of extending the shadow
          offset: Offset(
          -2.0, // horizontal, move right 10
            2.0, // vertical, move down 10
          ),
        )
      ],
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
               Radius.circular(20)
              ) ),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(

                margin: EdgeInsets.all(10),
                
                width: 50,
                height: 50,
                
                child: Hero(
                  tag: medName,
                  child: Image.asset(
                    'assets/images/'+type,
                    fit: BoxFit.contain,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                     this.medName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                          fontSize: width * .065),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    this.medDose.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: width * .055,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
                  Expanded(
                child: Center(
                  child: Text(
                    desc.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: width * .040,
                      color:Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
            Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: Container(
                      child: Text(
                       this.medTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blueGrey,
                           fontWeight: FontWeight.w600,
                            fontSize: width * .06),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

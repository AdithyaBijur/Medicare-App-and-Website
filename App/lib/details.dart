import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String medName;
  Details({this.medName});

  @override
  _DetailsState createState() => _DetailsState(this.medName);
}

class _DetailsState extends State<Details> {
  String medName;
  _DetailsState(this.medName);

  final sideEffects = {'Crosin':['Rash', 'Itching','Dizziness','Breathing Trouble'],
  'Guaifenesin':['Nausea','Vomiting','Alergic Reactions','Dizziness']};
  final cures={'Crosin':['Headache','Fever','Body Ache','Pain of Arthritis'],'Guaifenesin':['Headache','Fever','Cough']};
  final contents = {'Crosin':['Paracetemol (50mg)','Magnesium (10mg)', 'Iron (10mg)'],'Guaifenesin':['anhydrous citric acid','glycerin','propylene glycol','sorbitol','sodium citrate']};
  final desc = {'Crosin':"This Tablet is one of the most common analgesic pain-relievers in India. It contains Paracetamol – 500mg to treat mild to moderate body aches. ... There are several types of Crocin Tablets available in the market – Crocin Cold and Flu Max, Crocin Advance , Crocin Pain Relief, etc",
  'Guaifenesin':"Guaifenesin is used to treat coughs and congestion caused by the common cold, bronchitis, and other breathing illnesses. This product is usually not used for ongoing cough from smoking or long-term breathing problems (such as chronic bronchitis, emphysema) unless directed by your doctor. Guaifenesin is an expectorant.",
  };

  void getDetails() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const heading = TextStyle(fontWeight: FontWeight.bold, fontSize: 40);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: 220.0,
          color: Color.fromRGBO(68, 215, 168, 1),
        ),
        Positioned(
          left: screenWidth / 2 + 25.0,
          bottom: screenHeight - 175.0,
          child: Hero(
            tag: 'heroTag',
            child: Container(
              height: 250.0,
              width: 250.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Positioned(
          top: 120.0,
          child: Container(
            height: screenHeight - 180.0,
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0))),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Container(
                    width: screenWidth - 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          this.medName,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 30.0),
                        ),
                        // Container(
                        //   height: 40.0,
                        //   width: 100.0,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12.0),
                        //     color: Color(0xFF20D3D2),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       'Buy',
                        //       style: TextStyle(
                        //           fontFamily: 'Montserrat',
                        //           fontWeight: FontWeight.w900,
                        //           fontSize: 14.0,
                        //           color: Colors.white),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 15.0),
                  child: Text(
                     desc.containsKey(this.medName)?desc[this.medName]:'No description',
                
                    style: TextStyle(
                          
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 15.0),
                  child: Text(
                    'Contents',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0, top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                          children: contents.containsKey(this.medName)?contents[this.medName]
                              .map((item) => new Column(
                                    children: <Widget>[
                                      _buildBulletList(
                                          item,
                                          screenWidth),
                                    ],
                                  ))
                              .toList():<Widget>[Text('No contents')]       
                              ),
                             SizedBox(height: 15.0),
                      Text('Cures',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 22.0,
                          )),
                          SizedBox(height: 5,),
                      Column(
                          children: cures.containsKey(this.medName)?cures[this.medName]
                              .map((item) => new Column(
                                    children: <Widget>[
                                      _buildBulletList(
                                          item,
                                          screenWidth),
                                    ],
                                  ))
                              .toList():<Widget>[Text('No information')]       
                              ),
                  
                             SizedBox(height: 15.0),
                      Text('Side Effects',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 22.0,
                          )),
                          SizedBox(height: 5,),
                      Column(
                          children:sideEffects.containsKey(this.medName)?sideEffects[this.medName]
                              .map((item) => new Column(
                                    children: <Widget>[
                                      _buildBulletList(
                                          item,
                                          screenWidth),
                                    ],
                                  ))
                              .toList():<Widget>[Text('No SideEffects')]      
                              ),
                             SizedBox(height: 15.0),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }

  _buildBulletList(String content, double screenWidth) {
    return Container(
      width: screenWidth,
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: Color(0xFF25BEBD),
                borderRadius: BorderRadius.circular(4.0)),
          ),
          SizedBox(width: 10.0),
          Container(
            width: screenWidth - 60.0,
            child: Text(content,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ) // color: Color(0xFFBBBBBB)),
                ),
          )
        ],
      ),
    );
  }

 
}

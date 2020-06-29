// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginScreen3 extends StatefulWidget {
//   @override
//   _LoginScreen3State createState() => new _LoginScreen3State();
// }



// class _LoginScreen3State extends State<LoginScreen3>
//     with TickerProviderStateMixin {

//   @override
//   void initState() {
//     super.initState();
//   }
//   final _firebaseAuth=FirebaseAuth.instance;
//   String email;
//  String password;

//  Future<String> signIn(String email, String password) async {
//     AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//     FirebaseUser user = result.user;
//     return user.uid;
//   }

//   Future<String> signUp(String email, String password) async {
//     AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     FirebaseUser user = result.user;
//     return user.uid;
//   }

//   Future<FirebaseUser> getCurrentUser() async {
//     FirebaseUser user = await _firebaseAuth.currentUser();
//     return user;
//   }

//   Future<void> signOut() async {
//     return _firebaseAuth.signOut();
//   }

//   Future<void> sendEmailVerification() async {
//     FirebaseUser user = await _firebaseAuth.currentUser();
//     user.sendEmailVerification();
//   }

//   Future<bool> isEmailVerified() async {
//     FirebaseUser user = await _firebaseAuth.currentUser();
//     return user.isEmailVerified;
//   }

//   @override


//   Widget HomePage() {
//     return Scaffold(
//           body: new Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           color: Colors.redAccent,
//           image: DecorationImage(
//             colorFilter: new ColorFilter.mode(
//                 Colors.black.withOpacity(0.1), BlendMode.dstATop),
//             image: AssetImage('assets/images/mountains.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: new Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.only(top: 250.0),
//               child: Center(
//                 child: Icon(
//                   Icons.headset_mic,
//                   color: Colors.white,
//                   size: 40.0,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20.0),
//               child: new Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     "Awesome",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                   Text(
//                     "App",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
//               alignment: Alignment.center,
//               child: new Row(
//                 children: <Widget>[
//                   new Expanded(
//                     child: new OutlineButton(
//                       shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(30.0)),
//                       color: Colors.redAccent,
//                       highlightedBorderColor: Colors.white,
//                       onPressed: () => gotoSignup(),
//                       child: new Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 20.0,
//                           horizontal: 20.0,
//                         ),
//                         child: new Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Expanded(
//                               child: Text(
//                                 "SIGN UP",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
//               alignment: Alignment.center,
//               child: new Row(
//                 children: <Widget>[
//                   new Expanded(
//                     child: new FlatButton(
//                       shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(30.0)),
//                       color: Colors.white,
//                       onPressed: () => gotoLogin(),
//                       child: new Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 20.0,
//                           horizontal: 20.0,
//                         ),
//                         child: new Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Expanded(
//                               child: Text(
//                                 "LOGIN",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: Colors.redAccent,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget LoginPage() {

//     return Scaffold(
//           body: SingleChildScrollView(
//                       child: new Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             image: DecorationImage(
//               colorFilter: new ColorFilter.mode(
//                   Colors.black.withOpacity(0.05), BlendMode.dstATop),
//               image: AssetImage('assets/images/mountains.jpg'),
//               fit: BoxFit.cover,
//             ),
//         ),
//         child: new Column(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.all(100.0),
//                 child: Center(
//                   child: Icon(
//                     Icons.headset_mic,
//                     color: Colors.redAccent,
//                     size: 50.0,
//                   ),
//                 ),
//               ),
//               new Row(
//                 children: <Widget>[
//                   new Expanded(
//                     child: new Padding(
//                       padding: const EdgeInsets.only(left: 40.0),
//                       child: new Text(
//                         "EMAIL",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               new Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                         color: Colors.redAccent,
//                         width: 0.5,
//                         style: BorderStyle.solid),
//                   ),
//                 ),
//                 padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//                 child: new Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     new Expanded(
//                       child: TextField(
//                         onChanged: (value){
//                           email=value;
//                         },
//                         obscureText: true,
//                         textAlign: TextAlign.left,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'samarthagarwal@live.com',
//                           hintStyle: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 height: 24.0,
//               ),
//               new Row(
//                 children: <Widget>[
//                   new Expanded(
//                     child: new Padding(
//                       padding: const EdgeInsets.only(left: 40.0),
//                       child: new Text(
//                         "PASSWORD",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               new Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                         color: Colors.redAccent,
//                         width: 0.5,
//                         style: BorderStyle.solid),
//                   ),
//                 ),
//                 padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//                 child: new Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     new Expanded(
//                       child: TextField(
//                         onChanged: (value){
//                           password=value;
//                         },
//                         obscureText: true,
//                         textAlign: TextAlign.left,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: '*********',
//                           hintStyle: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 height: 24.0,
//               ),
//               new Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20.0),
//                     child: new FlatButton(
//                       child: new Text(
//                         "Forgot Password?",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                           fontSize: 15.0,
//                         ),
//                         textAlign: TextAlign.end,
//                       ),
//                       onPressed: () => {},
//                     ),
//                   ),
//                 ],
//               ),
//               new Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
//                 alignment: Alignment.center,
//                 child: new Row(
//                   children: <Widget>[
//                     new Expanded(
//                       child: new FlatButton(
//                         shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(30.0),
//                         ),
//                         color: Colors.redAccent,
//                         onPressed: () => {},
//                         child: new Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 20.0,
//                             horizontal: 20.0,
//                           ),
//                           child: new Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               new Expanded(
//                                 child: Text(
//                                   "LOGIN",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),]))));
             
//   }

//   Widget SignupPage() {
//     return Scaffold(
//           body: new Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//             colorFilter: new ColorFilter.mode(
//                 Colors.black.withOpacity(0.05), BlendMode.dstATop),
//             image: AssetImage('assets/images/mountains.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: new Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(70.0),
//               child: Center(
//                 child: Icon(
//                   Icons.headset_mic,
//                   color: Colors.redAccent,
//                   size: 50.0,
//                 ),
//               ),
//             ),
//             new Row(
//               children: <Widget>[
//                 new Expanded(
//                   child: new Padding(
//                     padding: const EdgeInsets.only(left: 40.0),
//                     child: new Text(
//                       "EMAIL",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         fontSize: 15.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                       color: Colors.redAccent,
//                       width: 0.5,
//                       style: BorderStyle.solid),
//                 ),
//               ),
//               padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//               child: new Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   new Expanded(
//                     child: TextField(
//                       onChanged: (value){
//                         email=value;
//                       },
//                       obscureText: true,
//                       textAlign: TextAlign.left,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'samarthagarwal@live.com',
//                         hintStyle: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               height: 24.0,
//             ),
//             new Row(
//               children: <Widget>[
//                 new Expanded(
//                   child: new Padding(
//                     padding: const EdgeInsets.only(left: 40.0),
//                     child: new Text(
//                       "PASSWORD",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         fontSize: 15.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                       color: Colors.redAccent,
//                       width: 0.5,
//                       style: BorderStyle.solid),
//                 ),
//               ),
//               padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//               child: new Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   new Expanded(
//                     child: TextField(
//                       onChanged: (value){
//                         password=value;
//                       },
//                       obscureText: true,
//                       textAlign: TextAlign.left,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: '*********',
//                         hintStyle: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               height: 24.0,
//             ),
//             new Row(
//               children: <Widget>[
//                 new Expanded(
//                   child: new Padding(
//                     padding: const EdgeInsets.only(left: 40.0),
//                     child: new Text(
//                       "CONFIRM PASSWORD",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         fontSize: 15.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                       color: Colors.redAccent,
//                       width: 0.5,
//                       style: BorderStyle.solid),
//                 ),
//               ),
//               padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//               child: new Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   new Expanded(
//                     child: TextField(
//                       obscureText: true,
//                       textAlign: TextAlign.left,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: '*********',
//                         hintStyle: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               height: 24.0,
//             ),
//             new Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20.0),
//                   child: new FlatButton(
//                     child: new Text(
//                       "Already have an account?",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.redAccent,
//                         fontSize: 15.0,
//                       ),
//                       textAlign: TextAlign.end,
//                     ),
//                     onPressed: () => {},
//                   ),
//                 ),
//               ],
//             ),
//             new Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
//               alignment: Alignment.center,
//               child: new Row(
//                 children: <Widget>[
//                   new Expanded(
//                     child: new FlatButton(
                    
//                       shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(30.0),
//                       ),
//                       color: Colors.redAccent,
//                       onPressed: ()  async {
//                         try
//                       { final newuser= await auth.createUserWithEmailAndPassword(email:email,password: password);
//                       if(newuser!=null)
//                       {
//                         // Navigator.pushNamed(context,sdsfsf)
//                         print('success');
//                         }
//                       }
//                       catch(e)
//                       {
//                         print(e);
//                       }},
//                       child: new Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 20.0,
//                           horizontal: 20.0,
//                         ),
//                         child: new Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Expanded(
//                               child: Text(
//                                 "SIGN UP",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   gotoLogin() {
//     //controller_0To1.forward(from: 0.0);
//     _controller.animateToPage(
//       0,
//       duration: Duration(milliseconds: 800),
//       curve: Curves.bounceOut,
//     );
//   }

//   gotoSignup() {
//     //controller_minus1To0.reverse(from: 0.0);
//     _controller.animateToPage(
//       2,
//       duration: Duration(milliseconds: 800),
//       curve: Curves.bounceOut,
//     );
//   }

//   PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: MediaQuery.of(context).size.height,

//         child: PageView(
//           controller: _controller,
//           physics: new AlwaysScrollableScrollPhysics(),
          
//           children: <Widget>[LoginPage(), HomePage(), SignupPage()],
//           scrollDirection: Axis.horizontal,
//         ));
//   }
// }
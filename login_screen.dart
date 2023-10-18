
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var apiLink = 'https://www.yahshuapayroll.com/api/api-auth/';

  String username = 'cabic60931@onlcool.com';
  String password = 'Testing@2023';
  Future loginUser() async {
    final response = await http.post(Uri.parse('https://www.yahshuapayroll.com/api/api-auth/'), headers: <String, String> {'Content-Type': 'application/json; charset=UTF-8'},
                                     body: jsonEncode(<String, String> {'username': usernameController.text, 'password': passwordController.text}));
    Map<String, dynamic> jsonDecodedData = jsonDecode(response.body);
    return jsonDecodedData;
  }


  TextEditingController usernameController = TextEditingController();

  _usernameInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * .07, child: Material(
      child: TextField( controller: usernameController, cursorColor: Colors.black,
      style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }


  TextEditingController passwordController = TextEditingController();
  _passwordInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * .07, child: Material(
      child: TextField( controller: passwordController, cursorColor: Colors.black,
      style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(child: Column(children: [
      Container(height: MediaQuery.of(context).size.height * .3,),
     
     
      Container(height: MediaQuery.of(context).size.height * .3,
        child: Column(children: [
          _usernameInput(),
          Container(height: 30),
          _passwordInput(),
          Container(height: 30),
          GestureDetector(onTap: () async {
            var result = await loginUser();
            print(result['success']);
            if (result['success'] != false) {
              Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => 
                HomeScreen() ,transitionDuration: Duration(milliseconds: 10), transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0, 0.0);
                  var end = Offset(0.0, 0.0);
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,);
                  }));
            }
          },
            child: Container(child: Text('Log in', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .032,
              fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),)),
        
          Container(height: 30),
        ],)),
     
     
      Container(height: MediaQuery.of(context).size.height * .3,),
    
    ],))
      
    );
  }
}

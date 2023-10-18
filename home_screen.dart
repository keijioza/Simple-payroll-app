
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    checkUserData();
  }

  List userData = [];
  checkUserData() async {
    var record = await DatabaseManagementTool.instance.checkList();
    setState(() {
      userData = record;
    });
    print(record[0].name['name']);
  }

  TextEditingController usernameController = TextEditingController();

  _usernameInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width * .7, child: Material(
      child: TextField( controller: usernameController, cursorColor: Colors.black,
      style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }


  TextEditingController hourlyController = TextEditingController();
  _hourlyInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width * .7, child: Material(
      child: TextField( controller: hourlyController, cursorColor: Colors.black,
        
        style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }



  updateRecord({id}) {
    return showDialog(context: context, builder: (context) {
      return UpdateRecordPopup(id: id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(child: Column(children: [
      Container(height: MediaQuery.of(context).size.height * .3, child: Column(children: [
        Row(children:[
          Text('Name', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .032,
            fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
          _usernameInput(),  
            ]),
        Row(children:[
          Text('Hourly Rate', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .032,
            fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
          _hourlyInput(),  
            ]),    
        GestureDetector(onTap: () async {
          await DatabaseManagementTool.instance.insertData(UserData(name: usernameController.text, hourly_rate: hourlyController.text, unique_id: userData.length.toString()));
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
          },
            child: Container(child: Text('Input data', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .032,
              fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),))    
      ],)),

     
      Container(height: MediaQuery.of(context).size.height * .3,
        child: ListView.builder(
            padding: EdgeInsets.only(top: 1),
            itemCount: userData.length,
            itemBuilder: (BuildContext context, index) {
              
            return Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userData[index].name['name'], style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Colors.black, fontSize: MediaQuery.of(context).size.height * .020,
                  fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
                Text(userData[index].name['hourly_rate'], style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Colors.black, fontSize: MediaQuery.of(context).size.height * .020,
                  fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
              
                GestureDetector(onTap: () {
                  updateRecord(id: userData[index].name['unique_id']);
                },
                  child: Text('Update', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Colors.red, fontSize: MediaQuery.of(context).size.height * .020,
                   fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),)),
            

                GestureDetector(onTap: () async {
                  await DatabaseManagementTool.instance.deleteRecord(userData[index].name['unique_id']);
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
                },
                  child: Text('Delete', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Colors.red, fontSize: MediaQuery.of(context).size.height * .020,
                    fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),)),
            
            
            ],));}
    
        )),
     
     
      Container(height: MediaQuery.of(context).size.height * .3,),
    
    ],))
      
    ));
  }
}



class UpdateRecordPopup extends StatefulWidget {
  final id;
  UpdateRecordPopup({required this.id});
  @override
  _UpdateRecordPopupState createState() => _UpdateRecordPopupState();

}

class _UpdateRecordPopupState extends State<UpdateRecordPopup> {

  void initState() {
    super.initState();
    print(widget.id);
  }


  TextEditingController usernameController = TextEditingController();

  _usernameInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width * .7, child: Material(
      child: TextField( controller: usernameController, cursorColor: Colors.black,
      style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }


  TextEditingController hourlyController = TextEditingController();
  _hourlyInput() {
    return Container(height: MediaQuery.of(context).size.height * .05, width: MediaQuery.of(context).size.width * .7, child: Material(
      child: TextField( controller: hourlyController, cursorColor: Colors.black,
        
        style: TextStyle(fontFamily: '', letterSpacing: -.8, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.height * .025), decoration: InputDecoration(isDense: true, errorMaxLines: 2, fillColor: Colors.white, filled: true, 
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .3)),
      contentPadding: EdgeInsets.only(left: 1, right: MediaQuery.of(context).size.width * .01, top: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),     
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff979797), width: .3))))));
  }


  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(backgroundColor: Colors.transparent, elevation: 0,
        content: Container(color: Colors.transparent,
          height: MediaQuery.of(context).size.height * .57, width: MediaQuery.of(context).size.width * .7,
          child: Container(child: Column(children: [
            
         
          Container(height: MediaQuery.of(context).size.height * .009),
          Container(height: MediaQuery.of(context).size.height * .5, width: MediaQuery.of(context).size.width * .7, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
           child: Column(children: <Widget>[
            Column(children: [
                    Column(children:[
                      Text('Name', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .02,
                        fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
                      _usernameInput(),  
                        ]),
                    Column(children:[
                      Text('Hourly Rate', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .02,
                        fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),
                      _hourlyInput(),  
                        ]),    
                    GestureDetector(onTap: () async {
                      await DatabaseManagementTool.instance.updateData(UserData(name: usernameController.text, hourly_rate: hourlyController.text, unique_id: widget.id), widget.id);
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
                      },
                        child: Container(child: Text('Input data', style: TextStyle(decoration: TextDecoration.none, fontFamily: '', color: Color(0xffb97633), fontSize: MediaQuery.of(context).size.height * .032,
                          fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: -1.3,),),))    
                  ],)

        


        ]))

        
        
    ]))));}
  
  }




class UserData {
  final name;
  final hourly_rate;
  final unique_id;
  UserData({this.name, this.hourly_rate, this.unique_id
  });

  Map<String, dynamic> toMap() {
  //  return {'contacts': contacts, 'blockStatus': blockStatus};
    return {'name': name, 'hourly_rate': hourly_rate, 'unique_id': unique_id};
  
  }

  @override
  String toString() {
    //return 'Users{$contacts, $blockStatus}';}
    return 'Users{$name, $hourly_rate, $unique_id}';}
  }



class DatabaseManagementTool{
  
  DatabaseManagementTool._privateConstructor();
  static final DatabaseManagementTool instance = DatabaseManagementTool._privateConstructor();
  static late Database _database;
  //Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> get database async => _database = await _initDatabase();
  


  Future<Database> _initDatabase() async {return openDatabase(
    path.join(await getDatabasesPath(), '000x00_database.db'), 
    onCreate: (db, version) {
      return db.execute('create table if not exists Users (id integer primary key, name text, hourly_rate text, unique_id text)');
      
      },
    version: 1    
    );}
  
  Future<void> insertData(UserData userdata) async {
    Database db = await instance.database;
    await db.insert('Users', 
                    userdata.toMap(),
                    conflictAlgorithm: ConflictAlgorithm.replace
                    );
    }

  
  // use this for updating the mode of blocking
  Future<void> updateData(UserData userdata, id) async {
    Database db = await instance.database;
    await db.update('Users', 
                    userdata.toMap(),
                    where: 'unique_id = ?',
                    whereArgs: [id],
                    conflictAlgorithm: ConflictAlgorithm.replace
                    );
    }
  

  Future<void> deleteRecord(unique_id) async {
    Database db = await instance.database;
    db.delete('Users', where: 'unique_id = ?', whereArgs: [unique_id]);
  }

  Future<List> checkList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> users = await db.query('Users');
    return List.generate(users.length, (index) {
      return  UserData(name: users[index], hourly_rate: users[index], unique_id: users[index]);
    });
  }  
}

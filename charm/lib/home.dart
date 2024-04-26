import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'feed_posts.dart';
import 'login_page.dart';
import 'my_post_widget.dart';
import 'user_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  String loggedInUserId = '';
  // final token;
  Map<String,dynamic> user = {};
  HomePage({required this.user,super.key,required this.loggedInUserId});


  @override
  State<HomePage> createState() => _HomePageState();

  // Static method to access setPage from outside
  static void setPage(BuildContext context) {
    final _HomePageState state = context.findAncestorStateOfType<_HomePageState>()!;
    state.setPage();
  }
}

class _HomePageState extends State<HomePage> {

  // late SharedPreferences prefs;
  // late String? jsonString;
  Map<String, dynamic> jsonObject = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initSharedPref();
  }

  // void initSharedPref() async{
  //   prefs = await SharedPreferences.getInstance();
  //   jsonString = prefs.getString('myJson');
  //   if (jsonString != null) {
  //     // Convert JSON string to JSON object
  //     Map<String, dynamic> jsonObject = jsonDecode(jsonString!);
  //
  //     // Print retrieved JSON object
  //     print('Retrieved JSON object:');
  //     print(':::: ${jsonObject} ::::');
  //     print(':::: ${jsonObject.runtimeType} ::::');
  //     // print('Role: ${jsonObject['role']}');
  //   } else {
  //     print('No JSON object found in SharedPreferences.');
  //   }
  // }
  bool isGetData = true;

  // late String? email;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchPosts();
  // }
  // void iniEmail() async {
  //   email = widget.user['email'];
  //   // Map<String,dynamic> jwtDecodedToken =  JwtDecoder.decode(widget.token);
  //   //   print(widget.user);
  //   // email = jwtDecodedToken['email'];
  // }

  List<dynamic> data = [];

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(feedPosts));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      data = json.decode(response.body).reversed.toList();
      // print("::: $data ::::");
      return data;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load posts');
    }

  }

  void setPage(){
    setState(() {
      isGetData = true;
      print(':::::::::::::SET:::::::::::::');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      endDrawer: Drawer(

        child: ListView(
          children: [
            ListTile(
              title: Center(child: Text('${widget.user["firstName"]} ${widget.user["lastName"]}',style: TextStyle(color: Colors.lightBlueAccent,fontWeight: FontWeight.w800),)),
            ),
            Center(
              child: Column(
                children: [
                  Icon(Icons.dark_mode),
                  Padding(
                    padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: Icon(Icons.message),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: Icon(Icons.notifications),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: Icon(CupertinoIcons.question_circle_fill),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: ElevatedButton(onPressed: () async {
                      SharedPreferences  prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedin');
                      await prefs.remove('myJson');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));

                    }, child: Text('Log out')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Charm',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.height * 0.04,fontWeight: FontWeight.w800),),
      ),

      // body: Center(child: Text(widget.user['email'])),
      body: Stack(children:[
        Container(
          // color: Colors.black87,
          color: Colors.grey.shade200,
        ),
        SingleChildScrollView(
          child: Column(
            children: [

              UserWidget(loggedInUserId: widget.loggedInUserId,user: widget.user),
              MyPostWidget(user: widget.user),
              // ElevatedButton(onPressed: (){
              //   setState(() {
              //
              //   });
              // }, child: Text('Refrease')),
              FutureBuilder(
              future: isGetData ? fetchPosts() : null,
              builder: (context, snapshot) {

              if(snapshot.hasData && snapshot.data!=null) {
                isGetData = false;
                return FeedPosts(loggedInUserId: widget.loggedInUserId,user: jsonObject,data: data);
              }else{
                return const Center(child: CircularProgressIndicator());
              } })
            ],
          ),


        ),


      ] ),

      // body: ,
    );
  }
}


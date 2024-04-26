import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'config.dart';
import 'feed_posts.dart';
import 'home.dart';
import 'login_page.dart';
import 'user_widget.dart';

class ProfilePage extends StatefulWidget {
  List<dynamic> data = [];
  Map<String,dynamic> user = {};
  String userId = '';
  String loggedInUserId = '';
  // Map<String,dynamic> user = {};
  ProfilePage({super.key,required this.userId,required this.loggedInUserId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static void setPage(BuildContext context) {
    final _ProfilePageState state = context.findAncestorStateOfType<_ProfilePageState>()!;
    state.setPage();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  bool isGetData = true;
  bool isGetData2 = true;

  void setPage(){
    setState(() {
      isGetData = true;
      isGetData2 = true;
      print(':::::::::::::SET Profile:::::::::::::');
    });
  }
  // Future<Map<String,dynamic>> fetchData() async {
  //   try {
  //     final response = await http.get(Uri.parse(getUser + '65c0e3a9de8240c5679e1809'));
  //
  //     if (response.statusCode == 200) {
  //       // If the server returns a 200 OK response, parse the JSON
  //       // final jsonData = json.decode(response.body);
  //       widget.user = json.decode(response.body);
  //       // Now you can use jsonData in your Flutter application
  //       // print(jsonData);
  //       return widget.user;
  //     } else {
  //       // If the server returns an error response, throw an exception
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     // Handle any errors that occur during the request
  //     print('Error: $error');
  //   }
  // }

  Future<Map<String, dynamic>> fetchData(String userid) async {
    try {
      final response = await http.get(Uri.parse(getUser + userid));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        // final jsonData = json.decode(response.body);
        widget.user = json.decode(response.body);
        return widget.user;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle any errors that occur during the request
      print('Error: $error');
      // Re-throw the error
      throw error;
    }
  }

  List<dynamic> data = [];

  Future<List<dynamic>> fetchPosts() async {
    // final response = await http.get(Uri.parse(feedPosts));
    final response = await http.get(Uri.parse(feedPosts +'/' +widget.userId + '/posts'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(

        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: Icon(Icons.dark_mode),
                  ),
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
        title: InkWell(
            onTap: () async {
              await fetchData(widget.loggedInUserId);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage(loggedInUserId: widget.loggedInUserId,user: widget.user,)));
              // ProfilePage();
            },
            child: Text('Charm',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.height * 0.04,fontWeight: FontWeight.w800),)),
      ),

      body: Stack(

        children: [
          Container(
            // color: Colors.black87,
            color: Colors.grey.shade200,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: isGetData ? fetchData(widget.userId) : null,
                    builder: (context, snapshot) {

                      if(snapshot.hasData && snapshot.data!=null) {
                        isGetData = false;
                        return UserWidget(loggedInUserId: widget.loggedInUserId,user: widget.user);
                        // return FeedPosts(user: widget.user,data: data);
                      }else{
                        return const Center(child: CircularProgressIndicator());
                      } }),
                FutureBuilder(
                    future: isGetData2 ? fetchPosts() : null,
                    builder: (context, snapshot) {

                      if(snapshot.hasData && snapshot.data!=null) {
                        isGetData2 = false;
                        return FeedPosts(loggedInUserId: widget.loggedInUserId,user: widget.user,data: data);
                      }else{
                        return const Center(child: CircularProgressIndicator());
                      } })

              ],
            )
          )
        ],
      ),
    );
  }
}

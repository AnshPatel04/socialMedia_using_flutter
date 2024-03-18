import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  // late SharedPreferences prefs;
  // late String? jsonString;
  // Map<String, dynamic> jsonObject = {};
  // @override
  // void initState(){
  //   super.initState();
  //
  // }
  // void initSharedPref() async{
  //   prefs = await SharedPreferences.getInstance();
  //   jsonString = prefs.getString('myJson');
  //   if (jsonString != null) {
  //     // Convert JSON string to JSON object
  //     Map<String, dynamic> jsonObject = jsonDecode(jsonString!);
  //
  //     // Print retrieved JSON object
  //     print('Retrieved JSON object:');
  //     // Future.delayed(const Duration(seconds: 3),(){
  //       // if(jsonString != null) {
  //         Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(builder: (context) => HomePage(user: jsonObject,loggedInUserId: jsonObject['_id'],)));
  //       // }else{
  //       //   Navigator.of(context).pushReplacement(
  //       //       MaterialPageRoute(builder: (context) => LoginPage()));
  //       // }
  //     // }
  //     // );
  //     print(':::: ${jsonObject} ::::');
  //     print(':::: ${jsonObject.runtimeType} ::::');
  //     // print('Role: ${jsonObject['role']}');
  //   } else {
  //     // Future.delayed(const Duration(seconds: 3),(){
  //       // if(jsonString != null) {
  //       Navigator.of(context).pushReplacement(
  //           // MaterialPageRoute(builder: (context) => HomePage(user: jsonObject,loggedInUserId: jsonObject['_id'],)));
  //       // }else{
  //       //   Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(builder: (context) => LoginPage()));
  //       // }
  //     // }
  //     // );
  //     print('No JSON object found in SharedPreferences.');
  //   }
  //
  //
  // }

  void whereToGo() async {
    var sp = await SharedPreferences.getInstance();

    var isLogin = sp.getBool('isLoggedin');

    Timer(Duration(seconds: 2),(){
      if(isLogin != null){
        var jsonString = sp.getString('myJson');
        // Map<String, dynamic> jsonObject = jsonDecode(jsonString!);
        if (jsonString != null) {
          // Convert JSON string to JSON object
          Map<String, dynamic> jsonObject = jsonDecode(jsonString!);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>
                  HomePage(
                    user: jsonObject, loggedInUserId: jsonObject['_id'],)));
        }
      }else{
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  void initState()  {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      // SystemUiMode.manual,overlays: SystemUiOverlay.values
        SystemUiMode.immersive
    );
    // initSharedPref;
    whereToGo();


    // Timer(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const HomeScreen()));
    // });
  }


  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,overlays: SystemUiOverlay.values
      //   SystemUiMode.immersive
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(

          children: [
            Center(
              child: ShaderMask(
                  shaderCallback: (bounds)=>
                      const LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.purpleAccent,
                            Colors.pinkAccent,
                            Colors.red,
                            Colors.amber,
                            Colors.deepOrange
                          ],
                          stops: [0.2,0.3,0.4,0.5,0.9,0.2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          transform: GradientRotation(6/4)
                      ).createShader(bounds),
                  child: const FaIcon(FontAwesomeIcons.instagram, size: 135,color: Colors.white,)),
            ),
            Positioned(
                bottom: 60,
                left: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("from",style: TextStyle(color: Colors.grey,fontSize: 20),),
                    Row(
                      children: [
                        ShaderMask(
                            shaderCallback: (bounds)=>
                                const LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.purpleAccent,
                                      Colors.pinkAccent,
                                      Colors.red,
                                      Colors.amber,
                                      Colors.deepOrange
                                    ],
                                    stops: [0.2,0.3,0.4,0.5,0.9,0.2],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    transform: GradientRotation(6/4)
                                ).createShader(bounds),
                            child: const FaIcon(FontAwesomeIcons.affiliatetheme,size: 30,color: Colors.white,)),
                        ShaderMask(
                            shaderCallback: (bounds)=>
                                const LinearGradient(
                                  colors: [
                                    Colors.deepOrange,
                                    Colors.amber,
                                    Colors.pinkAccent,
                                  ],
                                  stops: [0.4,0.5,0.1],
                                  // stops: [0.2,0.3,0.4,0.5,0.9,0.2],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  // transform: GradientRotation(6/4)
                                ).createShader(bounds),
                            child: const Text(' CASTERs',style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.w700),))
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      ),
      // child: Text(
      //   'Classico',
      //   style: TextStyle(
      //       fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white),
      // ),
    );
  }
}

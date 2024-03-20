import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  void whereToGo() async {
    var sp = await SharedPreferences.getInstance();

    var isLogin = sp.getBool('isLoggedin');

    Timer(const Duration(seconds: 2),(){
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
        SystemUiMode.immersive
    );
    
    whereToGo();


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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Charm',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.height * 0.06,fontWeight: FontWeight.w800),),
            Text('from CASTERs',style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03,fontWeight: FontWeight.w500),),
          ],
        ),
      ),
    );
  }
}

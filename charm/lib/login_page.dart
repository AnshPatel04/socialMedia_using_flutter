// import 'package:charm/register_page.dart';
import 'package:charm/register_page2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'home.dart';
// import 'newlogin_page.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
   const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var screenWidth = MediaQuery.of(context as BuildContext).size;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isNotValidate = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }
  void loginUser() async {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      var reqBody = {
        "email":emailController.text,
        'password':passwordController.text
      };

      var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(reqBody)
      );

      var jsonResponse = jsonDecode(response.body);

      if(jsonResponse['status']){
        // var myToken = jsonResponse['token'];
        // prefs.setString('token', myToken);

        print(jsonResponse['user']);
        String jsonString = jsonEncode(jsonResponse['user']);
        prefs.setString('myJson', jsonString);
        prefs.setBool('isLoggedin', true);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(user: jsonResponse['user'],loggedInUserId: jsonResponse['user']['_id'],)));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(token: myToken,)));
      }else{
        print("Something Went Wrong");
      }
    }else{
      setState(() {
        _isNotValidate = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Charm',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.height * 0.05,fontWeight: FontWeight.w800),)),
        // backgroundColor: Colors.lightBlueAccent,
        // backgroundColor: Colors.black,
        // backgroundColor: Colors.white,
      ),

      body: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            // color: Colors.black87,
            color: Colors.grey.shade200,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04,left: MediaQuery.of(context).size.width * 0.03,right: MediaQuery.of(context).size.width * 0.03,bottom: MediaQuery.of(context).size.height * 0.3),
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04,left: MediaQuery.of(context).size.width * 0.03,right: MediaQuery.of(context).size.width * 0.03,),
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
                  // height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    // color: Colors.black87,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: Text('Welcome to Casters!',style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,fontWeight: FontWeight.w600
                            // fontWeight: FontWeight.w600, color: Colors.white
                        ),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Email',
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Password',
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        width: double.infinity,
                        child: OutlinedButton(onPressed: () {
                          loginUser();
                        },
                          child: Text('Login',style: TextStyle(color: Colors.white),),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: (){ //RegisterPage()
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>RegisterPage2()));
                          },
                          child: Text('Don\'t have an account? Sing Up here.',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.width * 0.04,fontWeight: FontWeight.w600),))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}

import 'dart:io';

// import 'package:charm/upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'login_page.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage2> {

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _register() async {
    final String firstName = firstController.text.trim();
    final String lastName = lastController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String location = locationController.text.trim();
    final String occupation = occupationController.text.trim();
    final String picturePath = _image!.path.split('/').last;

    final Uri uri = Uri.parse(registration);

    try {
      var request = http.MultipartRequest('POST', uri)
        ..fields['firstName'] = firstName
        ..fields['lastName'] = lastName
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['occupation'] = occupation
        ..fields['picturePath'] = picturePath
        ..fields['location'] = location;

      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('picture', _image!.path),
        );
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        // Registration successful
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
        print('User registered successfully!');
      } else {
        // Registration failed
        print('Failed to register user.');
      }
    } catch (error) {
      print('Error registering user: $error');
    }
  }

  // ImageUploadService uploadService = ImageUploadService();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Charm',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.height * 0.05,fontWeight: FontWeight.w800),)),
        // backgroundColor: Colors.lightBlueAccent,
        // backgroundColor: Colors.black,
        // backgroundColor: Colors.white,
      ),
      body:Stack(
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
                        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: firstController,
                          decoration: InputDecoration(
                            // errorText: _isNotValidate? 'Require' : null,
                            labelText: 'First Name',
                            hintText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: lastController,
                          decoration: InputDecoration(
                            // suffixIcon: Icon(CupertinoIcons.eye_fill),
                            // errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Last Name',
                            hintText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            // errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Location',
                            hintText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: occupationController,
                          decoration: InputDecoration(
                            // suffixIcon: Icon(CupertinoIcons.eye_fill),
                            // errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Occupation',
                            hintText: 'Occupation',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                      //   height: 20,
                      //   width: double.infinity,
                      //   color: Colors.red,
                      // ),


                      _image != null
                          ? Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                            child: Center(
                              child: Image.file(
                                _image!,
                                height: MediaQuery.of(context).size.height * 0.16, width: MediaQuery.of(context).size.height * 0.16,
                              ),
                            ),
                          )
                          : Container(),
                      ////////////////////////////////////////////
                      // Visibility(
                      //     visible: pickedFile != null,
                      //
                      //     child: pickedFile != null
                      //         ? Padding(
                      //       padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                      //       child: Center(child: Image.file(File(pickedFile!.path), height: MediaQuery.of(context).size.height * 0.16, width: MediaQuery.of(context).size.height * 0.16,)),
                      //       //file.path.split('/').last;
                      //     )
                      //         :Container()
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: ElevatedButton(
                          onPressed: getImage,
                          child: Center(child: Text('Select Picture')),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                      //   child: TextField(
                      //     // controller: passwordController,
                      //     decoration: InputDecoration(
                      //       // suffixIcon: Icon(CupertinoIcons.eye_fill),
                      //       // errorText: _isNotValidate? 'Require' : null,
                      //       labelText: 'Pending Work',
                      //       hintText: 'Pending Work',
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(5),
                      //       ),
                      //     ),
                      //
                      //   ),
                      // ),

                      Padding(
                        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            // errorText: _isNotValidate? 'Require' : null,
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
                            // suffixIcon: Icon(CupertinoIcons.eye_fill),
                            // errorText: _isNotValidate? 'Require' : null,
                            labelText: 'Password',
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                        child: OutlinedButton(onPressed: () async {
                          _register();
                        },
                          child: Text('Register',style: TextStyle(color: Colors.white),),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                          },
                          child: Text('Already have an account? Login here.',style: TextStyle(color: Colors.lightBlueAccent,fontSize: MediaQuery.of(context).size.width * 0.04,fontWeight: FontWeight.w600),))
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

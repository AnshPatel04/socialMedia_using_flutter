import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'config.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'profile_page.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class MyPostWidget extends StatefulWidget {

  Map<String,dynamic> user = {};
  MyPostWidget({required this.user,super.key});

  @override
  State<MyPostWidget> createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {


  TextEditingController description_controller = TextEditingController();
  bool _isNotValidate = false;
  File? _image;
  //////////////////////

  final picker = ImagePicker();

  Future getImage({bool isCam = false}) async {

    if(isCam) {
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        // Permission not granted, handle accordingly
        return;
      }
    }else{
      // var status = await Permission.storage.request();
      // if (!status.isGranted) {
      //   // Permission not granted, handle accordingly
      //   return;
      // }
    }
    final pickedFile = await picker.pickImage(source: isCam ? ImageSource.camera : ImageSource.gallery );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  void postData(BuildContext context) async {


    if(description_controller.text.trim() != ''){
      _isNotValidate = false;


        // Make the POST request
        try {

          var request = http.MultipartRequest('POST', Uri.parse(createPost))
            ..fields['userId'] = widget.user['_id']
            ..fields['description'] = description_controller.text;

          if (_image != null) {
            request.files.add(
              await http.MultipartFile.fromPath('picture', _image!.path),
            );
            request.fields['picturePath'] = _image!.path.split('/').last;
          }

          final response = await http.Response.fromStream(await request.send());



          // Check if the request was successful (status code 2xx)
          if (response.statusCode >= 200 && response.statusCode < 300) {
            description_controller.text = '';
            _image = null;
            HomePage.setPage(context);
            ProfilePage.setPage(context);
            print('Post request successful');
            print('Response body: ${response.body}');
          } else {
            print('Failed to send POST request');
            print('Status Code: ${response.statusCode}');
            print('Response body: ${response.body}');
          }

        } catch (error) {
          print('Error sending POST request: $error');
        }
    }else{
      _isNotValidate = true;
      setState(() {

      });
    }
  }
  ////////////////////
  Future<bool> uploadPost() async {
    try{

      Dio dio = Dio();
      if (description_controller.text.trim() != ''){
        _isNotValidate = false;
        FormData formData = FormData.fromMap({
          'userId': widget.user['_id'],
          'description': description_controller.text,
        });

        Response response = await dio.post(
          createPost,
          data: formData,
        );

        if (response.statusCode == 201) {
          print('::Uploaded::');
          print(response.data);
          HomePage.setPage(context);
          return true;
        }else{
          print('::upload failed. Error: ${response.statusCode}::');
        }
      }else{
        _isNotValidate = true;
        setState(() {

        });
        //user canceled image selection/capture
      }
    }catch(err){
      print('::Error  uploading: $err::');
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04,left: MediaQuery.of(context).size.width * 0.05,right: MediaQuery.of(context).size.width * 0.05,),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
      // height: MediaQuery.of(context).size.height * 0.68,
      decoration: BoxDecoration(
        // color: Colors.black87,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),

      child: Column(

        children: [
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(profilePic + widget.user["picturePath"]),
                  // AssetImage('${forStory[index]['userPic']}'),
                  // backgroundColor: Colors.yellow,
                  radius: MediaQuery.of(context).size.width * 0.09,//MediaQuery.of(context).size.height * 0.05,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                    child: TextField(
                      controller: description_controller,
                      decoration: InputDecoration(
                        errorText: _isNotValidate? 'Require' : null,
                        // labelText: 'What\'s on your mind',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'What\'s on your mind',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
          _image != null
              ? Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01,top: MediaQuery.of(context).size.height * 0.01),
            child: Center(
              child: Image.file(
                _image!,
                height: MediaQuery.of(context).size.height * 0.16, width: MediaQuery.of(context).size.height * 0.16,
              ),
            ),
          )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(

                  border: Border(
                      top: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2
                      )
                  )
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: getImage,
                      child: Icon(FontAwesomeIcons.image,color: Colors.grey.shade600)
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: (){
                      getImage(isCam: true);
                    },
                      child: Icon(FontAwesomeIcons.camera,color: Colors.grey.shade600)
                  ),
                  // Icon(Icons.more_horiz,color: Colors.grey.shade600),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _image = null;
                      });
                    },
                      child: Icon(FontAwesomeIcons.xmark,color: _image == null ? Colors.grey.shade600 : Colors.black),

                  ),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: (){
                      postData(context);
                      setState(() {

                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent, // Sets the background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Adjusts the border radius
                      ),
                    ),

                    child: Center(child: Text('Post',style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

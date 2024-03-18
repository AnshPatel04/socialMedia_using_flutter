import 'package:flutter/material.dart';

import 'config.dart';
import 'home.dart';
import 'profile_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedPosts extends StatefulWidget {
  List<dynamic> data = [];
  Map<String,dynamic> user = {};
  String loggedInUserId = '';
  FeedPosts({required this.loggedInUserId,required this.user,required this.data,super.key});

  @override
  State<FeedPosts> createState() => _FeedPostsState();
}

class _FeedPostsState extends State<FeedPosts> {

  void deletePosts(String postId) async{
    try{
      // deletePost
      http.Response response = await http.delete(
        Uri.parse(deletePost + postId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {

        HomePage.setPage(context);
        print('DELETE request successful');

      }

    }catch (error){
      print('Error sending DELETE request: $error');
    }
  }

  void banTheUser(String userID) async{

    if (userID != '65c51503fea23732eee92632') {
      try {
        // deletePost
        http.Response response = await http.delete(
          Uri.parse(getUser + userID),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          HomePage.setPage(context);
          print('BAN request successful');
        }
      } catch (error) {
        print('Error sending BAN request: $error');
      }
    }
  }

  void patchLike (String postId) async{
    try {
      http.Response response = await http.patch(
        Uri.parse(likePost +'/' + postId +'/like'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': widget.loggedInUserId,
        }),
      );


      if (response.statusCode == 200) {
        HomePage.setPage(context);
        print('PATCH request successful');
        print('Response body: ${response.body}');
      }
    }catch (error) {
      print('Error sending PATCH request: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        Map<String,dynamic> user = widget.data[index];
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.loggedInUserId == '65c51503fea23732eee92632')

                widget.data[index]['userId'] != widget.loggedInUserId ?
                Row(
                children: [
                  InkWell(
                    onTap: (){
                      banTheUser(widget.data[index]["userId"]);
                    },
                      child: Padding(
                        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01,),
                        child: Icon(Icons.block,color: Colors.red,size: MediaQuery.of(context).size.height * 0.07,),
                      )
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                  ),
                  Text("Ban The Id",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,fontWeight: FontWeight.w500,color: Colors.red.shade300),)
                ],
              )
                :
                    Container(),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(profilePic + widget.data[index]["userPicturePath"]),
                      radius: MediaQuery.of(context).size.width * 0.09,//MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: ()=><Future>{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(loggedInUserId: widget.loggedInUserId,userId: widget.data[index]['userId'])))
                          // ProfilePage();
                        },
                          child: Text(widget.data[index]["firstName"] + ' '+widget.data[index]["lastName"],style: TextStyle(fontWeight: FontWeight.w700,fontSize: MediaQuery.of(context).size.width * 0.044),
                          )
                      ),
                      Text(widget.data[index]["location"],style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.019,color: Colors.grey)),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon(Icons.person_add_outlined),
                  // Icon(Icons.person_remove_outlined)
                ],
              ),
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
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.02),
                child: Text(widget.data[index]["description"]),
              ),
              //picturePath
              if (widget.data[index]['picturePath'] != null) Center(child: Image.network(profilePic + widget.data[index]["picturePath"])),

              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  children: [
                    // likes[loggedInUserId]
                    InkWell(
                      onTap: (){
                        patchLike(widget.data[index]['_id']);
                      },
                      child: widget.data[index]['likes'][widget.loggedInUserId] != true ?
                      // child: widget.data[index]['likes'][widget.user['_id']] != true ?
                      Icon(Icons.favorite_border,color: Colors.grey.shade600)
                          :
                      Icon(Icons.favorite,color: Colors.lightBlueAccent,),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text('${widget.data[index]['likes'].length}'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Icon(Icons.chat_bubble_outline,color: Colors.grey.shade600),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text('${widget.data[index]['comments'].length}'),
                    Expanded(child: Container()),
                    // userId
                    if (widget.loggedInUserId == '65c51503fea23732eee92632') Padding(
                      padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                      child: InkWell(
                          onTap: (){
                            deletePosts(widget.data[index]['_id']);
                          },
                          child: Icon(Icons.delete_outline_rounded,color: Colors.grey.shade600)
                      ),
                    ),
                    Icon(Icons.share_outlined,color: Colors.grey.shade600)
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.data.length,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'config.dart';
import 'profile_page.dart';

class UserWidget extends StatefulWidget {

  Map<String,dynamic> user = {};
  String loggedInUserId = '';
  UserWidget({required this.loggedInUserId,required this.user,super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04,left: MediaQuery.of(context).size.width * 0.03,right: MediaQuery.of(context).size.width * 0.03,bottom: MediaQuery.of(context).size.height * 0.3),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04,left: MediaQuery.of(context).size.width * 0.05,right: MediaQuery.of(context).size.width * 0.05,),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      // height: MediaQuery.of(context).size.height * 0.68,
      decoration: BoxDecoration(
        // color: Colors.black87,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),

      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ListTile(
          //   leading: CircleAvatar(
          //     // backgroundImage:
          //     //   AssetImage('${forStory[index]['userPic']}'),
          //     backgroundColor: Colors.yellow,
          //     radius: 40,//MediaQuery.of(context).size.height * 0.05,
          //     child: Image.network(profilePic + widget.user["picturePath"],fit: BoxFit.cover,),
          //   ),
          //
          //   title: Text(widget.user["firstName"] + ' '+widget.user["lastName"],style: TextStyle(fontWeight: FontWeight.w700,fontSize: MediaQuery.of(context).size.height * 0.03),),
          //   subtitle: Text("${widget.user["friends"].length} friends",style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.019,color: Colors.grey)),
          //
          //   trailing: Icon(Icons.manage_accounts_outlined),
          // ),
          Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04,right: MediaQuery.of(context).size.width * 0.04),
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
              decoration: BoxDecoration(

                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2
                      )
                  )
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(profilePic + widget.user["picturePath"]),
                      // AssetImage('${forStory[index]['userPic']}'),
                      // backgroundColor: Colors.yellow,
                      radius: MediaQuery.of(context).size.width * 0.09,//MediaQuery.of(context).size.height * 0.05,
                      // child: Container(
                      //     width: MediaQuery.of(context).size.width * 0.16,
                      //     height: MediaQuery.of(context).size.width * 0.16,
                      //     // clipBehavior:Cl ,
                      //
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(50)),
                      //       color: Colors.redAccent,
                      //        image: DecorationImage(
                      //          image: NetworkImage(profilePic + widget.user["picturePath"]),
                      //          fit: BoxFit.cover,
                      //        )
                      //     ),
                      //     // child: Image.network(profilePic + widget.user["picturePath"],fit: BoxFit.cover,)
                      //   ),
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(loggedInUserId: widget.loggedInUserId,userId: widget.user['_id'])))
                            // ProfilePage();
                          },
                          child: Text(widget.user["firstName"] + ' '+widget.user["lastName"],style: TextStyle(fontWeight: FontWeight.w700,fontSize: MediaQuery.of(context).size.width * 0.044),)),
                      Text("${widget.user["friends"].length} friends",style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.019,color: Colors.grey)),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon(Icons.manage_accounts_outlined)
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined,color: Colors.black54,size: MediaQuery.of(context).size.height * 0.04,),
            title: Text(widget.user["location"],style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.height * 0.023),),
          ),
          ListTile(
            leading: Icon(Icons.work_outline,color: Colors.black54,size: MediaQuery.of(context).size.height * 0.04,),
            title: Text(widget.user["occupation"],style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.height * 0.023),),
          ),
          ListTile(
            leading: Text("Who's viewed your profile",style: TextStyle(color: Colors.grey.shade400,fontSize: MediaQuery.of(context).size.width * 0.04)),
            trailing: Text('${widget.user["viewedProfile"]}',style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.04)),
          ),
          ListTile(
            leading: Text("Impressions of your post",style: TextStyle(color: Colors.grey.shade400,fontSize: MediaQuery.of(context).size.width * 0.04)),
            trailing: Text('${widget.user["impressions"]}',style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.width * 0.04)),
          ),
          ListTile(
            leading: Text('Social Profiles',style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.height * 0.023)),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.twitter,color: Colors.grey),
            title: Text("Twitter",style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600)),
            subtitle: Text("Social Network",style: TextStyle(color: Colors.grey.shade400)),
            trailing: Icon(Icons.edit_outlined,color: Colors.grey.shade700),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.linkedin,color: Colors.grey),
            title: Text("Linkedin",style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600)),
            subtitle: Text("Network Platform",style: TextStyle(color: Colors.grey.shade400)),
            trailing: Icon(Icons.edit_outlined,color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

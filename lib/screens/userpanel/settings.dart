import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/database.dart';
import 'package:sona_magazine/services/preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
   final FirebaseAuth auth = FirebaseAuth.instance;
   AuthMethods authMethods = AuthMethods();
   Database database = Database();
  SharedPreferenceFunctions sharedPreferenceFunctions = SharedPreferenceFunctions();
  var imageUrl,username,useremail,userPhoneno;
  TextEditingController _feedbackcontroller = TextEditingController();
  TextEditingController _contactuscontroller = TextEditingController();
  bool isSwitchednoti = false;
  bool isswitcheddata =false;

  toogleSwitchfornoti(bool value){
    if(isSwitchednoti == false){
      setState(() {
        isSwitchednoti=true;
         Flushbar(
          message:
              "Notification feature is under Development",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      });
    }else{
      setState(() {
        isSwitchednoti=false;
      });
    }
  }
   toogleSwitchfordata(bool value){
    if(isswitcheddata == false){
      setState(() {
        isswitcheddata=true;
        // ignore: avoid_single_cascade_in_expression_statements
        Flushbar(
          message:
              "Data Saver is Turned on",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Data Saver is Turned On")
        //     )
        // );
      });
    }else{
      setState(() {
        isswitcheddata=false;
         // ignore: avoid_single_cascade_in_expression_statements
         Flushbar(
          message:
              "Data Saver is Turned off",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: const Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      });
    }
  }
   signOut()async{
    await authMethods.signOut();
    await sharedPreferenceFunctions.SignOutSharedPreference();
    setState(() {
      sharedPreferenceFunctions.isUserLoggedIn(false);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
  }

  currentUser()async{
    final User? user = auth.currentUser;
    final userimage = user!.photoURL;
    var name =user.displayName;
    var email = user.email;
    var phone = user.phoneNumber;
    setState(() {
      imageUrl = userimage.toString();
      username = name.toString();
      useremail = email.toString();
      userPhoneno = phone.toString();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xff0c0f14),
     appBar: AppBar(
        backgroundColor:  Color(0xff007bff),
        centerTitle: true,
       title: Text(
          "INFOZYN",
          style: GoogleFonts.graduate(
              textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 1
                  )
              ),
        ),
      ),
      body:SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
              alignment: Alignment.center,
              width: double.infinity,
              color: Colors.white54.withOpacity(0.05),
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize:20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              ),
                 Align(
                   alignment: Alignment.center,
                   child: Container(
                     width: size.width*0.34,
                     height: size.height*0.17,
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: NetworkImage(imageUrl,),fit: BoxFit.cover,
                       ),
                       borderRadius: BorderRadius.circular(10.0)
                     ),
                    ),
                 ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:18.0,
                      fontWeight:FontWeight.w500
                    )
              ),
                  ),
                ),
              Center(
                child: Text(
                  useremail,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize:16.0,
                    fontWeight:FontWeight.w300
                  )
                ),
              ),
              SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: Column(
              children:[
                 Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite,color: Colors.blueAccent),
                    title: Text(
                      "Favourites",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.language_outlined,color: Colors.blueAccent),
                    title: Text(
                      "Language",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text("English",style: TextStyle(color: Colors.black54),),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications,color: Colors.blueAccent),
                    title: Text(
                      "Notification",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Switch(  
                onChanged: toogleSwitchfornoti,  
                value: isSwitchednoti,  
                activeColor: Colors.blue,  
                activeTrackColor: Colors.blue.withOpacity(0.5),  
              )  
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.data_saver_off_rounded,color: Colors.blueAccent),
                    title: Text(
                      "Data Saver",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Switch(  
                onChanged: toogleSwitchfordata,  
                value: isswitcheddata,  
                activeColor: Colors.blue,  
                activeTrackColor: Colors.blue.withOpacity(0.5),  
              )  
                  ),
                ),
              ]
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                 builder: (BuildContext context){
                   return AlertDialog(
                     backgroundColor: Color(0xff141921),
                     title: Text("Logout",style: TextStyle(color: Colors.white),),
                      content: Text("Do you really want to Logout ?",style: TextStyle(color: Colors.white54)),
                      actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              )),
                          TextButton(
                              onPressed: () {
                                signOut();
                              },
                              child: Text("Confrim",
                                  style: TextStyle(color: Colors.white))),
                        ],
                   );
                 });
              
            },
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color:Colors.blueAccent,
                    size:30
                  ),
                  Text(
                    " Log Out",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight:FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return  AlertDialog(
                            backgroundColor: Color(0xff141921),
                            title: const Text("Feedback",style: TextStyle(color: Colors.white),),
                            content: TextField(
                                controller: _feedbackcontroller,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            actions: [
                              TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                              TextButton(
                                    onPressed: () {
                                      database.uploadFeedback(_feedbackcontroller.text,useremail.toString());

                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Thank you for the response") 
                                          ),
                                      );
                                    }, child: Text("Submit",style: TextStyle(color: Colors.white))),
                            ],
                          );
                        });
                    },
                    child: const ListTile(
                  
                      leading: Icon(
                        Icons.feedback_rounded,
                        color: Colors.white,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Feedback",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.white54.withOpacity(0.2),),
                  GestureDetector(
                    onTap:(){
                      showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return  AlertDialog(
                            backgroundColor: Color(0xff141921),

                            title:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Contact us",style: TextStyle(color: Colors.white),),
                                Text("you can also reach us via\nSonatech@outlook.in",style: TextStyle(color: Colors.white54,fontSize: 13),),
                              ],
                            ),
                            content: TextField(
                                controller: _contactuscontroller,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Colors.white),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  // fillColor: Colors.white,
                                  // filled: true,
                                  hintText: "Write your Query here",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            actions: [
                              TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                              TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Thank you for the response") 
                                          ),
                                      );
                                    }, child: Text("Submit",style: TextStyle(color: Colors.white))),
                            ],
                          );
                        });
                      
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.contact_support_rounded,
                        color: Colors.white,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Contact Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.white54.withOpacity(0.2),),
                  ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(color: Colors.white54.withOpacity(0.2),),
                  ListTile(
                    leading: Icon(
                      Icons.article_rounded,
                      color: Colors.white,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
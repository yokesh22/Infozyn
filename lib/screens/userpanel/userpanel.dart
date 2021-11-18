import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sona_magazine/screens/userpanel/detailspage.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/preferences.dart';
import 'package:sona_magazine/services/database.dart';
import 'package:like_button/like_button.dart';
class UserPanel extends StatefulWidget {
  bool route;
  UserPanel(this.route);
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {


  AuthMethods authMethods = AuthMethods();

  SharedPreferenceFunctions sharedPreferenceFunctions = SharedPreferenceFunctions();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Database uploadData = Database();
  String? currentUserid;
  int no_of_likes = 10;
  List content = [];
   int likeCount = 100;
   bool isLiked = false;
   var count = 0;
   late String categoryname;
   final Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection("wrapper").orderBy('realdate',descending: true).snapshots();

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
    currentUserid = user!.uid;
    print(currentUserid.toString());
    
  }

  uploadLikeCount(int likes)async{
    String doc = categoryname;
    final result = await uploadData.uploadLikes(likes,doc);
    if(result == null){
      print("Error fetching likes");
    }
    else{
      no_of_likes = result;
    }
  }

  Widget buildPage({title,description,date,imageurl,categoryname1}){
    String str = description as String;
    String res = str.substring(0,str.indexOf('.'));
    categoryname = categoryname1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageurl),
              fit: BoxFit.cover
            ),
          ),
        ),
        GestureDetector(
          onTap:(){
            setState((){
              if(isLiked==false){
                isLiked = true;
                likeCount = likeCount+1;
              }
              else{
                isLiked = false;
                likeCount = likeCount-1;
              }
            });
            uploadLikeCount(likeCount);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            width: MediaQuery.of(context).size.width*0.3,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                isLiked? Icon(Icons.favorite,color: Colors.red,size: 25,):
                Icon(
                  Icons.favorite_border,color: Colors.white,size: 21,
                ),
                SizedBox(width: 5.0,),
                Text(
                  likeCount.toString(),
                  style: TextStyle(
                    color: Colors.white,fontSize: 18
                  ),
                ),
              ],
            )
          ),
        ),
        SizedBox(height: 5.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Color(0xffd17842),
            //    foreground:Paint()
            // ..style = PaintingStyle.stroke
            // ..strokeWidth = 0.9
            // ..color = Colors.white
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 25.0),
          child: Divider(color: Colors.deepPurple),
        ),
        SizedBox(height: 10.0,),
        GestureDetector(
          onTap: () {   
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            date: date,
                            desc: description,
                            title: title,
                            image: imageurl,
                          )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RichText(
              text: TextSpan(
                text: res,
                style: TextStyle(color: Colors.white54,fontSize: 16.0),
                children: <TextSpan>[
                  TextSpan(
                    text: " Read More...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:FontWeight.w700
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0,),
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Event on :",
                  style: TextStyle(
                    color: Colors.blue[300],
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
              ),
              SizedBox(width: 5.0,),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white54
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }

  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
    // getImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(padding: EdgeInsets.only(bottom: 50.0)),
      //drawer: SideDrawer(),
      backgroundColor: Color(0xff0c0f14),
      appBar: AppBar(
        backgroundColor:  Color(0xffd17842),
        centerTitle: true,
        leading:widget.route? GestureDetector(
          onTap: (){
            Navigator.popUntil(context, (route) {
              return count++ == 2;
          });
          },
          child: Icon(Icons.arrow_back_ios_rounded,color: Colors.black54,)):null,
        title: Text(
          "INFOZYN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
                foreground:Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.black
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if(snapshot.hasError){
              return Container();
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.size,
              itemBuilder: (context,index){
                return buildPage(
                  imageurl: snapshot.data!.docs[index]['imageurl'],
                  date: snapshot.data!.docs[index]['date'],
                  description: snapshot.data!.docs[index]['description'],
                  title: snapshot.data!.docs[index]['title'],
                  categoryname1: snapshot.data!.docs[index]['eventname']
                );
              }
              );

          }
    ));
  }
}


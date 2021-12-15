import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sona_magazine/screens/userpanel/detailspage.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/auth.dart';
import 'package:sona_magazine/services/preferences.dart';
import 'package:sona_magazine/services/database.dart';
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
  Database database = Database();
  String? currentUserid;
   int likeCount = 100;
   bool postLiked = false;
   var count = 0;
   late String categoryname;
   Map<String,dynamic> data = {};
   int likes = 0;
   List like = [];
   int pageindex = 0;
   PageController controller = PageController();
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

getlikes(){
  database.getlikevalue(currentUserid).then((val){
    setState(() {
      like = val;
    });
    print(like);
  });
}
  // getdata()async{
  //   Database().getlastestfeed().then(
  //     (value){
  //       setState(() {
  //         data = value;
  //         print(data);
  //       });

  //     }
  //     );
  // }


  uploadLikeCount(int likes)async{
    String doc = categoryname;
    final result = await database.uploadLikes(likes,doc);
    if(result == null){
      print("Error fetching likes");
    }
    // else{
    //   no_of_likes = result;
    // }
  }
  

  // Widget buildPage({title,description,date,imageurl,categoryname1,likeCount}){
    // String str = description as String;
    // String res = str.substring(0,str.indexOf('.'));
  //   categoryname = categoryname1;
  //   likes = likeCount;
  //   return 
  // }

  
  
  @override
  void initState() {
    currentUser();
   super.initState();
   getlikes();
    // getdata();
    // getImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(padding: EdgeInsets.only(bottom: 50.0)),
      //drawer: SideDrawer(),
      // backgroundColor: Color(0xff0c0f14),
      appBar: AppBar(
        backgroundColor:  Color(0xff007bff),
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
              controller: controller,
              onPageChanged: (s){
                pageindex = s;
              },
              itemCount: snapshot.data!.size,
              itemBuilder: (context,index){
                 String str = snapshot.data!.docs[index]['description']as String;
                String res = str.substring(0,str.indexOf('.'));
                Timestamp x = snapshot.data!.docs[index]['date'];
                DateTime dateTime = DateTime.parse(x.toDate().toString());
                String date = DateFormat().add_yMd().format(dateTime);
                return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 5.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(snapshot.data!.docs[index]['imageurl'],),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              GestureDetector(
          onTap: (){
            if(postLiked){
              setState(() {
                postLiked = false;
                likes--;
                // uploadLikeCount(likeCount);
                // database.updatelike(currentUserid.toString(),postLiked);
                
              });
            }else{
              setState(() {
                postLiked = true;
                likes++;
                // uploadLikeCount(likeCount);
              });
            }
           
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt,
                  color:postLiked?Colors.blue:Colors.grey,
                  size: 30,
                ),
                SizedBox(width: 5.0,),
                Text(
                  // likes.toString(),
                  '${postLiked? snapshot.data!.docs[index]['likes']+1:
                  snapshot.data!.docs[index]['likes']}',
                  style: TextStyle(
                    fontSize: 17,
                    color:postLiked?Colors.black:Colors.grey
                  ),
                ),
                
              ],
            ),
          ),
        ),

  SizedBox(height: 5.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            snapshot.data!.docs[index]['title'],
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            //    foreground:Paint()
            // ..style = PaintingStyle.stroke
            // ..strokeWidth = 0.9
            // ..color = Colors.white
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 10.0,right: 25.0),
          child: Divider(color: Color(0xffffc107)),
        ),
        SizedBox(height: 10.0,),
        GestureDetector(
          onTap: () {   
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            date: date,
                            desc: snapshot.data!.docs[index]['description'],
                            title: snapshot.data!.docs[index]['title'],
                            image: snapshot.data!.docs[index]['imageurl'],
                          )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RichText(
              text: TextSpan(
                text: res,
                style: TextStyle(color: Colors.black54,fontSize: 16.0),
                children: <TextSpan>[
                  TextSpan(
                    text: " Read More...",
                    style: TextStyle(
                      color: Colors.black,
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
                    color: Color(0xffffc107),
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                
              ),
              SizedBox(width: 5.0,),
              Text(
                date,
                style: TextStyle(
                  color: Colors.black54
                ),
              ),
            ],
          ),
        ),
            ],
          ) 
        )
        // Like...
        
        
      ],
    );
                // return buildPage(
                //   imageurl: snapshot.data!.docs[index]['imageurl'],
                //   date: snapshot.data!.docs[index]['date'],
                //   description: snapshot.data!.docs[index]['description'],
                //   title: snapshot.data!.docs[index]['title'],
                //   categoryname1: snapshot.data!.docs[index]['eventname'],
                //   likeCount:snapshot.data!.docs[index]['likes'],
                // );
              }
              );

          }
    ));
  }
}


// Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           // margin: EdgeInsets.symmetric(vertical: 5.0),
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height*0.4,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: NetworkImage(imageurl),
//               fit: BoxFit.cover
//             ),
//           ),
//         ),
//         SizedBox(height: 5.0,),
//         // Like...
//         GestureDetector(
//           onTap: (){
//             if(postLiked){
//               setState(() {
//                 postLiked = false;
//                 likes--;
//                 // uploadLikeCount(likeCount);
//               });
//             }else{
//               setState(() {
//                 postLiked = true;
//                 likes++;
//                 // uploadLikeCount(likeCount);
//               });
//             }
           
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.thumb_up_alt,
//                   color:postLiked?Colors.blue:Colors.grey,
//                   size: 30,
//                 ),
//                 SizedBox(width: 5.0,),
//                 Text(
//                   likes.toString(),
//                   style: TextStyle(
//                     fontSize: 17,
//                     color:postLiked?Colors.black:Colors.grey
//                   ),
//                 ),
                
//               ],
//             ),
//           ),
//         ),

//   SizedBox(height: 5.0,),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             //    foreground:Paint()
//             // ..style = PaintingStyle.stroke
//             // ..strokeWidth = 0.9
//             // ..color = Colors.white
//             ),
//           ),
//         ),
//         Padding(
//           padding:  EdgeInsets.only(left: 10.0,right: 25.0),
//           child: Divider(color: Color(0xffffc107)),
//         ),
//         SizedBox(height: 10.0,),
//         GestureDetector(
//           onTap: () {   
//             Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => DetailPage(
//                             date: date,
//                             desc: description,
//                             title: title,
//                             image: imageurl,
//                           )));
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: RichText(
//               text: TextSpan(
//                 text: res,
//                 style: TextStyle(color: Colors.black54,fontSize: 16.0),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: " Read More...",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight:FontWeight.w700
//                     ),
//                   ),
//                 ]
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 10.0,),
//         Container(
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Text(
//                   "Event on :",
//                   style: TextStyle(
//                     color: Color(0xffffc107),
//                     fontSize: 17.0,
//                     fontWeight: FontWeight.w500
//                   ),
//                 ),
                
//               ),
//               SizedBox(width: 5.0,),
//               Text(
//                 date,
//                 style: TextStyle(
//                   color: Colors.black54
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//       ],
//     );
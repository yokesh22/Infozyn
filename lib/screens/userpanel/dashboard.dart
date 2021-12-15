import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/userpanel/categoriespage.dart';
import 'package:sona_magazine/screens/userpanel/searchresult.dart';
import 'package:sona_magazine/screens/userpanel/settings.dart';
import 'package:sona_magazine/screens/userpanel/archives.dart';
import 'package:sona_magazine/screens/userpanel/feeds.dart';
import 'package:sona_magazine/services/database.dart';
class DashBoard extends StatefulWidget {
  const DashBoard({ Key? key }) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController searchController = TextEditingController();
  Database uploadData = Database();
  List searchresultlist = [];
  List latestNews = [];
  bool isSearched = false;

  fetchData()async{
    dynamic result = await uploadData.searchEvent(searchController.text.toLowerCase()).then(
      (value){
          setState(() {
            searchresultlist = value;
            print(searchresultlist);
          });
      }
      );
    
  }

  getnews()async{
    dynamic res = await uploadData.getlastestfeed();
    if(res == null){
      print("Error fetching");
    }
    else{
      setState(() {
        latestNews = res;
      });
    }
  }
  
  


  Widget descriptionwidget(context,{images,title,subtitle}){
  return Container(
    width: MediaQuery.of(context).size.width*0.4+10,
    height: MediaQuery.of(context).size.height*0.25,
    padding: EdgeInsets.all(10.0),
    margin: EdgeInsets.all(10.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(3, 3),
          ),
        ],
       
      ),

    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      blurRadius: 2.0,
                      spreadRadius:1.0,
                      color: Colors.blueAccent.withOpacity(0.1)
                    )
                  ],
                 
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Image.asset(images,color: Color(0xffffc107)),
              ),
            ),
            SizedBox(height: 10.0,),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(height: 5,),
                    Text(
                      subtitle,
                      style:TextStyle(
                      color: Colors.white54,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
  
              )
              )
          ],
        )
      ],
    ),
  );
}

  Widget userTile({eventname}){
    return ListTile(
      
      title: GestureDetector(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchResultScreen(eventname)));
        },
        child: Text(
          eventname,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnews();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white30,
      appBar: AppBar(
        backgroundColor:  Colors.yellow[700],
        centerTitle: true,
       title: Text(
          "INFOZYN",
          style: GoogleFonts.graduate(
              textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  letterSpacing: 1
                  )
              ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
        FocusScope.of(context).unfocus();
      },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics:BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20.0,top: 20.0),
                child: Text(
                  "SONA",
                  style: GoogleFonts.wallpoet(
               textStyle: TextStyle(
                 color:Colors.blue,
                 fontSize: 40.0,
                 fontWeight: FontWeight.bold
               ),
                  ),
                ),
              ),
               Container(
                padding: EdgeInsets.only(left: 20.0,top: 0.0),
                child: Text(
                  "The  Online  Magazines...",
                  style: GoogleFonts.wallpoet(
                    color: Color(0xffffc107),
                    fontSize: 18.0,
                    
                  )
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0,top: 20.0,right: 10),
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Color(0xffffc107)),
                              hintText: "search events...",
                              hintStyle: TextStyle(color: Color(0xff52555a)),
                              
                              // fillColor: Color(0xff141921),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                focusColor: Colors.black
                              ),
                        ),
                      ),
                    ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 15.0,top: 20.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child:  GestureDetector(
                            onTap: (){
                              fetchData();
                              setState(() {
                                isSearched = true;
                              });
                            },
                            child: Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              isSearched?Container(
                height: MediaQuery.of(context).size.height*0.08,
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchresultlist.length,
                  itemBuilder: (context,index){
                    return userTile(
                      eventname: searchresultlist[index]['eventname']
                    );
                  }
                  ),
              ):
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10.0),
                child: Text(
                  "Discovery",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height*0.3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>UpcomingEvents()));
                              },
                              child: descriptionwidget(
                                context,
                                images: "assets/images/upcoming.png",
                                title: "Archives",
                                subtitle: "make note for upcoming event"
                                ),
                            ),
                              GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Categories()));
                                },
                                child: descriptionwidget(
                                context,
                                images: "assets/images/category.png",
                                title: "Category",
                                subtitle: "view categorized feeds"
                                ),
                              ),
                              GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPanel(false)));
                                },
                                child: descriptionwidget(
                                context,
                                images: "assets/images/feed.png",
                                title: "SONA Feed",
                                subtitle: "Hot new feeds"
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingPage()));
                                },
                                child: descriptionwidget(
                                context,
                                images: "assets/images/profile.png",
                                title: "Profile",
                                subtitle: "Edit your account details"
                                ),
                              ),
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Hot Feeds",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2
                        ),
                        ),
                    ),
                    SizedBox(height: 10.0,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffffc107),
                        boxShadow: [
                                BoxShadow(
                                  color: Colors.black54.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child:latestNews!=null&&latestNews.isNotEmpty? Image.network(latestNews[0]['imageurl']):null
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white54.withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10)
                                )
                              ),
                              child:latestNews!=null&&latestNews.isNotEmpty? Text(
                                      latestNews[0]['title'],
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                              ):null,
                            )
                            ),
                        ],
                      ),
                      ),
                
              
                  ],
                ),
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}

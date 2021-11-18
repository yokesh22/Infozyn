import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/services/database.dart';
class SearchResultScreen extends StatefulWidget {
  String eventname;
  SearchResultScreen(this.eventname);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List searchdatalist = [];
  Database uploadData = Database();
  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection("wrapper").snapshots();

  getdata()async{
    dynamic result = await uploadData.searchEvent(widget.eventname);
    if(result == null){
      print("error fetching ...");

    }
    else{
      setState(() {
        searchdatalist = result;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }


Widget buildPage({imageurl,date,description,title}){
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height,
    padding: EdgeInsets.only(bottom: 20.0),
    child: Stack(
      children: [
        Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.5,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imageurl),fit: BoxFit.cover),
        border: Border.all(color: Colors.white54),
      ),
    ),
    SafeArea(
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Container(
          
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 20.0,top: 10.0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0)  
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black
          ),
        ),
      ),
    ),
    Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: 8.0,),
        width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height*0.55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
    
      ),
    ),
     Align(
       alignment: Alignment.bottomRight,
       child: Container(
          width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height*0.56,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white54),
          boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(1, 5)
          ),
        ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 25.0,top: 10.0),
                    width: 2.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ephesis',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Text(
                  title,
                  style: GoogleFonts.cinzelDecorative(
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
              ),
              SizedBox(height: 30.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 45.0,vertical: 20.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Abel'
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
        
     ),
        
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0f14),
      body: ListView.builder(
        itemCount: searchdatalist.length,
        itemBuilder: (context,index){
          return buildPage(
                  imageurl: searchdatalist[index]['imageurl'],
                  date: searchdatalist[index]['date'],
                  description: searchdatalist[index]['description'],
                  title: searchdatalist[index]['title']
                );
        }
        )
    );
  }
}

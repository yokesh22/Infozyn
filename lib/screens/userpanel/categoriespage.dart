import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/userpanel/detailspage.dart';
import 'package:sona_magazine/screens/userpanel/feeds.dart';
import 'package:sona_magazine/services/database.dart';
class Categories extends StatefulWidget {
  const Categories({ Key? key }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Database uploadData = Database();
  String isSelected = "";
  int likeCount = 100;
   bool isLiked = false;
   int no_of_likes = 10;
   List categorylist = [];
   List archives = ['year','fine arts','awards','funded projects'];

   getcategorylist()async{
     final result = await uploadData.searchCategory(isSelected.toLowerCase());

     if(result == null){
       print("Error fetching..");
     }
     else{
       setState(() {
         categorylist = result;
         print(categorylist);
       });
     }
   }


Widget categoryoptions({size}){
  return Container(
              width: double.infinity,
              height: size.height*0.1,
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected = "All";
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPanel(true)));
                        });
                      },
                     
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected=="All"?Colors.blueAccent:Colors.grey,
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("Archives",style: TextStyle(color:isSelected=="All" ?Colors.black:Colors.white),)
                        ),
                    ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected = "Institution";
                          getcategorylist();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected=="Institution" ?Colors.blueAccent:Colors.grey,
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("Institution",style: TextStyle(color:isSelected=="Institution" ?Colors.white:Colors.white),)
                        ),
                    ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected = "Sports";
                          getcategorylist();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected=="Sports" ?Colors.blueAccent:Colors.grey,
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("Sports",style: TextStyle(color:isSelected=="Sports" ?Colors.white:Colors.white),)
                        ),
                    ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected = "Technology";
                          getcategorylist();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected=="Technology"?Colors.blueAccent:Colors.grey,
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("Technology",style: TextStyle(color:isSelected=="Technology"?Colors.white:Colors.white),)
                        ),
                    ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSelected = "Placement";
                          getcategorylist();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected=="Placement"?Colors.blueAccent:Colors.grey,
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("Placement",style: TextStyle(color:isSelected=="Placement"?Colors.white:Colors.white),)
                        ),
                    ),
                  ],
                ),
              ),
            );

}

 Widget buildPage({title,description,date,imageurl}){
    String str = description as String;
    String res = str.substring(0,str.indexOf('.'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.34,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageurl),
              fit: BoxFit.cover
            ),
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
              color: Colors.black,
            //    foreground:Paint()
            // ..style = PaintingStyle.stroke
            // ..strokeWidth = 0.9
            // ..color = Colors.white
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 25.0),
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
    );
  }  
  

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

    return Scaffold(
      //  backgroundColor: Color(0xff0c0f14),
      appBar: AppBar(
        backgroundColor:  Color(0xff007bff),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
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
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Column(
          children: [
            categoryoptions(size: size),
            isSelected ==""?Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  child: Text("Select a Category",style: TextStyle(color: Colors.black),)),
                  Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: Container(
                  width: size.width*0.75,
                  height: size.height*0.4,
                  child: Image.network("https://c.tenor.com/GdDXAn_CjW0AAAAC/i-phone-cat-playing-with-iphone.gif",fit: BoxFit.cover,),
                ),
              ),
              ],
            ):
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: PageView.builder(
                  
                  scrollDirection: Axis.vertical,
                  itemCount: categorylist.length,
                  itemBuilder: (context, index) {
                    return buildPage(
                      imageurl: categorylist[index]['imageurl'],
                      date: categorylist[index]['date'],
                      description: categorylist[index]['description'],
                      title: categorylist[index]['title']
                      );
                    }
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

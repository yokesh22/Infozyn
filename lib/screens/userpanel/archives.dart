import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/userpanel/detailspage.dart';
import 'package:sona_magazine/services/database.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({Key? key}) : super(key: key);

  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  Database database = Database();
  var year_dropdownValue;
  var cat_dropdownValue;
  List items = [];

  search() async {
    database
        .searchArchives(year_dropdownValue.toString(),
            cat_dropdownValue.toString().toLowerCase())
        .then((value) {
      setState(() {
        items = value;
      });
      print(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xff0c0f14),
      appBar: AppBar(
        backgroundColor: Color(0xff007bff),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
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
                  letterSpacing: 1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: size.height * 0.07,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: year_dropdownValue,
                            hint: Text(
                              "Select year",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                year_dropdownValue = newValue!;
                              });
                            },
                            items: <String>[
                              '2018 - 2019',
                              '2019 - 2020',
                              '2020 - 2021',
                              '2021 - 2022',
                              '2022 - 2023',
                              '2023 - 2024',
                              '2024 - 2025',
                              '2025 - 2026',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: size.height * 0.07,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: cat_dropdownValue,
                            hint: Text(
                              "Select Category",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                cat_dropdownValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Fine Arts',
                              'Awards',
                              'Funded Projects',
                              'Upcoming Events'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if(cat_dropdownValue != "" && year_dropdownValue != ""){
                          search();
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Select year and Category") 
                            )
                          );
                        }
                      },
                      child: Text("Search")),
                )
              ],
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                             DetailPage(
                              title: items[index]['title'],
                              desc: items[index]['description'],
                              date: items[index]['date'],
                              image: items[index]['imageurl'])
                            ));
                          },
                          child: Card(
                            elevation: 20,
                            child: Row(
                              children: [
                                Container(
                                  height:size.height*0.2,
                                  width: size.width*0.45,
                                  padding: EdgeInsets.symmetric(horizontal: 5.0,vertical:5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical:10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                        image: NetworkImage(items[index]['imageurl']),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                    )
                                  ),
                                 Expanded(
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Container(
                                         child: Text(items[index]['title'])
                                      ),
                                       Align(
                                           alignment:Alignment.bottomRight,
                                           child: Container(
                                             alignment: Alignment.center,
                                             width: 50.0,
                                             height: 20.0,
                                             decoration:BoxDecoration(
                                               color: Colors.yellow[700]
                                             ),
                                             child: Text(
                                               ">>",
                                               style:TextStyle(
                                                 fontWeight: FontWeight.w500
                                               )
                                             ),
                                           ),
                                         ),
                                     ],
                                   )
                                 ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}

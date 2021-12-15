import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
class DetailPage extends StatefulWidget {
  
  String title,desc,date,image;
  DetailPage({required this.title,required this.desc,required this.date,required this.image});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0f14),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.5,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(widget.image),fit: BoxFit.cover),
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
                  borderRadius: BorderRadius.circular(10.0)    // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.8),
              //     spreadRadius: 13,
              //     blurRadius: 10,
              //     offset: Offset(0, 5)
              //   ),
                
              // ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
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
                            widget.date,
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
                        widget.title,
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
                      padding: EdgeInsets.symmetric(horizontal: 45.0,vertical: 10.0),
                      child: Text(
                        widget.desc,
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
        ),
      ),
    );
  }
}

// Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height*0.47,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 16.0),
//                     child: Text(widget.title,
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
//                     padding: EdgeInsets.symmetric(horizontal: 5.0),
//                     width: 160,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.deepOrange),
//                       borderRadius: BorderRadius.circular(20.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: Offset(5, 6)
//                         ),
//                       ],
//                     ),
//                     child: Text("Event on : ${widget.date}",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500
//                       ),
//                     ),
//                   ),
//                   Divider(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
//                     child: Text(
//                       widget.desc,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontFamily: 'Ephesis',
//                         fontSize: 16.0
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
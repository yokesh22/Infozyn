import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Widget appbar(){
  return AppBar(
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
      );
}


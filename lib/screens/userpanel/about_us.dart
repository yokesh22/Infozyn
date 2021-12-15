import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sona_magazine/screens/userpanel/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({ Key? key }) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

   final Completer<WebViewController> _controller = Completer<WebViewController>();
   final String url = 'https://www.sonatech.ac.in/it/it-department-faculty-profile.php';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: Text(
                "SONA COLLEGE OF\nTECHNOLOGY,SALEM",
                textAlign: TextAlign.center,
                style:GoogleFonts.acme(
                  letterSpacing: 1.0,
                  color: Colors.red,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                
                ) 
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
              child: Text(
                "Sona College of Technology (Autonomous) is a private college in India located in Salem, Tamilnadu, India. It was established in 1997 by Thiru. M.S. Chockalingam (Founder Chairman) and gained autonomous status in 2012.",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Divider(),
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
              child: Text(
                "DEPARTMENT OF INFORMATION TECHNOLOGY",
                textAlign: TextAlign.center,
                style:GoogleFonts.acme(
                  letterSpacing: 1.0,
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500
                ) 
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
              child: Text(
                "Since its inception in the year 1998, the Department of Information Technology with the well-knit faculty members demonstrating high professionalism puts the graduating engineers on excellence steroids in preparation for the performance needed to navigate among the opportunities abounding in today's world of internet and e-revolution.The Department has faculty members specialized in Data mining, Computer Networks, Soft Computing, Evolutionary Computing, Network Security, Cyber Security, Digital Signal Processing, Big Data Analytics, Image Processing, Cloud Computing and Mobile Computing.",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebViewClass(url: url,)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  leading: Image.asset('assets/images/university.png',fit: BoxFit.cover,),
                  title: Text(
                    "Faculty Information",
                    style: TextStyle(),
                  ),
                  tileColor: Colors.grey[400],
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Development Team",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:FontWeight.w500,
                  fontSize:16.0
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Yokeshwaran S"),
                  Text("Huzair Ahamed"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sona_magazine/screens/userpanel/homepage.dart';
import 'package:sona_magazine/screens/userpanel/feeds.dart';
import 'package:sona_magazine/screens/sigup.dart';
import 'package:sona_magazine/services/preferences.dart';

void main() async {
   SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  getLoggedInState()async{
    await SharedPreferenceFunctions().getUserLoggedIn().then(
      (val){
        setState(() {
          isLoggedIn = val;
        });
      }
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedInState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
    brightness: Brightness.light,)
      ),
      home: isLoggedIn? HomePage() : SignUp()
    );
  }
}

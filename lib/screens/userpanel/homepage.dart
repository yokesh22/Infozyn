import 'package:flutter/material.dart';
import 'package:sona_magazine/screens/userpanel/about_us.dart';
import 'package:sona_magazine/screens/userpanel/dashboard.dart';
import 'package:sona_magazine/screens/userpanel/settings.dart';
import 'package:sona_magazine/screens/userpanel/feeds.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class HomePage extends StatefulWidget {
 
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late int _selectedIndex = 0;
   static List _pages = [
     DashBoard(),
     UserPanel(false),
     SettingPage(),
     AboutUs()
   ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 650),
        // buttonBackgroundColor: Colors.yellow[700]
        items: [
          Icon(Icons.home),
          Icon(Icons.article_outlined),
          Icon(Icons.account_circle),
          Icon(Icons.info_outlined),
        ],
        onTap: (val){
          _onItemTapped(val);
        },
        ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items:const <BottomNavigationBarItem>[
      //      BottomNavigationBarItem(
      //   icon: Icon(Icons.home),
      //   label: 'Home',
      // ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.article_outlined),
      //   label: 'Feeds',
      // ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.account_circle),
      //   label: 'Account',
      // ),
      //  BottomNavigationBarItem(
      //   icon: Icon(Icons.info_outlined),
      //   label: 'About',
      // ),
      
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   // backgroundColor: Color(0xff0c0f14),
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
        
      //   selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      //   selectedIconTheme: IconThemeData( size: 30),
      // ),
      
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}

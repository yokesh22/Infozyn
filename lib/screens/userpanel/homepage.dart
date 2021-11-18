import 'package:flutter/material.dart';
import 'package:sona_magazine/screens/userpanel/dashboard.dart';
import 'package:sona_magazine/screens/userpanel/settings.dart';
import 'package:sona_magazine/screens/userpanel/userpanel.dart';
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
   ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items:const <BottomNavigationBarItem>[
           BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.article_outlined),
        label: 'Feeds',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
      
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xff0c0f14),
        selectedItemColor: Color(0xffd17842),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedIconTheme: IconThemeData(color: Color(0xffd17842), size: 30),
      ),
      
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}

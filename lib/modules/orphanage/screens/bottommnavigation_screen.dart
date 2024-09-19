import 'package:flutter/material.dart';
import 'package:hungry/modules/orphanage/screens/home_screen.dart';
import 'package:hungry/modules/orphanage/screens/noti_screen.dart';
import 'package:hungry/modules/orphanage/screens/orderorph_screen.dart';
import 'package:hungry/modules/orphanage/screens/proffileorph_screen.dart';
import 'package:hungry/modules/restuarant/screens/home_screen.dart';


class OrphnageRootScreen extends StatefulWidget {
  @override
  _OrphnageRootScreenState createState() => _OrphnageRootScreenState();
}

class _OrphnageRootScreenState extends State<OrphnageRootScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pageList = [
    Orphanagehomescreen(),
    NotificationsPage(),
    RecentOrdersScreen(),
    Proffileorph()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: pageList[_selectedIndex],

      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

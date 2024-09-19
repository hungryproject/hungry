import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/screens/home_screen.dart';
import 'package:hungry/modules/restuarant/screens/food_add_screen.dart';
import 'package:hungry/modules/restuarant/screens/order_screen.dart';
import 'package:hungry/modules/restuarant/screens/profile_screen.dart';

class RestaurantRootScreen extends StatefulWidget {
  @override
  _RestaurantRootScreenState createState() => _RestaurantRootScreenState();
}

class _RestaurantRootScreenState extends State<RestaurantRootScreen> {
  int _selectedIndex = 0;

  final  List<Widget> _widgetOptions = <Widget>[
   RestaurantHomeScreen(),
   const OrdersScreen(),
  FoodFormPage(),

  const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
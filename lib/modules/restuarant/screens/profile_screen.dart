import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Profile'),
      ),
      body: ListView(
        children: [
          // Restaurant Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restaurant Name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Phone Number: (123) 456-7890',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Place: 123 Elm Street, City, Country',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Email ID: restaurant@example.com',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 32),
                // Photos Section
                Text(
                  'Restaurant Photos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset('assets/restaurant1.jpg', width: 200, fit: BoxFit.cover),
                      SizedBox(width: 16),
                      Image.asset('assets/restaurant2.jpg', width: 200, fit: BoxFit.cover),
                      SizedBox(width: 16),
                      Image.asset('assets/restaurant3.jpg', width: 200, fit: BoxFit.cover),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                // Google Maps Section
                Text(
                  'Restaurant Location',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

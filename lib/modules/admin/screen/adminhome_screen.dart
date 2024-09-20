import 'package:flutter/material.dart';
import 'package:hungry/modules/admin/screen/banner_screen.dart';
import 'package:hungry/modules/admin/screen/vieworph_screen.dart';
import 'package:hungry/modules/admin/screen/viewrest_screen.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Handle profile button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Admin',
              style: TextStyle(
                fontSize: 58,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 42),
            Row(
              children: [
                Expanded(
                  child: AdminCard(
                    title: 'Restaurant',
                    backgroundColor: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewRestaurantPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AdminCard(
                    title: 'Orphanage',
                    backgroundColor: Colors.greenAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Vieworphpage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            AdminCard(
              title: 'Add Banner',
              backgroundColor: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BannerAdPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Add your logout logic here
              print('User logged out'); // Placeholder for logout action
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const AdminCard({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: backgroundColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

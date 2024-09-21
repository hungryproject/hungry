import 'package:flutter/material.dart';
import 'package:hungry/modules/admin/screen/admprof_screen.dart';
import 'package:hungry/modules/admin/screen/banner_screen.dart';
import 'package:hungry/modules/admin/screen/vieworph_screen.dart';
import 'package:hungry/modules/admin/screen/viewrest_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/2L0vC.png'),
            fit: BoxFit.cover, // Adjusts how the image fits the container
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello, Admin',
                style: TextStyle(
                  fontSize: 58,
                  color: Color.fromARGB(255, 251, 251, 250),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 42),
              Row(
                children: [
                  Expanded(
                    child: AdminCard(
                      title: 'Restaurant',
                      backgroundColor: const Color.fromARGB(255, 249, 248, 247).withOpacity(0.7), // Add opacity to the color
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
                      backgroundColor: const Color.fromARGB(255, 247, 249, 248).withOpacity(0.7), // Add opacity to the color
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
                backgroundColor: const Color.fromARGB(255, 244, 244, 244).withOpacity(0.7), // Add opacity to the color
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
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
                color: Color.fromARGB(255, 237, 103, 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

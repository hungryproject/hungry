import 'package:flutter/material.dart';
import 'package:hungry/modules/admin/screen/admin_order_list_screen.dart';
import 'package:hungry/modules/admin/screen/admin_review_screen.dart';
import 'package:hungry/modules/admin/screen/banner_screen.dart';
import 'package:hungry/modules/admin/screen/view_added_banners_screen.dart';
import 'package:hungry/modules/admin/screen/vieworph_screen.dart';
import 'package:hungry/modules/admin/screen/viewrest_screen.dart';
import 'package:hungry/modules/choose_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';


class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Admin Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 150),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/bg-ch.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Wrap(
          children: [
            AdminCard(
              icon: Icons.restaurant,
              title: 'Restaurant',
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewRestaurantPage()),
                );
              },
            ),
            const SizedBox(width: 20),
            AdminCard(
              title: 'Orphanage',
              icon: Icons.accessibility,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Vieworphpage()),
                );
              },
            ),
            AdminCard(
              title: 'Add Banner',
              icon: Icons.ad_units,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BannerAdPage()),
                );
              },
            ),
            AdminCard(
              icon: Icons.view_carousel_outlined,
              title: 'View Banners',
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BannerListScreen()),
                );
              },
            ),
            AdminCard(
              title: 'View Orders',
              icon: Icons.document_scanner,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminOrderListScreen()),
                );
              },
            ),

            AdminCard(
              title: 'Review',
              icon: Icons.star,
              backgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantReviewScreen()),
                );
              },
            ),
            AdminCard(
              title: 'Logout',
              icon: Icons.logout,
              backgroundColor: Colors.white,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Function to show logout confirmation dialog
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChooseScreen()),
                (route) => false, // Remove all previous routes
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
  final IconData icon;
  

  const AdminCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onTap, required this.icon,
  });

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

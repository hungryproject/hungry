import 'package:flutter/material.dart';
import 'package:hungry/modules/admin/screen/admin_login_screen.dart';
import 'package:hungry/modules/orphanage/screens/orphange_login_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';
import 'package:lottie/lottie.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Hungry',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildOptionCard(
                context,
                'Admin',
                'asset/Animation - 1728209600110.json',
                Colors.blue,
                Icons.admin_panel_settings,
                const AdminLoginScreen(),
              ),
              const SizedBox(height: 30),
              buildOptionCard(
                context,
                'Restaurant',
                'asset/Animation - 1728209691216.json',
                Colors.orange,
                Icons.restaurant_menu,
                const LoginScreen(),
              ),
              const SizedBox(height: 30),
              buildOptionCard(
                context,
                'Orphanage',
                'asset/Animation - 1728213854723.json',
                Colors.green,
                Icons.home,
                const OrphanageLoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionCard(
    BuildContext context,
    String title,
    String imageUrl,
    Color color,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Lottie.asset(imageUrl),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

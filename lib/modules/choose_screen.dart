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
      body: Column(
        children: [
          const Expanded(child: SizedBox.shrink()),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  // Admin Card
                  buildOptionCard(
                    context,
                    'Admin',
                    'asset/Animation - 1728209600110.json', // Replace with actual image URL
                    Colors.blue,
                    Icons.admin_panel_settings,
                    const AdminLoginScreen()
                  ),
                  // Restaurant Card
                  buildOptionCard(
                    context,
                    'Restaurant',
                    'asset/Animation - 1728209691216.json', // Replace with actual image URL
                    Colors.orange,
                    Icons.restaurant_menu,
                    const LoginScreen()
                  ),
                  // Orphanage Card
                  buildOptionCard(
                    context,
                    'Orphanage',
                    'asset/Animation - 1728213854723.json', // Replace with actual image URL
                    Colors.green,
                    Icons.home,
                    const OrphanageLoginScreen()
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget buildOptionCard(
    BuildContext context,
    String title,
    String imageUrl,
    Color color,
    IconData icon,
    Widget page
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page, ));
        
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Light color background
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4)

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Section
            Expanded(
              child: Lottie.asset(imageUrl),
            ),
            // Text and Icon Section
            
           
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/banner_services.dart';

class BannerListScreen extends StatefulWidget {
  const BannerListScreen({super.key});

  @override
  _BannerListScreenState createState() => _BannerListScreenState();
}

class _BannerListScreenState extends State<BannerListScreen> {
  final BannerServices _bannerServices = BannerServices();
  int _selectedIndex = 0; // 0 for Restaurant, 1 for Orphanage

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<QuerySnapshot> _getBanners() {
    // Filter banners based on selected category
    if (_selectedIndex == 0) {
      return _bannerServices.fetchBanners(field: 'isforrestaurant', value: true);
    } else {
      return _bannerServices.fetchBanners(field: 'isfororphanage', value: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banners')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getBanners(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading banners.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No banners available.'));
          }

          final banners = snapshot.data!.docs;

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final title = banner['title'] ?? 'No title';
              final description = banner['description'] ?? 'No description';
              final imageUrl = banner['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10, // Adds shadow to the card
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade200, Colors.green.shade500], // Matching bottom nav color
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: GestureDetector(
                      onTap: () => _showImageDialog(context, imageUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // Update functionality can be added here
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            _bannerServices.deleteBanner(
                              context: context,
                              bannerId: banner.id,
                              imageUrl: imageUrl,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Orphanage',
          ),
        ],
        backgroundColor: Colors.green.shade500, // Matching card color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

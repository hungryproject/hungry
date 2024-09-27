import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/banner_services.dart';

class BannerListScreen extends StatelessWidget {
  final BannerServices _bannerServices = BannerServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banners')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bannerServices.fetchBanners(),
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
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => _showImageDialog(context, imageUrl),
                    child: Image.network(imageUrl, width: 50, height: 50),
                  ),
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Update functionality can be added here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
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
              );
            },
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRestaurantPage extends StatelessWidget {
  const ViewRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Restaurant'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Accepted'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Accepted tab content
            AcceptedTab(),
            // Pending tab content
            PendingTab(),
          ],
        ),
      ),
    );
  }
}

class AcceptedTab extends StatelessWidget {
  const AcceptedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .where('isAccepted', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurants = snapshot.data!.docs;

        return restaurants.isEmpty ? const Center(child: Text('No Resturents registerd yet'),)  :ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final data = restaurants[index].data() as Map<String, dynamic>;
            return   RestaurantCard(
              restaurantName: data['name'],
              location: data['place'],
              phoneNumber: data['phoneNumber'],
              email: data['email'],
              licenseImage: data['imageUrl'],
              showButtons: false);
          },
        );
      },
    );
  }
}

class PendingTab extends StatelessWidget {
  const PendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .where('isAccepted', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurants = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final data = restaurants[index].data() as Map<String, dynamic>;
            return RestaurantCard(
              restaurantName: data['name'],
              location: data['place'],
              phoneNumber: data['phoneNumber'],
              email: data['email'],
              licenseImage: data['imageUrl'],
              showButtons: true,
              onAccept: () {
                // Update Firestore to set the restaurant as accepted
                FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurants[index].id)
                    .update({'isAccepted': true});
              },
              onDecline: () {
                // Handle restaurant decline, for example, deleting from the collection
                FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurants[index].id)
                    .delete();
              },
            );
          },
        );
      },
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String restaurantName;
  final String location;
  final String phoneNumber;
  final String email;
  final String? licenseImage; // Nullable license image path
  final bool showButtons;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RestaurantCard({
    super.key,
    required this.restaurantName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    this.licenseImage,
    this.showButtons = false, // Default to no buttons
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (licenseImage != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImage(imagePath: licenseImage!),
                  ));
                }
              },
              child: licenseImage != null
                  ? Image.network(
                      licenseImage!,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'No License Image',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            if (showButtons)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color for "Accept"
                      ),
                      child: const Text('Accepted'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDecline,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color for "Declined"
                      ),
                      child: const Text('Declined'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Image'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Image.network(imagePath, fit: BoxFit.contain),
      ),
      backgroundColor: Colors.black,
    );
  }
}

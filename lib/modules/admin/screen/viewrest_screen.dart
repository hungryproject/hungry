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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        RestaurantCard(
          restaurantName: 'Pizza Palace',
          location: 'Main Street',
          phoneNumber: '123-456-7890',
          email: 'contact@pizzapalace.com',
          licenseImage: 'asset/images/hi.png', // Example image path
          showButtons: false, // Hide buttons in Accepted tab
        ),
        RestaurantCard(
          restaurantName: 'Burger Town',
          location: 'Broadway',
          phoneNumber: '987-654-3210',
          email: 'info@burgertown.com',
          licenseImage: 'asset/images/hi.png', // Example image path
          showButtons: false, // Hide buttons in Accepted tab
        ),
        // Add more accepted restaurants as needed
      ],
    );
  }
}

class PendingTab extends StatelessWidget {
  const PendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        RestaurantCard(
          restaurantName: 'Sushi Hub',
          location: 'Downtown',
          phoneNumber: '555-123-4567',
          email: 'sushi@hub.com',
          licenseImage: null, // No image provided, use placeholder
          showButtons: true, // Show buttons in Pending tab
          onAccept: () {
            // Handle accepted
          },
          onDecline: () {
            // Handle declined
          },
        ),
        RestaurantCard(
          restaurantName: 'Pasta Heaven',
          location: 'Riverside',
          phoneNumber: '321-987-6543',
          email: 'pasta@heaven.com',
          licenseImage: 'asset/images/hi.png', // Example image path
          showButtons: true, // Show buttons in Pending tab
          onAccept: () {
            // Handle accepted
          },
          onDecline: () {
            // Handle declined
          },
        ),
        // Add more pending restaurants as needed
      ],
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
    Key? key,
    required this.restaurantName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    this.licenseImage,
    this.showButtons = false, // Default to no buttons
    this.onAccept,
    this.onDecline,
  }) : super(key: key);

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
            // Display the license image or a placeholder if no image is provided
            licenseImage != null
                ? Image.asset(
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
            const SizedBox(height: 16),
            // Show buttons only if showButtons is true (only for Pending tab)
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

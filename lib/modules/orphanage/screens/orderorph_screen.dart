import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentOrdersScreen extends StatelessWidget {
  const RecentOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recent Orders'),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Accepted Orders'),
              Tab(text: 'Delivered Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Accepted Orders Tab (Filter by isOrderAccepted == true AND isDelivered == false)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('foods')
                  .where('isOrderAccepted', isEqualTo: true) // Filter for accepted orders
                  .where('isDelivered', isEqualTo: false) // Ensure it's not delivered yet
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Center(child: Text('No accepted orders.'));
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index];
                    return OrderCard(
                      docId: data.id,
                      restaurantName: data['resid'],
                      foodName: data['foodName'],
                      place: 'Unknown Place', // Replace with actual place if available
                      quantity: data['count'],
                      availableUntil: data['availableUntil'],
                      createdAt: (data['createdAt'] as Timestamp).toDate(),
                      isDelivered: data['isDelivered'],
                    );
                  },
                );
              },
            ),

            // Delivered Orders Tab (Filter by isDelivered == true)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('foods')
                  .where('isDelivered', isEqualTo: true) // Filter for delivered orders
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Center(child: Text('No delivered orders.'));
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index];
                    return OrderCard(
                      docId: data.id,
                      restaurantName: data['resid'],
                      foodName: data['foodName'],
                      place: 'Unknown Place', // Replace with actual place if available
                      quantity: data['count'],
                      availableUntil: data['availableUntil'],
                      createdAt: (data['createdAt'] as Timestamp).toDate(),
                      isDelivered: data['isDelivered'],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String docId;
  final String restaurantName;
  final String foodName;
  final String place;
  final int quantity;
  final String availableUntil;
  final DateTime createdAt;
  final bool isDelivered;

  const OrderCard({
    super.key,
    required this.docId,
    required this.restaurantName,
    required this.foodName,
    required this.place,
    required this.quantity,
    required this.availableUntil,
    required this.createdAt,
    required this.isDelivered,
  });

  // Function to update the 'isDelivered' field in Firestore
  Future<void> updateIsDelivered() async {
    await FirebaseFirestore.instance.collection('foods').doc(docId).update({
      'isDelivered': true, // Set 'isDelivered' to true
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Name (or ID)
            Text(
              'Restaurant ID: $restaurantName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Place (You may need to adjust this if actual place info is available)
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8.0),
                Text(
                  place,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Food Item Name
            Text(
              'Food Name: $foodName',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),

            // Quantity
            Text(
              'Quantity: $quantity',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),

            // Available Until Time
            Text(
              'Available Until: $availableUntil',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),

            // Created At Time
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  'Created At: ${createdAt.toLocal().day}/${createdAt.toLocal().month}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            // Button to mark as Delivered
            if (!isDelivered) // Only show the button if not delivered yet
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green

                ),
                onPressed: () {
                  updateIsDelivered();
                },
                child: const Text('Mark as Delivered'),
              ),
            if (isDelivered)
              const Text(
                'Delivered',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

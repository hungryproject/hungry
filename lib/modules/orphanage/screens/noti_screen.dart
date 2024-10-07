import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrphanageOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to accept an order by its ID
  Future<void> accept(String orderId) async {
    try {
      // Update the order document to mark it as accepted
      await _firestore.collection('foods').doc(orderId).update({
        'isOrderAccepted': true, // Mark order as accepted
      });

      print('Order $orderId accepted successfully.');
    } catch (e) {
      print('Error accepting order: $e');
      // Handle any errors here, such as showing a Snackbar or a dialog
    }
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foods')
            .where('isOrderAccepted', isEqualTo: false) // Filter by isOrderAccepted = false
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var documents = snapshot.data!.docs;

          // No data state
          if (documents.isEmpty) {
            return const Center(
              child: Text('No pending orders'),
            );
          }

          // Create an instance of OrphanageOrderService
          final orderService = OrphanageOrderService();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index];
              return NotificationCard(
                restaurantName: data['resid'], // Assuming resid refers to restaurant name
                place: 'Unknown Place',        // You can add the place field if available
                foodItem: data['foodName'],
                quantity: data['quantity'],
                availableUntil: data['availableUntil'], // New field
                orderId: data.id, // Pass the order ID to the card
                orderService: orderService, // Pass the order service instance
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String restaurantName;
  final String place;
  final String foodItem;
  final int quantity;
  final String availableUntil; // New field
  final String orderId; // New field for order ID
  final OrphanageOrderService orderService; // New field for order service

  const NotificationCard({
    super.key,
    required this.restaurantName,
    required this.place,
    required this.foodItem,
    required this.quantity,
    required this.availableUntil, // Accepting availableUntil
    required this.orderId, // Accepting order ID
    required this.orderService, // Accepting order service instance
  });

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now(); // Get the current time
    final availableUntilTime = _parseAvailableUntil(availableUntil);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              restaurantName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              place,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              'Food Item: $foodItem',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Quantity: $quantity',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Available Until: $availableUntil', // Display available until time
              style: const TextStyle(fontSize: 16),
            ),
            // Conditionally display current time
            if (currentTime.isBefore(availableUntilTime)) ...[
              Text(
                'Current Time: ${TimeOfDay.fromDateTime(currentTime).format(context)}', // Display current time
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    // Handle accept action
                    await orderService.accept(orderId); // Call accept method
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Accepted')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 10),
             
              
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to parse the availableUntil time string
  DateTime _parseAvailableUntil(String availableUntil) {
    // Assuming availableUntil is in "hh:mm a" format
    final now = DateTime.now();
    final timeParts = availableUntil.split(' '); // Split time and AM/PM

    final timeString = timeParts[0].split(':'); // Split hours and minutes
    var hour = int.parse(timeString[0]);
    final minute = int.parse(timeString[1]);

    // Adjust hour based on AM/PM
    if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts.length > 1 && timeParts[1].toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    // Create a new DateTime object for the availableUntil time
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

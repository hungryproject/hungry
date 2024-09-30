import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const <Widget>[
          NotificationCard(
            restaurantName: 'The Italian Bistro',
            place: 'Downtown',
            foodItem: 'Spaghetti Carbonara',
            quantity: 2,
          ),
          NotificationCard(
            restaurantName: 'Sushi World',
            place: 'Central Park',
            foodItem: 'California Roll',
            quantity: 1,
          ),
          NotificationCard(
            restaurantName: 'Burger Haven',
            place: 'Uptown',
            foodItem: 'Cheeseburger',
            quantity: 3,
          ),
          // Add more NotificationCard widgets as needed
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String restaurantName;
  final String place;
  final String foodItem;
  final int quantity;

  const NotificationCard({super.key, 
    required this.restaurantName,
    required this.place,
    required this.foodItem,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Handle accept action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Accepted')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.green,
                ),
                  child: const Text('Accept')
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rejected')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

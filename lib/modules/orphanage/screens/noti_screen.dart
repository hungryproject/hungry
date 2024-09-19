import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
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

  NotificationCard({
    required this.restaurantName,
    required this.place,
    required this.foodItem,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              restaurantName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              place,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              'Food Item: $foodItem',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Quantity: $quantity',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Handle accept action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Accepted')),
                    );
                  },
                  child: Text('Accept'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.green,
                )
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rejected')),
                    );
                  },
                  child: Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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

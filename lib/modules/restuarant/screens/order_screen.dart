import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Sample data for the list of orders
  final List<Map<String, String>> orders = [
    {
      'orphanageName': 'Happy Homes Orphanage',
      'place': '123 Elm Street',
      'foodItem': 'Pizza Margherita',
    },
    {
      'orphanageName': 'Sunshine Orphanage',
      'place': '456 Oak Avenue',
      'foodItem': 'Burger',
    },
    {
      'orphanageName': 'Bright Futures Orphanage',
      'place': '789 Pine Road',
      'foodItem': 'Pasta',
    },
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDERS'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return AcceptedOrderCard(
            orphanageName: order['orphanage Name']!,
            place: order['place']!,
            foodItem: order['food Item']!,
          );
        },
      ),
    );
  }
}

class AcceptedOrderCard extends StatelessWidget {
  final String orphanageName;
  final String place;
  final String foodItem;

  const AcceptedOrderCard({
    Key? key,
    required this.orphanageName,
    required this.place,
    required this.foodItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orphanage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              orphanageName,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Place:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              place,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Food Item:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              foodItem,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Full-width rounded rectangle Accept button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Accept button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                child: Text('Accept',style: TextStyle(color: const Color.fromARGB(255, 108, 135, 111)),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

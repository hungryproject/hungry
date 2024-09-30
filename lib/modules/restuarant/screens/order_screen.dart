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

  // List of colors to alternate between cards
  final List<Color> cardColors = [
    Colors.blue[100]!,
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
          final cardColor = cardColors[index % cardColors.length]; // Assign a color based on index

          return AcceptedOrderCard(
            orphanageName: order['orphanageName']!,
            place: order['place']!,
            foodItem: order['foodItem']!,
            color: cardColor, // Pass the color to the card
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
  final Color color; // New color parameter

  const AcceptedOrderCard({
    super.key,
    required this.orphanageName,
    required this.place,
    required this.foodItem,
    required this.color, // Color is required
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color, // Use the color for the card background
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orphanage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              orphanageName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Place:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              place,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Food Item:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              foodItem,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
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
                child: const Text(
                  'Accept',
                  style: TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

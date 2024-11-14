import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  // Sample data for the list of orders
  final List<Map<String, String>> acceptedOrders = [
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
  ];

  final List<Map<String, String>> deliveredOrders = [
    {
      'orphanageName': 'Bright Futures Orphanage',
      'place': '789 Pine Road',
      'foodItem': 'Pasta',
    },
    {
      'orphanageName': 'Helping Hands Orphanage',
      'place': '321 Cedar Blvd',
      'foodItem': 'Sandwich',
    },
  ];

  // List of colors to alternate between cards
  final List<Color> cardColors = [
    Colors.blue[100]!,
    Colors.green[100]!,
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDERS'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accepted Orders'),
            Tab(text: 'Delivered Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Accepted Orders Tab
          ListView.builder(
            itemCount: acceptedOrders.length,
            itemBuilder: (context, index) {
              final order = acceptedOrders[index];
              final cardColor = cardColors[index % cardColors.length];

              return OrderCard(
                orphanageName: order['orphanageName']!,
                place: order['place']!,
                foodItem: order['foodItem']!,
                color: cardColor,
                buttonText: 'Deliver',
                onPressed: () {
                  // Handle Deliver button press
                },
              );
            },
          ),
          // Delivered Orders Tab
          ListView.builder(
            itemCount: deliveredOrders.length,
            itemBuilder: (context, index) {
              final order = deliveredOrders[index];
              final cardColor = cardColors[index % cardColors.length];

              return OrderCard(
                orphanageName: order['orphanageName']!,
                place: order['place']!,
                foodItem: order['foodItem']!,
                color: cardColor,
                buttonText: 'Completed',
                onPressed: null, // Disable button for delivered orders
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orphanageName;
  final String place;
  final String foodItem;
  final Color color;
  final String buttonText;
  final VoidCallback? onPressed;

  const OrderCard({
    super.key,
    required this.orphanageName,
    required this.place,
    required this.foodItem,
    required this.color,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: onPressed != null ? Colors.green : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

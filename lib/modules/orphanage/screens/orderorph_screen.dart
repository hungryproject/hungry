import 'package:flutter/material.dart';

class RecentOrdersScreen extends StatelessWidget {
  // List of accepted orders
  final List<Map<String, String>> acceptedOrders = [
    {
      'restaurantName': 'Pasta Palace',
      'place': 'New York, NY',
      'foodItems': 'Spaghetti, Garlic Bread',
      'time': '12:30 PM',
    },
    {
      'restaurantName': 'Sushi World',
      'place': 'Los Angeles, CA',
      'foodItems': 'Sushi Platter, Miso Soup',
      'time': '2:00 PM',
    },
  ];

  // List of delivered orders
  final List<Map<String, String>> deliveredOrders = [
    {
      'restaurantName': 'Burger Town',
      'place': 'Chicago, IL',
      'foodItems': 'Cheeseburger, Fries',
      'time': '1:15 PM',
    },
  ];

   RecentOrdersScreen({super.key});

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
        body: const TabBarView(
          children: [
            OrdersTab(orders: [
              {
                'restaurantName': 'Pasta Palace',
                'place': 'New York, NY',
                'foodItems': 'Spaghetti, Garlic Bread',
                'time': '12:30 PM',
              },
              {
                'restaurantName': 'Sushi World',
                'place': 'Los Angeles, CA',
                'foodItems': 'Sushi Platter, Miso Soup',
                'time': '2:00 PM',
              },
            ]),
            OrdersTab(orders: [
              {
                'restaurantName': 'Burger Town',
                'place': 'Chicago, IL',
                'foodItems': 'Cheeseburger, Fries',
                'time': '1:15 PM',
              },
            ]),
          ],
        ),
      ),
    );
  }
}

class OrdersTab extends StatelessWidget {
  final List<Map<String, String>> orders;

  const OrdersTab({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Name
            Text(
              order['restaurantName']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Place
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8.0),
                Text(
                  order['place']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Accepted Food Items
            Text(
              'Food Items: ${order['foodItems']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),

            // Time
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  order['time']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



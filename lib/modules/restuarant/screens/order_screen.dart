import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  Future<List<Map<String, dynamic>>> fetchOrdersForCurrentUser(
      String currentUserId) async {
    try {
      // Fetch food documents where resId matches current user ID
      final foodQuerySnapshot = await FirebaseFirestore.instance
          .collection('foods')
          .where('resid', isEqualTo: currentUserId)
          .get();

      // Extract the food IDs from the fetched documents
      final foodIds = foodQuerySnapshot.docs.map((doc) => doc.id).toList();

      // Check if there are any matching food IDs
      if (foodIds.isEmpty) {
        return []; // No matching food items, return an empty list
      }

      // Fetch orders that reference the matching food IDs and where isOrderAccepted is true
      final orderQuerySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('foodId', whereIn: foodIds)
          .where('isOrderAccepted',
              isEqualTo: true) // Filter orders where isOrderAccepted is true
          .where('isRecived', isEqualTo: false)
          .get();

      // Combine order data with food data and orphanage details
      List<Map<String, dynamic>> ordersWithDetails = [];

      for (var orderDoc in orderQuerySnapshot.docs) {
        final orderData = orderDoc.data() as Map<String, dynamic>;

        // Get the food ID from the order
        final foodId = orderData['foodId'];

        // Find the corresponding food document from the foodQuerySnapshot
        final foodDoc = foodQuerySnapshot.docs.firstWhere(
          (doc) => doc.id == foodId,
          orElse: () =>
              throw Exception('Food document not found for foodId $foodId'),
        );

        final foodData = foodDoc.data() as Map<String, dynamic>;

        // Get the orphanage ID from the order
        final orphanageId = orderData['orpId'];

        // Fetch orphanage details using the orphanage ID
        final orphanageDoc = await FirebaseFirestore.instance
            .collection('orphanages')
            .doc(orphanageId)
            .get();

        if (!orphanageDoc.exists) {
          throw Exception(
              'Orphanage document not found for orphanageId $orphanageId');
        }

        final orphanageData = orphanageDoc.data() as Map<String, dynamic>;

        // Combine order, food, and orphanage data
        final combinedData = {
          'orderId': orderDoc.id, // Include order document ID
          ...orderData, // Include order data
          ...foodData, // Include food details
          'orphanageName': orphanageData['orphanageName'], // Orphanage name
          'place': orphanageData['place'], // Orphanage place
        };

        ordersWithDetails.add(combinedData);
      }

      return ordersWithDetails;
    } catch (e) {
      print('Error fetching orders for current user: $e');
      return []; // Return an empty list in case of an error
    }
  }

 

  Future<List<Map<String, dynamic>>> fetchRecievedOrdersForCurrentUser(
      String currentUserId) async {
    try {
      // Fetch food documents where resId matches current user ID
      final foodQuerySnapshot = await FirebaseFirestore.instance
          .collection('foods')
          .where('resid', isEqualTo: currentUserId)
          .get();

      // Extract the food IDs from the fetched documents
      final foodIds = foodQuerySnapshot.docs.map((doc) => doc.id).toList();

      // Check if there are any matching food IDs
      if (foodIds.isEmpty) {
        return []; // No matching food items, return an empty list
      }

      // Fetch orders that reference the matching food IDs and where isOrderAccepted is true
      final orderQuerySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('foodId', whereIn: foodIds)
          .where('isOrderAccepted',
              isEqualTo: true) // Filter orders where isOrderAccepted is true
          .where('isRecived', isEqualTo: true)
          .get();

      // Combine order data with food data and orphanage details
      List<Map<String, dynamic>> ordersWithDetails = [];

      for (var orderDoc in orderQuerySnapshot.docs) {
        final orderData = orderDoc.data() as Map<String, dynamic>;

        // Get the food ID from the order
        final foodId = orderData['foodId'];

        // Find the corresponding food document from the foodQuerySnapshot
        final foodDoc = foodQuerySnapshot.docs.firstWhere(
          (doc) => doc.id == foodId,
          orElse: () =>
              throw Exception('Food document not found for foodId $foodId'),
        );

        final foodData = foodDoc.data() as Map<String, dynamic>;

        // Get the orphanage ID from the order
        final orphanageId = orderData['orpId'];

        // Fetch orphanage details using the orphanage ID
        final orphanageDoc = await FirebaseFirestore.instance
            .collection('orphanages')
            .doc(orphanageId)
            .get();

        if (!orphanageDoc.exists) {
          throw Exception(
              'Orphanage document not found for orphanageId $orphanageId');
        }

        final orphanageData = orphanageDoc.data() as Map<String, dynamic>;

        // Combine order, food, and orphanage data
        final combinedData = {
          'orderId': orderDoc.id, // Include order document ID
          ...orderData, // Include order data
          ...foodData, // Include food details
          'orphanageName': orphanageData['orphanageName'], // Orphanage name
          'place': orphanageData['place'], // Orphanage place
        };

        ordersWithDetails.add(combinedData);
      }

      return ordersWithDetails;
    } catch (e) {
      print('Error fetching orders for current user: $e');
      return []; // Return an empty list in case of an error
    }
  }

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
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDERS'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accepted Orders'),
            Tab(text: 'Recieved Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Accepted Orders Tab
          FutureBuilder(
            future: fetchOrdersForCurrentUser(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while data is being fetched
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any errors
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle case where there is no data
                return Center(child: Text('No orders found.'));
              } else {
                // Data fetched successfully
                final acceptedOrders = snapshot.data;
                print(acceptedOrders);

                return ListView.builder(
                  itemCount: acceptedOrders!.length,
                  itemBuilder: (context, index) {
                    final order = acceptedOrders[index];
                    final cardColor = cardColors[index % cardColors.length];
                    final orderId = order['orderId'];

                    return OrderCard(
                      orphanageName: order['orphanageName'],
                      place: order['place'],
                      foodItem: order['foodName'],
                      color: cardColor,
                      count: order['ordercount'],
                      time: order['availableUntil'],
                      buttonText: 'Recieved',
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orderId)
                            .update({
                          'isRecived': true,
                        });
                        setState(() {});
                      },
                    );
                  },
                );
              }
            },
          ),

          // Delivered Orders Tab
          FutureBuilder(
            future: fetchRecievedOrdersForCurrentUser(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while data is being fetched
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle any errors
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle case where there is no data
                return Center(child: Text('No orders found.'));
              } else {
                // Data fetched successfully
                final acceptedOrders = snapshot.data;
                print(acceptedOrders);

                return ListView.builder(
                  itemCount: acceptedOrders!.length,
                  itemBuilder: (context, index) {
                    final order = acceptedOrders[index];
                    final cardColor = cardColors[index % cardColors.length];

                    return OrderCard(
                        orphanageName: order['orphanageName'],
                        place: order['place'],
                        foodItem: order['foodName'],
                        color: cardColor,
                        count: order['ordercount'],
                        time: order['availableUntil'],
                        buttonText: 'Completed',
                        onPressed: null);
                  },
                );
              }
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
  final int count;
  final String time;
  final VoidCallback? onPressed;

  const OrderCard({
    super.key,
    required this.orphanageName,
    required this.place,
    required this.foodItem,
    required this.color,
    required this.buttonText,
    required this.count,
    required this.time,
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
            const Text(
              'Count:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'Available until:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      onPressed != null ? Colors.green : Colors.grey,
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

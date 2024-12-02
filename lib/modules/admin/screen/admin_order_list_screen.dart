import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminOrderListScreen extends StatefulWidget {
  const AdminOrderListScreen({super.key});

  @override
  _AdminOrderListScreenState createState() => _AdminOrderListScreenState();
}

class _AdminOrderListScreenState extends State<AdminOrderListScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Order List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4.0,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          tabs: [
            Tab(
              icon: Icon(Icons.check_circle, color: Colors.white),
              text: 'Accepted',
            ),
            Tab(
              icon: Icon(Icons.delivery_dining, color: Colors.white),
              text: 'Delivered',
            ),
          ],
        ),
        backgroundColor: Colors.teal, // TabBar background color
      ),
      body: Container(
        // Background color or gradient for TabBarView
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            OrderListTab(isAccepted: true),
            OrderListTab(isDelivered: true),
          ],
        ),
      ),
    );
  }
}

class OrderListTab extends StatelessWidget {
  final bool isAccepted;
  final bool isDelivered;

  const OrderListTab({this.isAccepted = false, this.isDelivered = false, Key? key}) : super(key: key);

  Future<String> getRestaurantName(String resid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('restaurants').doc(resid).get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching restaurant name: $e');
    }
    return 'Unknown';
  }

  String formatCreatedAt(Timestamp timestamp) {
    try {
      final dateTime = timestamp.toDate();
      return DateFormat('hh:mm a, MMM d').format(dateTime); // Example: "11:27 PM, Oct 6"
    } catch (e) {
      print('Error formatting Timestamp: $e');
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('foods').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No orders found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final orders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (isAccepted) return data['isOrderAccepted'] == true && data['isDelivered'] == false;
          if (isDelivered) return data['isDelivered'] == true;
          return false;
        }).toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final data = orders[index].data() as Map<String, dynamic>;
            return FutureBuilder<String>(
              future: getRestaurantName(data['resid']),
              builder: (context, snapshot) {
                final restaurantName = snapshot.data ?? 'Loading...';
                final formattedDate = formatCreatedAt(data['createdAt']);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.withOpacity(0.8),
                            Colors.green.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['foodName'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Restaurant: $restaurantName',
                                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer, size: 16, color: Colors.white70),
                                      const SizedBox(width: 5),
                                      Text('Available Until: ${data['availableUntil']}', style: const TextStyle(fontSize: 14, color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                                      const SizedBox(width: 5),
                                      Text('Created At: $formattedDate', style: const TextStyle(fontSize: 14, color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: isDelivered ? Colors.green : Colors.orange,
                              child: Text(
                                data['quantity'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

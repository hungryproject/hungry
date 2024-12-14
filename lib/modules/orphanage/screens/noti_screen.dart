import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrphanageOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to accept an order by its ID
  Future<void> accept(String orderId, int orderQty, String docId) async {
    try {
      // Step 1: Get the current stock of the food item
      DocumentSnapshot foodDoc = await _firestore.collection('foods').doc(docId).get();
      
      int currentStock = foodDoc['count']; // assuming 'stock' is the field name

      // Step 3: Check if the requested quantity does not exceed the available stock
      if (orderQty <= currentStock) {
        // Step 4: Update the order document to mark it as accepted
        await _firestore.collection('orders').add({
          'foodId' : docId,
          'orpId' : FirebaseAuth.instance.currentUser?.uid,
          'count': orderQty,
          'isOrderAccepted': true, // Mark order as accepted
          'isRecived' : false,
        });

        // Step 5: Decrement the food stock by the order quantity
        await _firestore.collection('foods').doc(docId).update({
          'count': currentStock - orderQty, // Decrement the stock
          
        });

        print('Order $orderId accepted and stock updated successfully.');
      } else {
        print('Not enough stock for the order.');
      }
    } catch (e) {
      print('Error accepting order: $e');
    }
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
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
              child: Text(
                'No pending orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Create an instance of OrphanageOrderService
          final orderService = OrphanageOrderService();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index];
                return NotificationCard(
                  docId: data.id,
                  restaurantName: data['resid'], // Assuming resid refers to restaurant name
                  place: 'Unknown Place',        // You can add the place field if available
                  foodItem: data['foodName'],
                  quantity: data['count'],
                  availableUntil: data['availableUntil'], // New field
                  orderId: data.id, // Pass the order ID to the card
                  orderService: orderService, // Pass the order service instance
                );
              },
            ),
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
  final String availableUntil;
  final String orderId;
  final OrphanageOrderService orderService;
  final String docId;

   NotificationCard({
    super.key,
    required this.restaurantName,
    required this.place,
    required this.foodItem,
    required this.quantity,
    required this.availableUntil,
    required this.orderId,
    required this.orderService, required this.docId,
  });

  TextEditingController _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final availableUntilTime = _parseAvailableUntil(availableUntil);
    final isOrderExpired = currentTime.isAfter(availableUntilTime);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.green.shade500.withOpacity(0.5),
      color: isOrderExpired ? Colors.grey.shade300 : Colors.white, // Disabled look
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents excessive height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(restaurantName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final resData = snapshot.data?.data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resData!['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resData['place'] ?? 'Unknown Place',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade500,
                        ),
                      ),
                    ],
                  );
                }

                return const Text('No data available');
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food: $foodItem',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade600,
                  ),
                ),
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Available Until: $availableUntil',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade600,
              ),
            ),
            if (currentTime.isBefore(availableUntilTime)) ...[ 
              const SizedBox(height: 6),
              Text(
                'Current Time: ${TimeOfDay.fromDateTime(currentTime).format(context)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isOrderExpired
                      ? null // Disable button if the order has expired
                      : () async {
                          // Show dialog to enter the quantity
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Enter Quantity'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _qtyController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      onChanged: (value) {
                                        
                                        // Do nothing here for now
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Handle accept action with the entered quantity
                                      int enteredQuantity = int.tryParse(_qtyController.text) ?? 1; // Replace with actual input
                                      if (enteredQuantity <= quantity) {
                                        await orderService.accept(orderId, enteredQuantity, docId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Order Accepted!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Quantity exceeds available stock!')),
                                        );
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Accept'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOrderExpired
                        ? Colors.grey.shade500 // Disabled color
                        : Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    isOrderExpired ? 'Expired' : 'Accept', // Update text if expired
                    style: TextStyle(
                      color: isOrderExpired
                          ? Colors.grey.shade700 // Disabled text color
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseAvailableUntil(String availableUntil) {
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

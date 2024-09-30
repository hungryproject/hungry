import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/fire_store_serviece.dart'; // Adjust import path as necessary

class FoodFormPage extends StatefulWidget {
  const FoodFormPage({super.key});

  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _foodNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _timeController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService(); // Instance of FirestoreService
  bool _isLoading = false; // Loading state indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Form for Food Details
            const Text(
              'ENTER FOOD DETAILS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time Available Until',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectTime(context);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Display loading indicator or button based on loading state
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 32),
            // Recent Orders Title
            const Text(
              'RECENT FOODS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // StreamBuilder to display pending orders
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getPendingOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching orders: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No pending orders.'));
                } else {
                  final orders = snapshot.data!.docs;
                  return Column(
                    children: orders.map((doc) {
                      final orderData = doc.data() as Map<String, dynamic>;
                      return AcceptedOrderCard(
                        Name: orderData['foodName'] ?? 'Unknown',
                        quantity: orderData['quantity'].toString(),
                        availableUntil: orderData['availableUntil'] ?? 'N/A',
                        date: orderData['createdAt'] != null
                            ? (orderData['createdAt'] as Timestamp).toDate().toString()
                            : 'N/A',
                        onAccept: () {
                         
                        },
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  void _submitForm() async {
    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    // Get input values
    final foodName = _foodNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final timeAvailable = _timeController.text.trim();

    if (foodName.isEmpty || quantity <= 0 || timeAvailable.isEmpty) {
      // Show error message if inputs are not valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields correctly.')),
      );
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Call FirestoreService to add order
    try {
      await _firestoreService.addfood(
        foodName: foodName,
        quantity: quantity,
        availableUntil: timeAvailable,
        isDelivered: false,
        isOrderAccepted: false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order added successfully!')),
      );

      // Clear the form fields
      _foodNameController.clear();
      _quantityController.clear();
      _timeController.clear();
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add order: $e')),
      );
    } finally {
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  
}
class AcceptedOrderCard extends StatelessWidget {
  final String Name;
  final String quantity;
  final String availableUntil;
  final String date;
  final VoidCallback onAccept;

  const AcceptedOrderCard({super.key, 
    required this.Name,
    required this.quantity,
    required this.availableUntil,
    required this.date,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $Name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: $quantity',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Available Until: $availableUntil',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16),
            ),
           
          ],
        ),
      ),
    );
  }
}

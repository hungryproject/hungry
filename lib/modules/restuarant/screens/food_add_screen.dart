import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodFormPage extends StatefulWidget {
  const FoodFormPage({super.key});

  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _foodNameController = TextEditingController();
  final _countController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Donation Form'),
        backgroundColor: Colors.green.shade600,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Donate Your Food Today!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField(_foodNameController, 'Food Name'),
            const SizedBox(height: 16),
            _buildInputField(_countController, 'Count of Individuals Who Can Have', isNumber: true),
            const SizedBox(height: 16),
            _buildTimeField(context),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Donate Now',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
            const SizedBox(height: 32),
            const Text(
              'Recent Food Donations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildRecentDonationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _timeController,
            decoration: InputDecoration(
              labelText: 'Time Available Until',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade600, width: 2),
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectTime(context);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.access_time, color: Colors.green),
          onPressed: () {
            _selectTime(context);
          },
        ),
      ],
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
    setState(() {
      _isLoading = true;
    });

    final foodName = _foodNameController.text.trim();
    final count = int.tryParse(_countController.text.trim()) ?? 0;
    final timeAvailable = _timeController.text.trim();

    if (foodName.isEmpty || count <= 0 || timeAvailable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields correctly.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Get current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You need to be logged in to donate.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Add donation data to Firestore
      await _firestore.collection('foods').add({
        'foodName': foodName,
        'count': count,
        'availableUntil': timeAvailable,
        'createdAt': FieldValue.serverTimestamp(),
        'isDelivered': false, // Assuming the food is not delivered yet
        'isOrderAccepted': false, // Assuming the order is accepted by default
        'resid': user.uid, // Save the user UID
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order added successfully!')),
      );

      _foodNameController.clear();
      _countController.clear();
      _timeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add order: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRecentDonationsList() {
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('foods')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return const Center(child: Text('Something went wrong.'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No recent donations.'));
      }

      final donations = snapshot.data!.docs;

      return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
          color: Colors.grey,
          indent: 20,
          endIndent: 20,
        ),
        shrinkWrap: true,
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          final foodName = donation['foodName'] ?? 'Unknown Food';
          final count = donation['count'] ?? 0;
          final timeAvailable = donation['availableUntil'] ?? 'Unknown Time';
          final isDelivered = donation['isDelivered'] ?? false;
          final isOrderAccepted = donation['isOrderAccepted'] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.fastfood,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          foodName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.group, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'For $count individuals',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 20, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        'Available until $timeAvailable',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Delivered: ${isDelivered ? 'Yes' : 'No'}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_box,
                        size: 20,
                        color: Colors.purple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Order Accepted: ${isOrderAccepted ? 'Yes' : 'No'}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}



}

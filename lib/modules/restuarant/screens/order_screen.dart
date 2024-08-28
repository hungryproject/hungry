import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Food Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoodFormPage(),
    );
  }
}

class FoodFormPage extends StatefulWidget {
  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _foodNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _timeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Food Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Form for Food Details
            Text(
              'ENTER FOOD DETAILS',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _foodNameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
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
                  icon: Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle OK button press
              },
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
              ),
            ),
            SizedBox(height: 32),
            // Recent Orders Title
            Text(
              'RECENT ORDERS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Recent Order Cards
            AcceptedOrderCard(
              orphanageName: 'Happy Homes Orphanage',
              place: '123 Elm Street',
              foodItem: 'Pizza Margherita',
            ),
            AcceptedOrderCard(
              orphanageName: 'Sunshine Orphanage',
              place: '456 Oak Avenue',
              foodItem: 'Burger',
            ),
            AcceptedOrderCard(
              orphanageName: 'Bright Futures Orphanage',
              place: '789 Pine Road',
              foodItem: 'Pasta',
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
}

class AcceptedOrderCard extends StatelessWidget {
  final String orphanageName;
  final String place;
  final String foodItem;

  AcceptedOrderCard({
    required this.orphanageName,
    required this.place,
    required this.foodItem,
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
          ],
        ),
      ),
    );
  }
}

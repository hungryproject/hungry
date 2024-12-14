import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class RecentOrdersScreen extends StatelessWidget {
  const RecentOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            indicatorColor: Colors.orange,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.check_circle_outline, color: Colors.white), text: 'Accepted Orders'),
              Tab(icon: Icon(Icons.receipt_long, color: Colors.white), text: 'Received Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Accepted Orders Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('isOrderAccepted', isEqualTo: true)
                  .where('isRecived', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Center(
                    child: Text(
                      'No accepted orders.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index];
                    return OrderCard(
                     isOrderAccepted: data['isOrderAccepted'],
                      docId: data.id,
                      
                      foodId: data['foodId'],
                     
                      quantity: data['count'],
                      orpId: data['orpId'],

                     
                      isReceived: data['isRecived'],
                    );
                  },
                );
              },
            ),

            // Received Orders Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('isRecived', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Center(
                    child: Text(
                      'No received orders.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var data = documents[index];
                    return OrderCard(
                      isOrderAccepted: data['isOrderAccepted'],
                      docId: data.id,
                      
                      foodId: data['foodId'],
                     
                      quantity: data['count'],
                      orpId: data['orpId'],

                     
                      isReceived: data['isRecived'],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String docId;
  final String foodId;

  final int quantity;
  final String orpId;

  final bool isReceived;
  final bool isOrderAccepted;

  const OrderCard({
    super.key,
    required this.docId,
    required this.foodId,
    required this.orpId,
    required this.quantity,
    required this.isOrderAccepted,
    required this.isReceived
   
  });


  // Update the 'isDelivered' field in the 'orders' collection
  Future<void> updateIsReceived() async {
    await FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'isRecived': true,
    });
  }



  Future<Map<String, dynamic>> fetchFoodDetails(String foodId) async {
  try {
    print(foodId);
    var doc = await FirebaseFirestore.instance.collection('foods').doc(foodId).get();
    print(doc.exists);

    if (doc.exists) {
     

      // Fetch restaurant details using resId from the food document
      String resId = doc['resid']; // Get the restaurant ID from the food document
      var restaurantDoc = await FirebaseFirestore.instance.collection('restaurants').doc(resId).get();
     
      if (restaurantDoc.exists) {
        print(restaurantDoc.data());
        return {
          'foodName': doc['foodName'] ?? 'Unknown Food',
          'availableUntil': doc['availableUntil'] ?? 'Unknown Time',
          'resId': resId,
          'resName': restaurantDoc['name'] ?? 'Unknown Restaurant',
          'resDescription': restaurantDoc['description'] ?? 'No description available',
          'resEmail': restaurantDoc['email'] ?? 'No email provided',
          'resImageUrl': restaurantDoc['imageUrl'] ?? '', // URL for restaurant image
          'resPhoneNumber': restaurantDoc['phoneNumber'] ?? 'No phone number provided',
          'resPlace': restaurantDoc['place'] ?? 'Unknown Location',
        };
      } else {
        return {
          'foodName': doc['foodName'] ?? 'Unknown Food',
          'availableUntil': doc['availableUntil'] ?? 'Unknown Time',
          'resId': resId,
          'resName': 'Unknown Restaurant',
          'resDescription': 'No description available',
          'resEmail': 'No email provided',
          'resImageUrl': '',
          'resPhoneNumber': 'No phone number provided',
          'resPlace': 'Unknown Location',
        };
      }
    } else {
      return {
        'foodName': 'Unknown Food',
        'availableUntil': 'Unknown Time',
        'resId': '',
        'resName': 'Unknown Restaurant',
        'resDescription': 'No description available',
        'resEmail': 'No email provided',
        'resImageUrl': '',
        'resPhoneNumber': 'No phone number provided',
        'resPlace': 'Unknown Location',
      };
    }
  } catch (e) {
    return {
      'foodName': 'Unknown Food',
      'availableUntil': 'Unknown Time',
      'resId': '',
      'resName': 'Unknown Restaurant',
      'resDescription': 'No description available',
      'resEmail': 'No email provided',
      'resImageUrl': '',
      'resPhoneNumber': 'No phone number provided',
      'resPlace': 'Unknown Location',
    };
  }
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchFoodDetails(foodId),
      builder: (context, snapshot) {


       if(snapshot.hasData){

         print(snapshot.data);
        String foodName = snapshot.connectionState == ConnectionState.waiting
            ? 'Loading...'
            : snapshot.data?['foodName'] ?? 'Unknown Food';
        String availableUntil = snapshot.connectionState == ConnectionState.waiting
            ? 'Loading...'
            : snapshot.data?['availableUntil'] ?? 'Unknown Time';
        
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        snapshot.data?['resName']??'name', // Replace with actual restaurant name if needed
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    // Text(
                    //   '${createdAt.toLocal().day}/${createdAt.toLocal().month}/${createdAt.toLocal().year}',
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 8.0),

                // Place Information
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.orange, size: 20),
                    const SizedBox(width: 8.0),
                    Text(
                      snapshot.data!['resPlace']??'place',
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Food Name and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Food: $foodName',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Qty: $quantity',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                // Available Until
                Text(
                  'Available Until: $availableUntil',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8.0),

               
                
                const SizedBox(height: 16.0),

                // Actions
                if (!isReceived)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                      ),
                      onPressed: () async {
                        await updateIsReceived();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check, color: Colors.white, size: 18),
                          SizedBox(width: 8.0),
                          Text(
                            'Mark as Received',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isReceived)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Order Received',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
     
       }

       return Center(
        child: SizedBox()
       );
     
      },
    );
  }
}

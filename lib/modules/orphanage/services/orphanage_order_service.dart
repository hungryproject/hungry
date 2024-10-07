import 'package:cloud_firestore/cloud_firestore.dart';

class OrphanageOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to accept an order by its ID
  Future<void> accept(String orderId) async {
    try {
      // Update the order document to mark it as accepted
      await _firestore.collection('foods').doc(orderId).update({
        'isOrderAccepted': true, // Mark order as accepted
      });

      print('Order $orderId accepted successfully.');
    } catch (e) {
      print('Error accepting order: $e');
      // Handle any errors here, such as showing a Snackbar or a dialog
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';


class OrphanageReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a list of reviews and ratings to a single document in Firestore
  Future<void> addReviewsAndRatings(String restaurantId,String userId,int rating, String review) async {
    try {

      print(restaurantId);
      
      _firestore.collection('review_rating').add({
        'review' : review,
        'rating' : rating,
        'userid': userId,
        'resturentId' : restaurantId  
      });




 
    } catch (e) {
      rethrow;
    }
  }
}

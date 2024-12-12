import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantReviewScreen extends StatelessWidget {

  const RestaurantReviewScreen({Key? key,}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('review_rating')
            .snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var reviews = snapshot.data?.docs ?? [];

          // Handle empty state
          if (reviews.isEmpty) {
            return const Center(
              child: Text('No reviews yet'),
            );
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var reviewData = reviews[index];
              return ReviewCard(
                restaurantId: reviewData['resturentId'],
                rating: reviewData['rating'].toDouble(),
                review: reviewData['review'],
              );
            },
          );
        },
      ),
    );
  }
}


class ReviewCard extends StatelessWidget {
  final String restaurantId; // ID of the restaurant to fetch its name
  final double rating;
  final String review;

  const ReviewCard({
    Key? key,
    required this.restaurantId,
    required this.rating,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // StreamBuilder to fetch the restaurant name in real-time
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(restaurantId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading restaurant name...');
                }
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('Unknown Restaurant');
                }
                final restaurantData = snapshot.data!.data() as Map<String, dynamic>;
                final restaurantName = restaurantData['name'] ?? 'Unknown Restaurant';
                return Text(
                  restaurantName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
                const SizedBox(width: 8),
                Text('$rating'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              review,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}



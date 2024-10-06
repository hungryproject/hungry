import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/orphanage/services/OrphanageAuthServices.dart';
import 'package:hungry/modules/orphanage/services/orphanage_review_service.dart';
import 'package:hungry/modules/restuarant/service/firebase_auth_services.dart';

class Restaurantscreen extends StatefulWidget {
  final String location;
  final String phone;
  final String manager;
  final String description;
  final String image;
  final String id;

  const Restaurantscreen(
      {super.key,
      required this.location,
      required this.phone,
      required this.manager,
      required this.description,
      required this.image,
      required this.id});

  @override
  State<Restaurantscreen> createState() => _RestaurantscreenState();
}

class _RestaurantscreenState extends State<Restaurantscreen> {
  final TextEditingController _feedbackController = TextEditingController();

  final _auth =  OrphanageAuthServices();

  double _rating = 3.5;
  bool _isLoading = false; // Loading state

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      // Call your Firestore service to submit the feedback
      final orphanageReviewService = OrphanageReviewService();
      await orphanageReviewService.addReviewsAndRatings(
        widget.id,
        _auth.getId() , // Replace with the actual user ID
        _rating.toInt(),
        _feedbackController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top image
            Container(
              height: MediaQuery.of(context).size.height /
                  3, // Adjust height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Bottom section with curved top corners
            Positioned(
              top: 220.0, // Overlap the image
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 220,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          'Details Section',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 8.0),
                            Text(
                              widget.location,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),

                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 8.0),
                            Text(
                              widget.phone,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),

                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.orange),
                            const SizedBox(width: 8.0),
                            Text(
                              widget.manager,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),

                        const Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                          endIndent: 10,
                          indent: 10,
                        ),
                        const SizedBox(height: 16.0),

                        SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 100,
                          child: TextField(
                            controller: _feedbackController,
                            minLines: 6,
                            maxLines: 100,
                            decoration: InputDecoration(
                              hintText: 'Enter your feedback here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        AnimatedRatingStars(
                          initialRating: _rating,
                          minRating: 0.0,
                          maxRating: 5.0,
                          filledColor: Colors.amber,
                          emptyColor: Colors.grey,
                          filledIcon: Icons.star,
                          halfFilledIcon: Icons.star_half,
                          emptyIcon: Icons.star_border,
                          onChanged: (double rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                          displayRatingValue: true,
                          interactiveTooltips: true,
                          customFilledIcon: Icons.star,
                          customHalfFilledIcon: Icons.star_half,
                          customEmptyIcon: Icons.star_border,
                          starSize: 20.0,
                          animationDuration: const Duration(milliseconds: 300),
                          animationCurve: Curves.easeInOut,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _submitFeedback, // Disable button if loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 216, 236, 6), // Yellow color
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 14, 15, 14),
                                fontSize: 16,
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : const Text('Submit Feedback'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



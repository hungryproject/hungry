import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/orphanage/screens/restaurant_screen.dart';

class Orphanagehomescreen extends StatefulWidget {
  const Orphanagehomescreen({super.key});

  @override
  State<Orphanagehomescreen> createState() => _OrphanagehomescreenState();
}

class _OrphanagehomescreenState extends State<Orphanagehomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Lend a hand, give a can',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // StreamBuilder for Carousel
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('banners').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading banners.'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final banners = snapshot.data?.docs ?? [];

              if (banners.isEmpty) {
                return const Center(child: Text('No banners available.'));
              }

              return CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: banners.map((banner) {
                  final imageUrl = banner['imageUrl'] ?? '';
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 20),
          const Text(
            'Nearby Restaurants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // StreamBuilder for Restaurants List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading restaurants.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final restaurants = snapshot.data?.docs ?? [];

                if (restaurants.isEmpty) {
                  return const Center(child: Text('No restaurants available.'));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurants.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    print('-----------------------------------------');

                    print(restaurant.data());
                    final name = restaurant['name'] ?? 'Unnamed Restaurant';
                    final imageUrl = restaurant['imageUrl'] ?? '';
                    final location = restaurant['place'] ?? 'Unknown Location';
                    final phone  = restaurant['phoneNumber'] ?? 'phone';
                    final desc = restaurant['description'] ?? 'description';
 
                    return Container(
                      width: 200,
                      height: 200,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Restaurantscreen(
                                location: location,
                                phone:   phone,
                                description: desc,
                                image: imageUrl,
                                manager: name,
                                id: restaurant.id
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.network(
                                  imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      location,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    AnimatedRatingStars(
                                      initialRating: 3.5,
                                      minRating: 0.0,
                                      maxRating: 5.0,
                                      filledColor: Colors.amber,
                                      emptyColor: Colors.grey,
                                      filledIcon: Icons.star,
                                      halfFilledIcon: Icons.star_half,
                                      emptyIcon: Icons.star_border,
                                      onChanged: (double rating) {  
                                      },
                                      displayRatingValue: true,
                                      interactiveTooltips: true,
                                      customFilledIcon: Icons.star,
                                      customHalfFilledIcon: Icons.star_half,
                                      customEmptyIcon: Icons.star_border,
                                      starSize: 20.0,
                                      animationDuration: const Duration(milliseconds: 300),
                                      animationCurve: Curves.easeInOut,
                                      readOnly: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

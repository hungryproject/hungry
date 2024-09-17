import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/orphanage/screens/orphanagedetails_screen.dart';

class Orphanagehomescreen extends StatefulWidget {
  const Orphanagehomescreen({super.key});

  @override
  State<Orphanagehomescreen> createState() => _OrphanagehomescreenState();
}

class _OrphanagehomescreenState extends State<Orphanagehomescreen> {
  final List<Widget> imagelist = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        "asset/images/1000_F_263972163_xjqgCRQlDD4azp31qqpcE4okbxDK6pAu.jpg",
        fit: BoxFit.cover,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Give and Donate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: imagelist,
          ),
          const SizedBox(height: 20),
          const Text(
            'Nearby Orphanages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4, // Number of orphanages to display
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Restauranrdetailscreen(
                              location: 'calicut',
                              phone: '2425266',
                              description: 'hello',
                              image:
                                  'https://images.pLeather, MDF, PET, Acyrlicexels.com/photos/933624/pexels-photo-933624.jpeg?auto=compress&cs=tinysrgb&w=600',
                              manager: 'priya',
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
                              child: Image.asset(
                                'asset/images/1000_F_263972163_xjqgCRQlDD4azp31qqpcE4okbxDK6pAu.jpg',
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
                                  const Text(
                                    'Resturent',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'place',
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
                                      // Handle the rating change here
                                      print('Rating: $rating');
                                    },
                                    displayRatingValue: true,
                                    interactiveTooltips: true,
                                    customFilledIcon: Icons.star,
                                    customHalfFilledIcon: Icons.star_half,
                                    customEmptyIcon: Icons.star_border,
                                    starSize: 20.0,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    animationCurve: Curves.easeInOut,
                                    readOnly: true,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

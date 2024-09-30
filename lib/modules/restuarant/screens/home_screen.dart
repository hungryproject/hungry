import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/screens/orphanage_detailpage_screen.dart';

class RestaurantHomeScreen extends StatelessWidget {
  final List<Widget> imagelist = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        "asset/images/1000_F_263972163_xjqgCRQlDD4azp31qqpcE4okbxDK6pAu.jpg",
        fit: BoxFit.cover,
      ),
    ),
  ];

   RestaurantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Lend a hand,give a can',
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // Number of orphanages to display
                  itemBuilder: (context, index) {
                   

                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrphanageDetailScreen(
                                    description:
                                        'his is a small description of the details section. Here you can add any relevant information about the item or place that the image represents. This area is perfect for a brief overview or summary.',
                                    location: 'calicut',
                                    manager: 'jhone',
                                    phone: '12345678',
                                    image:
                                        'https://images.pLeather, MDF, PET, Acyrlicexels.com/photos/933624/pexels-photo-933624.jpeg?auto=compress&cs=tinysrgb&w=600'),
                              ));
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
                                      'Orphanages',
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
      ),
    );
  }
}

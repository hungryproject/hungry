import 'package:flutter/material.dart';

class Restaurantscreen extends StatelessWidget {
  final String location;
  final String phone;
  final String manager;
  final String description;
  final String image;

  const Restaurantscreen({
    super.key,
    required this.location,
    required this.phone,
    required this.manager,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top image
            Container(
              height: MediaQuery.of(context).size.height / 3, // Adjust height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
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
                child: SingleChildScrollView( // Makes content scrollable
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        // Title Section
                        const Text(
                          'Details Section',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Location with Icon
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 8.0),
                            Text(
                              location,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),

                        // Phone with Icon
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 8.0),
                            Text(
                              phone,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),

                        // Manager with Icon
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.orange),
                            const SizedBox(width: 8.0),
                            Text(
                              manager,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),

                        // Divider
                        const Divider(
                          color: Colors.grey, // Thin grey divider
                          thickness: 1.0,
                          endIndent: 10,
                          indent: 10,
                        ),
                        const SizedBox(height: 16.0),

                        // Description
                        Container(
                          height: 200, // Limiting height for scrolling behavior
                          child: SingleChildScrollView(
                            child: Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        
                        // Feedback TextField
                        SizedBox(
                          height: 100, // Fixed height for the TextField
                          child: TextField(
                            minLines: 6,
                            maxLines: 100, // Allows for multiline input
                            decoration: InputDecoration(
                              hintText: 'Enter your feedback here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        Container(
  width: MediaQuery.of(context).size.width, // Full width of the screen
  child: ElevatedButton(
    onPressed: () {
      // Handle feedback submission here
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 216, 236, 6), // Set the button color to yellow
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 14, 15, 14), // Set the text color to black for better contrast
        fontSize: 16,
      ),
    ),
    child: const Text('Submit Feedback'),
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

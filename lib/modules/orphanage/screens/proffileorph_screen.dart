import 'package:flutter/material.dart';

class Proffileorph extends StatelessWidget {
  const Proffileorph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphanage Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              

              // Orphanage Name
              const Text(
                'DRE orphanage',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              // Place
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8.0),
                  Text(
                    'othaloor',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Mail ID
              const Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8.0),
                  Text(
                    'pthdm1234',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Phone Number
              const Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 8.0),
                  Text(
                    '79078',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Orphanage Photos Section
              const Text(
                'Photos:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6QOetK7LLAXiocW1CHod3ULGxn6ZA3k894Q&usqp=CAU',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 10.0),

              // Photo Gallery using ListView

              const SizedBox(height: 16.0),

              // Location Section
              const Text(
                'Location:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Row(
                children: [
                  Icon(Icons.map, color: Colors.orange),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'ptb',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

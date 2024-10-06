import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Vieworphpage extends StatelessWidget {
  const Vieworphpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View orphanage'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Accepted'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Accepted tab content
            AcceptedTab(),
            // Pending tab content
            PendingTab(),
          ],
        ),
      ),
    );
  }
}

class AcceptedTab extends StatelessWidget {
  const AcceptedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orphanages')
          .where('isAccepted', isEqualTo: true) // Filter for accepted orphanages
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orphanages = snapshot.data!.docs;

        if (orphanages.isEmpty) {
          return const Center(child: Text('No accepted orphanages found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: orphanages.length,
          itemBuilder: (context, index) {
            final orphanage = orphanages[index];
            return OrphanageCard(
              orphanageName: orphanage['orphanageName'],
              location: orphanage['place'],
              phoneNumber: orphanage['phoneNumber'],
              email: orphanage['email'],
              licenseImage: orphanage['licensePhotoUrl'],
              showButtons: false, // No buttons for accepted orphanages
            );
          },
        );
      },
    );
  }
}

class PendingTab extends StatelessWidget {
  const PendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orphanages')
          .where('isAccepted', isEqualTo: false) // Filter for pending orphanages
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orphanages = snapshot.data!.docs;

        if (orphanages.isEmpty) {
          return const Center(child: Text('No pending orphanages found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: orphanages.length,
          itemBuilder: (context, index) {
            final orphanage = orphanages[index];
            return OrphanageCard(
              orphanageName: orphanage['orphanageName'],
              location: orphanage['place'],
              phoneNumber: orphanage['phoneNumber'],
              email: orphanage['email'],
              licenseImage: orphanage['licensePhotoUrl'],
              showButtons: true, // Show buttons for pending orphanages
              onAccept: () {
                FirebaseFirestore.instance
                    .collection('orphanages')
                    .doc(orphanage.id)
                    .update({'isAccepted': true});
              },
              onDecline: () {
                FirebaseFirestore.instance
                    .collection('orphanages')
                    .doc(orphanage.id)
                    .delete();
              },
            );
          },
        );
      },
    );
  }
}

class OrphanageCard extends StatelessWidget {
  final String orphanageName;
  final String location;
  final String phoneNumber;
  final String email;
  final String? licenseImage; // Nullable license image path
  final bool showButtons;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const OrphanageCard({
    super.key,
    required this.orphanageName,
    required this.location,
    required this.phoneNumber,
    required this.email,
    this.licenseImage,
    this.showButtons = false, // Default to no buttons
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orphanageName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Display the license image or a placeholder if no image is provided
            licenseImage != null
                ? GestureDetector(
                    onTap: () {
                      _showFullImage(context, licenseImage!);
                    },
                    child: Image.network(
                      licenseImage!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'No License Image',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            // Show buttons only if showButtons is true (only for Pending tab)
            if (showButtons)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color for "Accept"
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDecline,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color for "Decline"
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

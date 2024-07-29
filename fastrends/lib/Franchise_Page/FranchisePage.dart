import 'package:fastrends/Franchise_Page/FranchiseRegistration.dart';
import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'FranchiseDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FranchiseListingRequestPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  FranchiseListingRequestPage({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: FranchiseList()),
            SizedBox(height: 10),
            HostFranchiseButton(
                onItemTapped: onItemTapped, currentIndex: currentIndex),
          ],
        ),
      ),
      title: 'Franchise Listings',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

class FranchiseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Franchises').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final franchises = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FranchiseCard(
              companyName: data['franchise_name'] ?? '',
              description: data['description'] ?? '',
              logoUrl: data['logo'] ?? 'https://via.placeholder.com/50',
              franchiseFee: data['franchise_fee'] ?? '',
              location: data['location'] ?? '',
              contact: data['email'] ?? '',
              companyPhotos: List<String>.from(data['company_photos'] ?? []),
              reviews: _generateRandomReviews(), // Generate random reviews
              address: data['address'] ?? '',
              businessCategory: data['business_category'] ?? '',
              userId: data['user_id'] ?? '',
            );
          }).toList();

          return ListView(children: franchises);
        } else {
          return Center(child: Text('No franchises available.'));
        }
      },
    );
  }

  List<Review> _generateRandomReviews() {
    final random = Random();
    final reviewTemplates = [
      Review(
          user: 'User 1',
          rating: 5,
          comment: 'Great company with excellent support!'),
      Review(
          user: 'User 2',
          rating: 4,
          comment: 'Highly recommended for new entrepreneurs.'),
      Review(
          user: 'User 3',
          rating: 3,
          comment: 'Good, but there is room for improvement.'),
      Review(
          user: 'User 4',
          rating: 5,
          comment: 'Fantastic experience, very supportive!'),
      Review(
          user: 'User 5',
          rating: 4,
          comment: 'Solid business model, worth investing.'),
    ];

    reviewTemplates.shuffle(random);
    return reviewTemplates.sublist(
        0, random.nextInt(reviewTemplates.length) + 1);
  }
}

class FranchiseCard extends StatelessWidget {
  final String companyName;
  final String description;
  final String logoUrl;
  final String franchiseFee;
  final String location;
  final String contact;
  final List<String> companyPhotos;
  final List<Review> reviews;
  final String address;
  final String businessCategory;
  final String userId;

  FranchiseCard({
    required this.companyName,
    required this.description,
    required this.logoUrl,
    required this.franchiseFee,
    required this.location,
    required this.contact,
    required this.companyPhotos,
    required this.reviews,
    required this.address,
    required this.businessCategory,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    double averageRating = reviews.isNotEmpty
        ? reviews.map((review) => review.rating).reduce((a, b) => a + b) /
            reviews.length
        : 0;
    String formattedRating = averageRating.toStringAsFixed(2);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(logoUrl),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 65),
                RatingBarIndicator(
                  rating: averageRating,
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                SizedBox(width: 5),
                Text(
                  '$formattedRating (${reviews.length} reviews)',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FranchiseDetailPage(
                          companyName: companyName,
                          description: description,
                          logoUrl: logoUrl,
                          franchiseFee: franchiseFee,
                          location: location,
                          contact: contact,
                          companyPhotos: companyPhotos,
                          reviews: reviews,
                          address: address,
                          businessCategory: businessCategory,
                          investmentRange:
                              'To be defined', // Add appropriate value
                          website: 'To be defined', // Add appropriate value
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('View Details'),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    _launchEmail(contact);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Enquire Franchise'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Franchise Inquiry&body=Hello, I would like to know more about your franchise opportunities.',
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $params';
    }
  }
}

class HostFranchiseButton extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  HostFranchiseButton({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FranchiseRegistrationPage(
              onItemTapped: onItemTapped,
              currentIndex: currentIndex,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        'Want To Expand Your Business?',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

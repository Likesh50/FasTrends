import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FranchiseDetailPage extends StatelessWidget {
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
  final String investmentRange;
  final String website;

  FranchiseDetailPage({
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
    required this.investmentRange,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    double averageRating = reviews.isNotEmpty
        ? reviews.map((review) => review.rating).reduce((a, b) => a + b) /
            reviews.length
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Franchise Details'),
        backgroundColor: Color.fromARGB(214, 1, 149, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(logoUrl),
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              companyName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchEmail(contact);
              },
              child: Text(
                'Contact: $contact',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Franchise Fee: $franchiseFee',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Investment Range: $investmentRange',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Business Category: $businessCategory',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: companyPhotos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(companyPhotos[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            RatingBarIndicator(
              rating: averageRating,
              itemBuilder: (context, index) =>
                  Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 30.0,
              direction: Axis.horizontal,
            ),
            SizedBox(height: 10),
            Text(
              '$averageRating (${reviews.length} reviews)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children:
                  reviews.map((review) => ReviewCard(review: review)).toList(),
            ),
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

class ReviewCard extends StatelessWidget {
  final Review review;

  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Row(
          children: [
            Text(review.user),
            SizedBox(width: 8),
            Row(
              children: List.generate(
                review.rating,
                (index) => Icon(Icons.star, color: Colors.amber, size: 16),
              ),
            ),
          ],
        ),
        subtitle: Text(review.comment),
      ),
    );
  }
}

class Review {
  final String user;
  final int rating;
  final String comment;

  Review({required this.user, required this.rating, required this.comment});
}

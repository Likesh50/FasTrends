import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatelessWidget {
  final String title;
  final bool isPaid;
  final String link;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String location;
  final String speaker;
  final String organization;
  final String imageUrl;

  EventDetailPage({
    required this.title,
    required this.isPaid,
    required this.link,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.speaker,
    required this.organization,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              isPaid ? 'Paid Event' : 'Free Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPaid ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchURL(link),
              child: Text(
                'Event Link',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow(Icons.date_range, 'Start Date:', startDate),
            _buildDetailRow(Icons.access_time, 'Start Time:', startTime),
            _buildDetailRow(Icons.date_range, 'End Date:', endDate),
            _buildDetailRow(Icons.access_time, 'End Time:', endTime),
            _buildDetailRow(Icons.location_on, 'Location:', location),
            _buildDetailRow(Icons.person, 'Speaker:', speaker),
            _buildDetailRow(Icons.business, 'Organization:', organization),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

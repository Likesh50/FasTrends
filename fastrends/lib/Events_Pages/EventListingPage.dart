import 'package:fastrends/Events_Pages/EventDetailPage.dart';
import 'package:fastrends/Events_Pages/EventRegistrationPage.dart';
import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import this for the updated url_launcher functions

class EventListingPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  EventListingPage({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Event Listings',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: EventList()),
            SizedBox(height: 10),
            HostEventButton(
                onItemTapped: onItemTapped, currentIndex: currentIndex),
          ],
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        EventCard(
          title: 'Tech Conference 2024',
          description:
              'A leading tech conference with industry experts sharing insights on the latest trends in technology.',
          eventType: 'Paid',
          eventLink: 'https://example.com/techconference2024',
          dateTime: 'August 10, 2024, 10:00 AM',
          location: 'San Francisco, CA',
          speaker: 'John Doe',
          organisation: 'Tech World',
          imageUrl: 'https://example.com/images/tech_conference.jpg',
        ),
        EventCard(
          title: 'Business Summit 2024',
          description:
              'Join us for a business summit where top leaders discuss strategies for growth and success.',
          eventType: 'Non-Paid',
          eventLink: 'https://example.com/businesssummit2024',
          dateTime: 'September 5, 2024, 9:00 AM',
          location: 'New York, NY',
          speaker: 'Jane Smith',
          organisation: 'Business Inc.',
          imageUrl: 'https://example.com/images/business_summit.jpg',
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String eventType;
  final String eventLink;
  final String dateTime;
  final String location;
  final String speaker;
  final String organisation;
  final String imageUrl;

  EventCard({
    required this.title,
    required this.description,
    required this.eventType,
    required this.eventLink,
    required this.dateTime,
    required this.location,
    required this.speaker,
    required this.organisation,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(imageUrl),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(description),
            SizedBox(height: 10),
            Text('Event Type: $eventType'),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () => _launchURL(eventLink),
              child: Text(
                eventLink,
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 5),
            Text('Date and Time: $dateTime'),
            SizedBox(height: 5),
            Text('Location: $location'),
            SizedBox(height: 5),
            Text('Speaker: $speaker'),
            SizedBox(height: 5),
            Text('Organisation: $organisation'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          title: title,
                          isPaid: eventType == 'Paid',
                          link: eventLink,
                          date: dateTime.split(', ')[0],
                          time: dateTime.split(', ')[1],
                          location: location,
                          speaker: speaker,
                          organization: organisation,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}

class HostEventButton extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  HostEventButton({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventRegistrationPage(
              onItemTapped: onItemTapped,
              currentIndex: currentIndex,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        'Host Your Event',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

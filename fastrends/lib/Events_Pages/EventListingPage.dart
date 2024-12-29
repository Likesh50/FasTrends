import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/Events_Pages/EventDetailPage.dart';
import 'package:fastrends/Events_Pages/EventRegistrationPage.dart';
import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fastrends/config.dart';

//two language option place
class EventListingPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  EventListingPage({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    String languageoption = 'ta';
    return MainLayout(
      title: Config.events[languageoption]!,
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: EventList()),
            SizedBox(height: 10),
            HostEventButton(
              onItemTapped: onItemTapped,
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final events = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final startDateTime = event['start_date_time'];
            final endDateTime = event['end_date_time'];

            return EventCard(
              title: event['title'],
              description: event['description'],
              eventType: event['event_type'],
              eventLink: event['event_link'],
              startDate: _formatDateTime(startDateTime),
              startTime: _formatTime(startDateTime),
              endDate: _formatDateTime(endDateTime),
              endTime: _formatTime(endDateTime),
              location: event['location'],
              speaker: event['speaker'],
              organisation: event['organisation'],
              imageUrl: event['image_url'],
            );
          },
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String eventType;
  final String eventLink;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String location;
  final String speaker;
  final String organisation;
  final String imageUrl;

  EventCard({
    required this.title,
    required this.description,
    required this.eventType,
    required this.eventLink,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.speaker,
    required this.organisation,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String languageoption = 'ta';
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
            Text(Config.eventType[languageoption]! + eventType),
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
            Text(Config.startDate[languageoption]! + startDate),
            SizedBox(height: 5),
            Text(Config.startTime[languageoption]! + startTime),
            SizedBox(height: 5),
            Text(Config.endDate[languageoption]! + endDate),
            SizedBox(height: 5),
            Text(Config.endTime[languageoption]! + endTime),
            SizedBox(height: 5),
            Text(Config.location[languageoption]! + location),
            SizedBox(height: 5),
            Text("speaker" + speaker),
            SizedBox(height: 5),
            Text(Config.organization[languageoption]! + organisation),
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
                          startDate: startDate,
                          startTime: startTime,
                          endDate: endDate,
                          endTime: endTime,
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
                  child: Text(Config.viewDetails[languageoption]!),
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

  HostEventButton({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final String languangeoption = 'ta';
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
        "Host your event",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

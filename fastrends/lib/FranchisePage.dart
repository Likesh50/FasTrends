import 'package:flutter/material.dart';

class FranchiseListingRequestPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  FranchiseListingRequestPage(
      {required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: FranchiseList()),
            SizedBox(height: 10),
            HostFranchiseButton(),
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
    return ListView(
      children: [
        FranchiseCard(
          companyName: 'Company A',
          description:
              'A leading company in the tech industry. Providing innovative solutions for modern businesses and expanding globally.',
          logoUrl: 'https://via.placeholder.com/50',
          franchiseFee: '\$50,000',
          location: 'San Francisco, CA',
          contact: 'contact@companya.com',
        ),
        FranchiseCard(
          companyName: 'Company B',
          description:
              'Innovative solutions for modern businesses. Specializes in cutting-edge technology and comprehensive business services.',
          logoUrl: 'https://via.placeholder.com/50',
          franchiseFee: '\$40,000',
          location: 'New York, NY',
          contact: 'contact@companyb.com',
        ),
      ],
    );
  }
}

class FranchiseCard extends StatelessWidget {
  final String companyName;
  final String description;
  final String logoUrl;
  final String franchiseFee;
  final String location;
  final String contact;

  FranchiseCard({
    required this.companyName,
    required this.description,
    required this.logoUrl,
    required this.franchiseFee,
    required this.location,
    required this.contact,
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
            Text('Franchise Fee: $franchiseFee'),
            Text('Location: $location'),
            Text('Contact: $contact'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Request'),
            ),
          ],
        ),
      ),
    );
  }
}

class HostFranchiseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to host franchise form or perform necessary action
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text('Want to host your company as a franchise?'),
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget body;
  final Function(int) onItemTapped;
  final String title;
  final int currentIndex;

  MainLayout({
    required this.body,
    required this.onItemTapped,
    required this.currentIndex,
    this.title = 'App Title',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 1, 149, 255),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(title, style: TextStyle(fontSize: 18)),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with your profile photo URL
          ),
          SizedBox(width: 16),
        ],
      ),
      body: body,
      bottomNavigationBar: AppBottomNavigationBar(
        onItemTapped: onItemTapped,
        currentIndex: currentIndex,
      ),
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  AppBottomNavigationBar({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Franchise',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'News Summary',
        ),
      ],
      selectedItemColor: Color(0xFF1F41BB),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onItemTapped,
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FranchiseListingRequestPage(
      onItemTapped: (index) {},
      currentIndex: 3,
    ),
  ));
}

import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  MyHomePage({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: HomeContent(),
      title: 'Home',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello User', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16.0),
          GraphAnalytics(),
          SizedBox(height: 16.0),
          SummaryCard(),
        ],
      ),
    );
  }
}

class GraphAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 200.0,
      child: Center(
        child: Text(
          'Graph Analytics',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Summary'),
        subtitle: Text(
          'This is a brief summary of the current analytics and metrics related to the industry.',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailedSummaryPage()),
          );
        },
      ),
    );
  }
}

class DetailedSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1F41BB),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text('Detailed Summary', style: TextStyle(fontSize: 18)),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with your profile photo URL
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Text('Detailed summary information goes here.'),
      ),
    );
  }
}

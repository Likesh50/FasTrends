import 'package:flutter/material.dart';

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
        backgroundColor: Color.fromARGB(214, 1, 149, 255),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white, // Set title color to white
          ),
        ),
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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onItemTapped,
    );
  }
}

import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final Function(int) onItemTapped;

  AppBottomNavigationBar({required this.onItemTapped});

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
      onTap: onItemTapped,
    );
  }
}

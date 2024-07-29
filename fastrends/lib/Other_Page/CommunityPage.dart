import 'package:flutter/material.dart';
import 'package:fastrends/Main_Pages/Layout.dart';

class CommunityPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  CommunityPage({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(child: Text('Community Page Content')),
      title: 'Community',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fastrends/Layout.dart';

class NewsSummaryPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  NewsSummaryPage({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(child: Text('Explore Page Content')),
      title: 'Explore',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

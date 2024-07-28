import 'package:flutter/material.dart';
import 'package:fastrends/Dashboard.dart';
import 'package:fastrends/ExplorePage.dart';
import 'package:fastrends/CommunityPage.dart';
import 'package:fastrends/FranchisePage.dart';
import 'package:fastrends/NewsSummaryPage.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      MyHomePage(onItemTapped: _onItemTapped, currentIndex: 0),
      ExplorePage(onItemTapped: _onItemTapped, currentIndex: 1),
      CommunityPage(onItemTapped: _onItemTapped, currentIndex: 2),
      FranchiseListingRequestPage(onItemTapped: _onItemTapped, currentIndex: 3),
      NewsSummaryPage(onItemTapped: _onItemTapped, currentIndex: 4),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _pages[_selectedIndex],
    );
  }
}

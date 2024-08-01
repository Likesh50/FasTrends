import 'package:flutter/material.dart';
import 'package:fastrends/Other_Page/Dashboard.dart';
import 'package:fastrends/Other_Page/ExplorePage.dart';
import 'package:fastrends/Other_Page/CommunityPage.dart';
import 'package:fastrends/Franchise_Page/FranchisePage.dart';
import 'package:fastrends/Events_Pages/EventListingPage.dart';

class MainApp extends StatefulWidget {
  final int initialIndex;

  MainApp({this.initialIndex = 0});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late int _selectedIndex;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages.addAll([
      MyHomePage(onItemTapped: _onItemTapped, currentIndex: 0),
      ExplorePage(onItemTapped: _onItemTapped, currentIndex: 1),
      CommunityPage(onItemTapped: _onItemTapped, currentIndex: 2),
      FranchiseListingRequestPage(onItemTapped: _onItemTapped, currentIndex: 3),
      EventListingPage(onItemTapped: _onItemTapped, currentIndex: 4),
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

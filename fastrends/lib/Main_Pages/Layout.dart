import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fastrends/Authentication/loginpage.dart';
import 'package:fastrends/Other_Page/Profilepage.dart';

class MainLayout extends StatefulWidget {
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
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Future<String?>? _profileImageFuture;

  @override
  void initState() {
    super.initState();
    _profileImageFuture = _getProfileImage();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Sign out error: $e');
      // Optionally show an error snackbar or dialog
    }
  }

  Future<String?> _getProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("USER ID is " + user.uid); // Debugging the user ID
      final doc = await FirebaseFirestore.instance
          .collection('Entrepreneurs')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        print("URL: " + (doc.data()?['profile_image'] ?? ''));
        return doc.data()?['profile_image'];
      }
    }
    return null;
  }

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
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white, // Set title color to white
          ),
        ),
        actions: [
          FutureBuilder<String?>(
            future: _profileImageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // or a placeholder
              } else if (snapshot.hasError) {
                return Icon(Icons.error); // or handle error accordingly
              } else {
                final profileImage = snapshot.data ??
                    'https://via.placeholder.com/150'; // Default image if null
                return GestureDetector(
                  onTap: () {
                    // Navigate to the ProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(profileImage),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: widget.body,
      bottomNavigationBar: AppBottomNavigationBar(
        onItemTapped: widget.onItemTapped,
        currentIndex: widget.currentIndex,
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
          icon: Icon(Icons.event),
          label: 'Events',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onItemTapped,
    );
  }
}

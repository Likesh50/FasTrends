import 'package:fastrends/Authentication/loginpage.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            // User is authenticated
            return _checkUserRole(snapshot.data!, context);
          } else {
            // User is not authenticated, navigate to login page
            return LoginPage();
          }
        },
      ),
    );
  }

  Widget _checkUserRole(User user, BuildContext context) {
    // Stream to check user role in Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entrepreneurs') // Ensure this collection is correct
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          // Assume 'role' field exists and contains the role of the user
          final userRole = userData['role'] ?? 'unknown';
          if (userRole == 'entrepreneur') {
            return MainApp(
                role:
                    'Entrepreneurs'); // Replace with Entrepreneur's home page if different
          } else {
            // Handle other roles or default case
            return MainApp(
                role: 'Investors'); // Replace with the appropriate page
          }
        } else {
          // User data does not exist in Firestore, handle accordingly
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('User role not found.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Log out the user and navigate to login page
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

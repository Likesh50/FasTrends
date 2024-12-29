import 'package:fastrends/Authentication/loginpage.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/config.dart';

//language option one page in this page
class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Local variable langoption initialized to 'ta'
    final String langoption = 'ta';

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
            return _checkUserRole(snapshot.data!, context, langoption);
          } else {
            // User is not authenticated, navigate to login page
            return LoginPage();
          }
        },
      ),
    );
  }

  Widget _checkUserRole(User user, BuildContext context, String langoption) {
    // Stream to check user role in Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entrepreneurs')
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
            // Navigate to the Entrepreneur's home page
            return MainApp(); // Replace with Entrepreneur's home page if different
          } else {
            // Handle other roles or default case
            return MainApp(); // Replace with the appropriate page
          }
        } else {
          // User data does not exist in Firestore, handle accordingly
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Config.userRoleNotFound[langoption]!),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Log out the user and navigate to login page
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(Config.LogOut[langoption]!),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _businessIdeaController = TextEditingController();
  TextEditingController _businessTypeController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  String _selectedLanguage = 'English'; // Default value
  String? _profileImage;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Entrepreneurs')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _phoneController.text = data['phone'];
          _businessIdeaController.text = data['business_idea'];
          _businessTypeController.text = data['business_type'];
          _roleController.text = data['role'];
          _websiteController.text = data['website'];
          _profileImage = data['profile_image'];
          _selectedLanguage = data['language_preference'] ?? 'English';
        });
      }
    }
  }

  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Entrepreneurs')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'business_idea': _businessIdeaController.text,
          'business_type': _businessTypeController.text,
          'role': _roleController.text,
          'website': _websiteController.text,
          'profile_image': _profileImage,
          'language_preference': _selectedLanguage,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Add functionality to change the profile image
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _profileImage != null
                      ? NetworkImage(_profileImage!)
                      : AssetImage('assets/placeholder.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _businessIdeaController,
                decoration: InputDecoration(labelText: 'Business Idea'),
              ),
              TextFormField(
                controller: _businessTypeController,
                decoration: InputDecoration(labelText: 'Business Type'),
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(labelText: 'Language Preference'),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a language preference';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProfileData,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

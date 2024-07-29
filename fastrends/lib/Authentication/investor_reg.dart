import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InvestorRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investor Registration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: InvestorRegistrationContent(),
    );
  }
}

class InvestorRegistrationContent extends StatefulWidget {
  @override
  _InvestorRegistrationContentState createState() =>
      _InvestorRegistrationContentState();
}

class _InvestorRegistrationContentState
    extends State<InvestorRegistrationContent> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _interestsController = TextEditingController();
  final _investmentTypeController = TextEditingController();
  final _websiteController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? imageUrl;
          if (_image != null) {
            final storageRef = FirebaseStorage.instance.ref().child(
                'investor_images/${user.uid}/${DateTime.now().toIso8601String()}');
            await storageRef.putFile(_image!);
            imageUrl = await storageRef.getDownloadURL();
          }

          // Print form data to verify
          print('Name: ${_nameController.text}');
          print('Email: ${_emailController.text}');
          print('Phone: ${_phoneController.text}');
          print('Interests: ${_interestsController.text}');
          print('Investment Type: ${_investmentTypeController.text}');
          print('Website: ${_websiteController.text}');
          print('Profile Image: $imageUrl');

          await FirebaseFirestore.instance
              .collection('Investors')
              .doc(user.uid)
              .set({
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'interests': _interestsController.text,
            'investment_type': _investmentTypeController.text,
            'website': _websiteController.text,
            'profile_image': imageUrl,
            'role': 'investor' // Fixed role name
          });

          // Clear the form fields
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _interestsController.clear();
          _investmentTypeController.clear();
          _websiteController.clear();
          _image = null;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainApp()),
          );
        }
      } catch (e) {
        print('Error registering investor: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Register as an Investor',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Full Name', 'Enter your full name',
                controller: _nameController),
            _buildTextField('Email', 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController),
            _buildTextField('Phone Number', 'Enter your phone number',
                keyboardType: TextInputType.phone,
                controller: _phoneController),
            _buildTextField(
                'Investment Interests', 'Describe your investment interests',
                maxLines: 3, controller: _interestsController),
            _buildTextField('Preferred Investment Type',
                'Enter preferred investment type (e.g., Equity, Debt)',
                controller: _investmentTypeController),
            _buildTextField('Website (if any)', 'Enter your website',
                keyboardType: TextInputType.url,
                controller: _websiteController),
            SizedBox(height: 16.0),
            _image == null
                ? TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Upload Profile Picture'),
                  )
                : Column(
                    children: [
                      Image.file(_image!),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image),
                        label: Text('Change Image'),
                      ),
                    ],
                  ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color.fromARGB(122, 0, 0, 0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color.fromARGB(122, 0, 0, 0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(12.0),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}

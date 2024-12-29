import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fastrends/config.dart';

class EntrepreneurRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String languageoption = 'ta'; //language option 2 places in this page
    return Scaffold(
      appBar: AppBar(
        title: Text(Config.EntrepreneurRegistration[languageoption]!),
        backgroundColor: Colors.blueAccent,
      ),
      body: EntrepreneurRegistrationContent(),
    );
  }
}

class EntrepreneurRegistrationContent extends StatefulWidget {
  @override
  _EntrepreneurRegistrationContentState createState() =>
      _EntrepreneurRegistrationContentState();
}

class _EntrepreneurRegistrationContentState
    extends State<EntrepreneurRegistrationContent> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessIdeaController = TextEditingController();
  final _businessTypeController = TextEditingController();
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
    print("IN THE FORM");
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String? imageUrl;
          if (_image != null) {
            final storageRef = FirebaseStorage.instance.ref().child(
                'entrepreneur_images/${user.uid}/${DateTime.now().toIso8601String()}');
            await storageRef.putFile(_image!);
            imageUrl = await storageRef.getDownloadURL();
          }
          print("Image uploaded");

          // Debug print statements to check values
          print("Name: ${_nameController.text}");
          print("Email: ${_emailController.text}");
          print("Phone: ${_phoneController.text}");
          print("Business Idea: ${_businessIdeaController.text}");
          print("Business Type: ${_businessTypeController.text}");
          print("Website: ${_websiteController.text}");
          print("Profile Image URL: $imageUrl");

          // Save form data to Firestore
          await FirebaseFirestore.instance
              .collection('Entrepreneurs')
              .doc(user.uid)
              .set({
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'business_idea': _businessIdeaController.text,
            'business_type': _businessTypeController.text,
            'website': _websiteController.text,
            'profile_image': imageUrl,
            "role": "entrepreneur"
          });

          // Clear the form fields
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _businessIdeaController.clear();
          _businessTypeController.clear();
          _websiteController.clear();
          _image = null;

          // Navigate to the main page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainApp()),
          );
        }
      } catch (e) {
        print('Error registering entrepreneur: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String langOption = 'ta';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Config.RegisterAsAnEntrepreneur[langOption]!,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField(Config.fullname[langOption]!,
                Config.enteryourfullname[langOption]!,
                controller: _nameController),
            _buildTextField(
                Config.email[langOption]!, Config.enteryouremail[langOption]!,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController),
            _buildTextField(Config.phoneNumber[langOption]!,
                Config.enteryourphonenumber[langOption]!,
                keyboardType: TextInputType.phone,
                controller: _phoneController),
            _buildTextField(Config.BusinessIdea[langOption]!,
                Config.enteryourbusinessidea[langOption]!,
                maxLines: 3, controller: _businessIdeaController),
            _buildTextField(Config.businessType[langOption]!,
                Config.enterBusinessType[langOption]!,
                controller: _businessTypeController),
            _buildTextField(Config.website[langOption]!,
                Config.enterYourBusinessWebsite[langOption]!,
                keyboardType: TextInputType.url,
                controller: _websiteController),
            SizedBox(height: 16.0),
            _image == null
                ? TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text(Config.uploadProfilePicture[langOption]!),
                  )
                : Column(
                    children: [
                      Image.file(_image!),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image),
                        label: Text(Config.changeImage[langOption]!),
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
                  Config.submit[langOption]!,
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

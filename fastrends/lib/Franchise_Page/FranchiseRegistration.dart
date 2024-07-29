import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fastrends/Main_Pages/Layout.dart';

class FranchiseRegistrationPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  FranchiseRegistrationPage({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: FranchiseRegistrationContent(),
      title: 'Franchise Registration',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

class FranchiseRegistrationContent extends StatefulWidget {
  @override
  _FranchiseRegistrationContentState createState() =>
      _FranchiseRegistrationContentState();
}

class _FranchiseRegistrationContentState
    extends State<FranchiseRegistrationContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _investmentRangeController = TextEditingController();
  final _franchiseFeeController = TextEditingController();
  final _businessCategoryController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();
  File? _logo;
  List<File> _companyPhotos = [];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Upload logo
          String? logoUrl;
          if (_logo != null) {
            logoUrl = await _uploadFile(_logo!, 'logos');
          }

          // Upload company photos
          List<String> companyPhotosUrls = [];
          for (var photo in _companyPhotos) {
            final photoUrl = await _uploadFile(photo, 'company_photos');
            companyPhotosUrls.add(photoUrl);
          }

          await FirebaseFirestore.instance.collection('Franchises').add({
            'franchise_name': _nameController.text,
            'description': _descriptionController.text,
            'contact_person': _contactPersonController.text,
            'phone': _phoneController.text,
            'email': _emailController.text,
            'address': _addressController.text,
            'investment_range': _investmentRangeController.text,
            'franchise_fee': _franchiseFeeController.text,
            'business_category': _businessCategoryController.text,
            'website': _websiteController.text,
            'location': _locationController.text,
            'logo': logoUrl,
            'company_photos': companyPhotosUrls,
            'user_id': user.uid, // Save user ID if needed
          });

          // Clear the form fields
          _nameController.clear();
          _descriptionController.clear();
          _contactPersonController.clear();
          _phoneController.clear();
          _emailController.clear();
          _addressController.clear();
          _investmentRangeController.clear();
          _franchiseFeeController.clear();
          _businessCategoryController.clear();
          _websiteController.clear();
          _locationController.clear();
          setState(() {
            _logo = null;
            _companyPhotos.clear();
          });

          // Show success message and/or navigate to another page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Franchise registered successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainApp(
                      initialIndex: 3,
                    )),
          );
        }
      } catch (e) {
        print('Error registering franchise: $e');
      }
    }
  }

  Future<String> _uploadFile(File file, String path) async {
    final storageRef = FirebaseStorage.instance.ref().child(path).child(
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCompanyPhotos() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _companyPhotos.addAll(pickedFiles.map((file) => File(file.path)));
      });
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
              'Register Your Franchise',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Franchise Name', 'Enter franchise name',
                controller: _nameController),
            _buildTextField('Description', 'Enter a brief description',
                maxLines: 3, controller: _descriptionController),
            _buildTextField('Contact Person', 'Enter contact person name',
                controller: _contactPersonController),
            _buildTextField('Phone Number', 'Enter contact phone number',
                keyboardType: TextInputType.phone,
                controller: _phoneController),
            _buildTextField('Email', 'Enter contact email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController),
            _buildTextField('Address', 'Enter franchise address',
                maxLines: 2, controller: _addressController),
            _buildTextField('Investment Range', 'Enter investment range',
                controller: _investmentRangeController),
            _buildTextField('Franchise Fee', 'Enter franchise fee',
                controller: _franchiseFeeController),
            _buildTextField('Business Category', 'Enter business category',
                controller: _businessCategoryController),
            _buildTextField('Website', 'Enter website',
                keyboardType: TextInputType.url,
                controller: _websiteController),
            _buildTextField('Location', 'Enter location',
                controller: _locationController),
            SizedBox(height: 16.0),
            Text(
              'Logo',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _logo == null
                ? TextButton.icon(
                    onPressed: _pickLogo,
                    icon: Icon(Icons.image),
                    label: Text('Select Logo'),
                  )
                : Image.file(_logo!, height: 100, width: 100),
            SizedBox(height: 16.0),
            Text(
              'Company Photos',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _companyPhotos.isEmpty
                ? TextButton.icon(
                    onPressed: _pickCompanyPhotos,
                    icon: Icon(Icons.add_a_photo),
                    label: Text('Select Photos'),
                  )
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _companyPhotos
                        .map((photo) =>
                            Image.file(photo, height: 100, width: 100))
                        .toList(),
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
          hintStyle: TextStyle(
            color: Colors.white,
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

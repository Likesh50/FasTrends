import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fastrends/config.dart';
//one language option

class EventRegistrationPage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  EventRegistrationPage({
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Event Registration',
      currentIndex: currentIndex,
      onItemTapped: onItemTapped,
      body: EventRegistrationContent(),
    );
  }
}

class EventRegistrationContent extends StatefulWidget {
  @override
  _EventRegistrationContentState createState() =>
      _EventRegistrationContentState();
}

class _EventRegistrationContentState extends State<EventRegistrationContent> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _eventTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _eventTypeController = TextEditingController();
  final _eventLinkController = TextEditingController();
  final _startDateTimeController = TextEditingController();
  final _endDateTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _speakerController = TextEditingController();
  final _organisationController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _selectDateAndTime(TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (selectedTime != null) {
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          controller.text = dateTime.toLocal().toString();
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      final eventData = {
        'title': _eventTitleController.text,
        'description': _descriptionController.text,
        'event_type': _eventTypeController.text,
        'event_link': _eventLinkController.text,
        'start_date_time': _startDateTimeController.text,
        'end_date_time': _endDateTimeController.text,
        'location': _locationController.text,
        'speaker': _speakerController.text,
        'organisation': _organisationController.text,
        'image_url': imageUrl ?? '',
      };

      try {
        await FirebaseFirestore.instance.collection('events').add(eventData);
        final String languageoption = 'ta';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Event Registered Successfully")));
        _formKey.currentState?.reset();
        setState(() {
          _image = null;
        });
      } catch (e) {
        print('Error storing event data: $e');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainApp(
            initialIndex: 4,
          ),
        ),
      );
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
              'Register Your Event',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Event Title', 'Enter event title',
                controller: _eventTitleController),
            _buildTextField('Description', 'Enter a brief description',
                controller: _descriptionController, maxLines: 3),
            _buildTextField('Event Type', 'Enter event type (Free/Paid)',
                controller: _eventTypeController),
            _buildTextField('Event Link', 'Enter event link',
                controller: _eventLinkController,
                keyboardType: TextInputType.url),
            GestureDetector(
              onTap: () => _selectDateAndTime(_startDateTimeController),
              child: AbsorbPointer(
                child: _buildTextField(
                    'Start Date and Time', 'Select start date and time',
                    controller: _startDateTimeController),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectDateAndTime(_endDateTimeController),
              child: AbsorbPointer(
                child: _buildTextField(
                    'End Date and Time', 'Select end date and time',
                    controller: _endDateTimeController),
              ),
            ),
            _buildTextField('Location', 'Enter event location',
                controller: _locationController),
            _buildTextField('Speaker', 'Enter speaker name',
                controller: _speakerController),
            _buildTextField('Organisation', 'Enter organisation name',
                controller: _organisationController),
            SizedBox(height: 16.0),
            _image == null
                ? TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Upload Event Image'),
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

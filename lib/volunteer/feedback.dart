import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  final String name;
  final String profileImageUrl;

  const FeedbackPage({
    Key? key,
    required this.name,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _selectedStars = 0;
  File? _image;

  void _selectStars(double stars) {
    setState(() {
      _selectedStars = stars;
    });
  }

  Future<void> _submitFeedback() async {
    // Check if user is authenticated
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Implement feedback submission logic here
      print('Submitted $_selectedStars stars!');

      // Upload image to Firebase Storage
      if (_image != null) {
        final storage = FirebaseStorage.instance;
        final imageRef = storage.ref().child('images/${user.uid}.jpg');
        await imageRef.putFile(_image!);
        final imageUrl = await imageRef.getDownloadURL();

        // Store feedback data in Firestore under the authenticated user
        final firestore = FirebaseFirestore.instance;
        final userRef = firestore.collection('users').doc(user.uid);
        await userRef.set({
          'feedbackImage': imageUrl,
          'stars': _selectedStars,
        }, SetOptions(merge: true)); // Merge with existing data if any
      }

      // Pop the page after submitting feedback
      Navigator.pop(context);
    } else {
      // User is not authenticated, handle accordingly
      print('User is not authenticated.');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    // Use the image_picker plugin to pick an image from the specified source
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path); // Set the picked image to _image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name, style: TextStyle(fontSize: 25),),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                boxShadow: _image == null
                    ? [
                        BoxShadow(
                          color: Color.fromARGB(147, 216, 214, 214).withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              // Placeholder for the image
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () => _getImage(ImageSource.camera), // Capture photo from camera
                      child: Text('Capture Now'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            RatingBar.builder(
              initialRating: _selectedStars,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: _selectStars,
              glow: true,
              glowRadius: 10,
              glowColor: Colors.amber.withOpacity(0.5),
              itemSize: 50,
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), // Add margin to the submit button
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

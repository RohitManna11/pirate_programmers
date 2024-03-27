import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerInfo extends StatefulWidget {
  final String name;
  final int notificationCount;

  const VolunteerInfo({
    Key? key,
    required this.name,
    required this.notificationCount,
  }) : super(key: key);

  @override
  _VolunteerInfoState createState() => _VolunteerInfoState();
}

class _VolunteerInfoState extends State<VolunteerInfo> {
  int _isApproved = 0;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? ''; // Get the current user's ID

    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('users').where('name', isEqualTo: widget.name).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Volunteer data not found');
        }

        final volunteerData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final profileImageUrl = volunteerData['profileImage'] ?? '';
        final score = volunteerData['score'] ?? '';
        final demand = volunteerData['demand'] ?? '';
        final feedbackImageUrl = volunteerData['feedbackImage'] ?? ''; // Fetch feedback image URL

        return Scaffold(
          appBar: AppBar(
            title: Text('Volunteer Info'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            volunteerData['phone'] ?? '', // Fetch volunteer's phone number
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Score:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Text(
                        score.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Requirement:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Text(
                        demand.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
<<<<<<< HEAD
                        onPressed: () async {
                          // Get the ID of the volunteer
                          String volunteerId = snapshot.data!.docs.first.id;

                          // Subtract demand from counter and update the value in Firestore
                          await _firestore.runTransaction((transaction) async {
                            DocumentSnapshot snapshot = await transaction.get(_firestore.collection('users').doc(currentUserId));
                            int counter = snapshot['counter'] ?? 0;
                            transaction.update(_firestore.collection('users').doc(currentUserId), {'counter': counter - demand});
                          });

                          // Update 'approved' field to 1 in the database
                          _firestore.collection('users').doc(currentUserId).update({'approved': 1});

                          // Update demand field to 0 in the volunteer's data
                          _firestore.collection('users').doc(volunteerId).update({'demand': 0});

                          // Update the UI state
                          setState(() {
                            _isApproved = 1;
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(50), // Adjust the button height
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _firestore.collection('users').doc(currentUserId).update({'approved': -1});
                          setState(() {
                            _isApproved = -1;
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(50), // Adjust the button height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200, // Adjust height as needed
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: feedbackImageUrl.isNotEmpty
                        ? Image.network(
                            feedbackImageUrl,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text('No feedback image'),
                          ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
  onPressed: () async {
    // Calculate new score
    double newScore = volunteerData['score'] + 2 * volunteerData['demand'];

    // Get the ID of the volunteer
    String volunteerId = snapshot.data!.docs.first.id;

    // Update the score field in volunteer's data
    await _firestore.collection('users').doc(volunteerId).update({'score': newScore});

    // Update the UI state
=======
  onPressed: () {
    FirebaseFirestore.instance.collection('users').where('name', isEqualTo: widget.name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'approved': 1}); // Update 'approved' field to 1 for approval xD
      });
    });
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
    setState(() {
      // Update the local volunteerData to reflect the updated score
      volunteerData['score'] = newScore;
      Navigator.pop(context);
    });
  },
  child: Text('Authorize'),
  style: ElevatedButton.styleFrom(
    fixedSize: Size.fromHeight(50), // Adjust the button height
  ),
),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

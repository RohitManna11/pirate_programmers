import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirateprogrammers/Bank/volunteer_info.dart';
import 'package:pirateprogrammers/login_page.dart';
import 'package:pirateprogrammers/volunteer/bank_info.dart';

<<<<<<< HEAD
import 'feedback.dart';



=======
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
<<<<<<< HEAD
  String pincode = '';
    @override
  void initState() {
    super.initState();
    _fetchPincode();
=======
  int _demand = 0;
  String pincode = '';

  @override
  void initState() {
    super.initState();
    _fetchPincode();
  }

  void _fetchPincode() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final userData =
          await _firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          pincode = userData['pincode'].toString();
        });
      }
    } catch (e) {
      print('Error fetching pincode: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      _demand++;
    });
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
  }

  void _fetchPincode() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final userData =
          await _firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          pincode = userData['pincode'].toString();
        });
      }
    } catch (e) {
      print('Error fetching pincode: $e');
    }
  }
  // int _demand = 1;

  // void _incrementCounter() {
  //   setState(() {
  //     _demand++;
  //   });
  // }

  // void _decrementCounter() {
  //   setState(() {
  //     if (_demand > 0) {
  //       _demand--;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
<<<<<<< HEAD
             Icon(Icons.location_on), // Location icon
=======
            Icon(Icons.location_on), // Location icon
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
            SizedBox(width: 8),
            Expanded(
              child: Text(
                pincode.isNotEmpty
                    ? pincode
                    : pincode, // Display pincode dynamically
                textAlign: TextAlign.left,
              ),
            ),
<<<<<<< HEAD
             StreamBuilder<DocumentSnapshot>(
=======
            StreamBuilder<DocumentSnapshot>(
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
<<<<<<< HEAD
                  builder: (context, snapshot) {  
                    if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final score = snapshot.data?['score'] ?? 0; 
                  return Text('$score'); 
                  }
                  },
             )
=======
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final score = snapshot.data?['score'] ?? 0;
                  return Text('$score');
                }
              },
            ),
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_selectedIndex == 0) // Render only if "Home" tab is selected
            _buildPageView(),
          if (_selectedIndex == 1) // Render only if "Search" tab is selected
            _buildSearchOverlay(),
          if (_selectedIndex == 2) // Render only if "Settings" tab is selected
            _buildProfileOverlay(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}


  Widget _buildPageView() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return FutureBuilder<DocumentSnapshot>(
    future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          // If user document does not exist, display a message
          return Center(child: Text('User data not found'));
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final userPincode = userData['pincode'];

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where('role', isEqualTo: 'Foodbank')
              .where('pincode', isEqualTo: userPincode) // Filter food banks based on pincode
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // If no food banks found with matching pincode, display a message
                return Center(child: Text('No Foodbank found with matching pincode'));
              }
              final bankData = snapshot.data!.docs;

              return ListView.builder(
  itemCount: bankData.length,
  itemBuilder: (context, index) {
    final name = bankData[index]['name'];
    final profileImageUrl = bankData[index]['profileImage'];
    final counter = bankData[index]['counter'];
    final approved = bankData[index]['approved'];

    return GestureDetector(
      onTap: () {
        _navigateToBankInfo(context, name, counter);
      },
      child: NameItem(
        name: name,
        counter: counter,
        profileImageUrl: profileImageUrl,
        approved: approved,
        applyBorder: false, // Set applyBorder to false
      ),
    );
  },
);


            }
          },
        );
      }
    },
  );
}


  void _navigateToBankInfo(
      BuildContext context, String name, int notificationCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BankInfo(name: name, notificationCount: notificationCount)),
    );
  }

  Widget _buildSearchOverlay() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return StreamBuilder<DocumentSnapshot>(
    stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          // If user document does not exist, display a message
          return Center(child: Text('User data not found'));
        }
        final volunteerData = snapshot.data!.data() as Map<String, dynamic>;
        final bankNames = volunteerData['banks'] ?? []; // Get list of bank names from volunteer data

        if (bankNames.isEmpty) {
          return Center(child: Text('No food banks associated with this volunteer'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where('role', isEqualTo: 'Foodbank')
              .where('name', whereIn: bankNames) // Filter food banks based on volunteer's bank names
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // If no food banks found with matching names, display a message
                return Center(child: Text('No Foodbank found'));
              }
              final bankData = snapshot.data!.docs;

              return ListView.builder(
  itemCount: bankData.length,
  itemBuilder: (context, index) {
    final name = bankData[index]['name'];
    final profileImageUrl = bankData[index]['profileImage'];
    final counter = bankData[index]['counter'];
    final approved = bankData[index]['approved'];

    return GestureDetector(
      onTap: () {
        if (approved == 1) {
          _navigateToBankInfo(context, name, counter);
        }
      },
      child: NameItem(
        name: name,
        counter: counter,
        profileImageUrl: profileImageUrl,
        approved: approved,
        applyBorder: true,
      ),
    );
  },
);



            }
          },
        );
      }
    },
  );
}




  // void _navigateToBankInfo(
  //     BuildContext context, String name, int notificationCount) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             BankInfo(name: name, notificationCount: notificationCount)),
  //   );
  // }

  void _saveDemandToFirestore(String userId, int demandValue) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore.collection('users').doc(userId).update({
      'demand': demandValue,
    }).then((value) {
      // Successfully saved to Firestore
      print('Demand value saved to Firestore: $demandValue');
    }).catchError((error) {
      // Failed to save to Firestore
      print('Failed to save demand value: $error');
    });
  }

  Widget _buildProfileOverlay() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            // If no data or no user found, display an appropriate message
            return const Text('No profile data found');
          }
          final profileData = snapshot.data!.data() as Map<String, dynamic>;
          final name =
              profileData['name']; // Fetch the 'name' field from Firestore
          final email =
              profileData['email']; // Fetch the 'email' field from Firestore
          final profileImage = profileData[
              'profileImage']; // Fetch the 'profileImage' field from Firestore
          final role =
              profileData['role']; // Fetch the 'role' field from Firestore
          final address = profileData['address'];
          final phone = profileData['phone'];
           // This will display "20" instead of "10"

          

          return Column(
            children: [
              Container(
                height: 150,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.blue,
                    ], // Define your gradient colors here
                    stops: [0.0, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        "Hello $name",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Color for the name
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        40, // Adjust width as needed
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Role:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        40, // Adjust width as needed
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Change text color as needed
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          address, // Convert integer to string here
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Change text color as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        40, // Adjust width as needed
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        40, // Adjust width as needed
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Logout',
                      style: TextStyle(fontSize: 16, color: Colors.blue)),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }


class NameItem extends StatelessWidget {
  final String name;
  final int counter;
  final String profileImageUrl;
  final int approved;
  final bool applyBorder; // Add a boolean flag to determine whether to apply border

  const NameItem({
    required this.name,
    required this.counter,
    required this.profileImageUrl,
    required this.approved,
    required this.applyBorder, // Receive the boolean flag
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;

    if (approved == -1) {
      borderColor = Colors.red;
    } else if (approved == 0) {
      borderColor = Colors.transparent;
    } else if (approved == 1) {
      borderColor = Colors.green;
    } else {
      borderColor = Colors.transparent;
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        side: applyBorder ? BorderSide(color: borderColor, width: 2.0) : BorderSide.none, // Apply border conditionally
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Available ${counter.toString()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (approved == 1) // Conditionally render the button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackPage(
                        name: name,
                        profileImageUrl: profileImageUrl,
                      ),
                    ),
                  );
                },
                child: Text('Give Feedback'),
              )
            else
              SizedBox(width: 120), // Placeholder to maintain alignment when button is disabled
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirateprogrammers/login_page.dart';

import 'volunteer_info.dart';

class HomeBankScreen extends StatefulWidget {
  final User user; // Define the user variable

  const HomeBankScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeBankScreenState createState() => _HomeBankScreenState();
}

class _HomeBankScreenState extends State<HomeBankScreen> {
  int _selectedIndex = 0;
  int _counter = 0;
<<<<<<< HEAD
  int _entries = 0;
  String pincode = '';
  String request = '';
  String? _selectedCategory;
  String _amount = '';
=======
  String pincode = '';
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a

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
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
<<<<<<< HEAD
            const Icon(Icons.location_on), // Location icon
            const SizedBox(width: 8),
=======
            Icon(Icons.location_on), // Location icon
            SizedBox(width: 8),
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
            Expanded(
              child: Text(
                pincode.isNotEmpty
                    ? pincode
                    : pincode, // Display pincode dynamically
                textAlign: TextAlign.left,
              ),
            ),
<<<<<<< HEAD
            const Icon(
              Icons.shopping_bag,
              size: 24,
              color: Color(0xFFFF953A),
            ),
=======
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
<<<<<<< HEAD
                  return const CircularProgressIndicator();
=======
                  return CircularProgressIndicator();
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Handle case where document does not exist
<<<<<<< HEAD
                  return const Text('Document does not exist');
                } else {
                  final Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  final counterValue = data?['counter'] ?? 0;
                  if (!data!.containsKey('counter')) {
                    // If the field 'counter' does not exist, initialize it with 0
                    _saveCounterToFirestore(
                        widget.user.uid, 0); // Save 0 to Firestore
                  }
                  return Text('$counterValue');
                }
              },
            ),
          ],
        ),
      ),
=======
                  return Text('Document does not exist');
                } else {
                  final Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a

                  final counterValue = data?['counter'] ?? 0;
                  if (!data!.containsKey('counter')) {
                    // If the field 'counter' does not exist, initialize it with 0
                    _saveCounterToFirestore(
                        widget.user.uid, 0); // Save 0 to Firestore
                  }
                  return Text('$counterValue');
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_selectedIndex == 0) // Render only if "Home" tab is selected
            _buildhome(_entries),
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
            label: 'Update',
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

<<<<<<< HEAD
  Widget _buildhome(int counterValue) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF953A),
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 150,
        margin: const EdgeInsets.all(20), // Margin for the container
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width:
                  100, // Adjust the width to increase the size of the circle
              height:
                  100, // Adjust the height to increase the size of the circle
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Change color as needed
              ),
              child: Center(
                child: Text(
                  counterValue.toString(), // Use the provided counter value
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Adjust font size of the counter text
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Requests', // First dummy text
                  style: TextStyle(
                    color: Colors.white, // Change text color as needed
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Share.Connect.Feed', // Second dummy text
                  style: TextStyle(
                    color: Colors.white, // Change text color as needed
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: _buildPageView(), // Display volunteer data below the blue box
      ),
    ],
  );
}

  Widget _buildPageView() {
    
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return StreamBuilder<DocumentSnapshot>(
    stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          // If no data or no user found, display an appropriate message
          return Center(child: Text('No user data found'));
        }
        final foodBankData = snapshot.data!.data() as Map<String, dynamic>;
        final foodBankName = foodBankData['name']; // Get the name of the food bank

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .where('role', isEqualTo: 'Volunteer')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // If no volunteer data found, display a message
                return Center(child: Text('No volunteers found'));
              }
              // Extract volunteer data and filter based on the 'banks' array
              List<DocumentSnapshot> volunteerData = snapshot.data!.docs;
              volunteerData = volunteerData.where((volunteer) {
                final banks = volunteer['banks'] as List<dynamic>;
                return banks.contains(foodBankName);
              }).toList();

              // Further filter based on the demand and counter fields
              volunteerData = volunteerData.where((volunteer) {
                final demand = volunteer['demand'] as int;
                final counter = foodBankData['counter'] as int;
                return demand > 0 && demand <= counter;
              }).toList();

              return ListView.builder(
                itemCount: volunteerData.length,
                itemBuilder: (context, index) {
                  final name = volunteerData[index]['name'];
                  final profileImageUrl = volunteerData[index]['profileImage'];
                  final notificationCount = volunteerData[index]['demand'];
                  final score = volunteerData[index]['score'];
                  _entries++;

                  return GestureDetector(
                    onTap: () {
                      _navigateToVolunteerInfo(context, name, notificationCount);
                    },
                    child: NameItem(
                      name: name,
                      demand: notificationCount,
                      profileImageUrl: profileImageUrl,
                      score: score,
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




  void _navigateToVolunteerInfo(BuildContext context, String name, int notificationCount) {
=======
  Widget _buildPageView() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .where('role', isEqualTo: 'Volunteer')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // If no volunteer data found, display a message
            return Center(child: Text('No volunteers found'));
          }
          // Extract volunteer data and sort based on the 'score' field
          List<DocumentSnapshot> volunteerData = snapshot.data!.docs;
          volunteerData.sort((a, b) => b['score'].compareTo(a['score']));

          return ListView.builder(
            itemCount: volunteerData.length,
            itemBuilder: (context, index) {
              final name = volunteerData[index]['name'];
              final profileImageUrl = volunteerData[index]['profileImage'];
              final notificationCount = 10;

              return GestureDetector(
                onTap: () {
                  _navigateToVolunteerInfo(context, name, notificationCount);
                },
                child: NameItem(
                  name: name,
                  demand: notificationCount,
                  profileImageUrl: profileImageUrl,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _navigateToVolunteerInfo(
      BuildContext context, String name, int notificationCount) {
>>>>>>> aab46a07fbb0a4e0c219d0b7e0a56838aedced5a
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VolunteerInfo(
                name: name,
                notificationCount: notificationCount,
              )),
    );
  }

  Widget _buildSearchOverlay() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.all(20), // Margin for the container
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data Update',
                style: TextStyle(fontSize: 24),
              ),
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 24,
                    color: Colors.black,
                  ),
                  SizedBox(width: 4),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('approved_records')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        // Handle case where document does not exist
                        return Text('0'); // Assuming the initial count is 0
                      } else {
                        final Map<String, dynamic>? data =
                            snapshot.data!.data() as Map<String, dynamic>?;

                        final recordCount = data?['approved_records'] ?? 0;
                        return Text('$recordCount');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: Icon(Icons.remove),
              ),
              SizedBox(width: 20),
              Text(
                '$_counter',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save counter value to Firestore
              _saveCounterToFirestore(user!.uid, _counter);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveCounterToFirestore(String userId, int counterValue) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore.collection('users').doc(userId).update({
      'counter': counterValue,
    }).then((value) {
      // Successfully saved to Firestore
      print('Counter value saved to Firestore: $counterValue');
    }).catchError((error) {
      // Failed to save to Firestore
      print('Failed to save counter value: $error');
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
                      Color(0xFFFF943A),
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
                      style: TextStyle(fontSize: 16, color: Color(0xFFFF953A))),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}

class NameItem extends StatelessWidget {
  final String name;
  final int demand;
  final String profileImageUrl; // Add profile image URL
  final int score;

  const NameItem({
    required this.name,
    required this.demand,
    required this.profileImageUrl, // Receive profile image URL 
    required this.score, // Receive score
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    double borderWidth = 1.0; // Initial border width

    // Check the score and set border color accordingly
    if (score > 200) {
      borderColor = Colors.amber;
      borderWidth = 3.0; // Increase border width for higher visibility
    } else if (score > 100) {
      borderColor = Colors.grey;
      borderWidth = 3.0; // Increase border width for higher visibility
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: borderWidth), // Set border color and width
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(profileImageUrl), // Use profile image URL
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
                  Row(
                    children: [
                      Text(
                        'Available:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(width: 5),
                      Text(
                        demand.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

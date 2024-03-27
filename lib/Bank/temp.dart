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
  int _entries = 0;
  String pincode = '';
  String request = '';
  String? _selectedCategory;
  String _amount = '';

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
            const Icon(Icons.location_on), // Location icon
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pincode.isNotEmpty
                    ? pincode
                    : pincode, // Display pincode dynamically
                textAlign: TextAlign.left,
              ),
            ),
            const Icon(
              Icons.shopping_bag,
              size: 24,
              color: Color(0xFFFF953A),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Handle case where document does not exist
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
      body: Stack(
        children: [
          if (_selectedIndex == 1) // Render only if "Home" tab is selected
            _buildUpdatePage(),
          if (_selectedIndex == 0) // Render only if "Search" tab is selected
            _buildhome(_entries),
          if (_selectedIndex == 2) // Render only if "Settings" tab is selected
            _buildProfileOverlay(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Update',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(
            0xFFFF953A), // Change this to set the color of the selected item icon
        unselectedItemColor: Colors
            .grey, // Change this to set the color of unselected item icons
        selectedLabelStyle: const TextStyle(
            color:
                Colors.blue), // Change this to set the color of selected label
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildUpdatePage() {
    final TextEditingController _amountController = TextEditingController();

    // Method to save the amount to the database
    void _saveAmount(String amount) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final User? user = FirebaseAuth.instance.currentUser;

      _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'counter': amount})
          .then((_) => print('Amount updated successfully'))
          .catchError((error) => print('Error updating amount: $error'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Information',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Category',
            style: TextStyle(fontSize: 18.0),
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            hint: Text('Select category'),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            items: ['Veg', 'Non-Veg']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          SizedBox(height: 20.0),
          Text(
            'Amount of Food Available',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20.0),
          Text(
            'Working Hours',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
              // Add your text form field for working hours
              ),
          SizedBox(height: 20.0),
          Text(
            'Address',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
              // Add your text form field for address
              ),
          SizedBox(height: 20.0),
          Text(
            'Pincode',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
              // Add your text form field for pincode
              ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Save the amount to the database when the button is pressed
              _saveAmount(_amountController.text);
            },
            child: Text(
              'Update Information',
              style: TextStyle(color: Color(0xFFFF953A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 10), // Add horizontal margin
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('role', isEqualTo: 'Volunteer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // If no volunteer data found, display a message
              return const Center(child: Text('No volunteers found'));
            }
            // Extract volunteer data and sort based on the 'score' field
            List<DocumentSnapshot> volunteerData = snapshot.data!.docs;
            volunteerData.sort((a, b) {
              // First, compare scores
              int scoreComparison = b['score'].compareTo(a['score']);
              if (scoreComparison != 0) {
                // If scores are not equal, return the comparison result
                return scoreComparison;
              } else {
                // If scores are equal, compare demands
                return b['demand'].compareTo(a['demand']);
              }
            });

            int numberOfVolunteers = volunteerData.length;

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
                    score:score,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToVolunteerInfo(
      BuildContext context, String name, int notificationCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VolunteerInfo(
                name: name,
                notificationCount: notificationCount,
              )),
    );
  }

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
  final int score; // Add score

  const NameItem({
    required this.name,
    required this.demand,
    required this.profileImageUrl,
    required this.score, // Receive score
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    double borderWidth = 1.0; // Initial border width

    // Set border color and width based on score
    if (score >= 200) {
      borderColor = Colors.amber; // Set border color to amber
      borderWidth = 3.0; // Increase border width
    }
    if (score >= 100 && score < 200) {
      borderColor = Colors.grey; // Set border color to amber
      borderWidth = 3.0; // Increase border width
    }


    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: borderColor, // Set border color here
          width: borderWidth, // Set border width here
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(profileImageUrl), // Use profile image URL
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Requested:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        demand.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
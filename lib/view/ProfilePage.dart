import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OrdersPage.dart';
import 'ServicesPage.dart';
import 'TrackOrdersPage.dart';
import 'home_page.dart';
import 'ChangePasswordPage.dart';
import 'AboutUsPage.dart';
import 'TermsAndConditionsPage.dart';
import 'FeedbackPage.dart';
import 'EditProfilePage.dart'; 
import 'package:knc/main.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
// import 'HelpCenterPage.dart'; // Import HelpCenterPage

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profileData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final response = await http.get(Uri.parse(
        'https://kncprintz.com/knc/login/get_profile.php?id=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error, e.g., show an error message
      print('Error fetching profile data: ${response.statusCode}');
    }
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Function to clear saved credentials
  Future<void> _clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('rememberMe');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button press
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(), // Remove the leading widget (back button)
          title: Text('Profile'),
          backgroundColor: Colors.blue, // Set app bar color
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile Section
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 80, // Adjust size as needed
                              backgroundImage: NetworkImage(
                                '${profileData['profile_upload_url']}',
                              ),
                            ),
                            SizedBox(height: 8), // Reduced spacing between profile pic and name
                            Text(
                              '${profileData['first_name']} ${profileData['last_name']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Reduced spacing between name and email
                            Text(
                              '${profileData['email']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Profile Information Section
                      Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Name'),
                        trailing: Text(
                            '${profileData['first_name']}'),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        trailing: Text('${profileData['email']}'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                        trailing: Text('${profileData['phone']}'),
                      ),
                      SizedBox(height: 24),

                      // Actions Section
                      Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Use Card for a more visually appealing button layout
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.edit), // Add the edit icon
                          title: Text('Edit Profile'),
                          onTap: () {
                            // Navigate to Edit Profile Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(userId: widget.userId)),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.key),
                          title: Text('Change Password'),
                          onTap: () {
                            // Navigate to Change Password Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangePasswordPage(userId: widget.userId)),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About Us'),
                          onTap: () {
                            // Navigate to About Us Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AboutUsPage()),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.description),
                          title: Text('Terms and Conditions'),
                          onTap: () {
                            // Navigate to Terms and Conditions Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TermsAndConditionsPage()),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                     SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.feedback),
                          title: Text('Feedback'),
                          onTap: () {
                            // Navigate to Feedback Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackPage(userId: widget.userId),
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(height: 16),
                      // Card(
                      //   child: ListTile(
                      //     leading: Icon(Icons.help_outline),
                      //     title: Text('Help Center'),
                      //     onTap: () {
                      //       // Navigate to Help Center Page
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => HelpCenterPage(userId: widget.userId),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Show logout confirmation dialog
                          bool shouldLogout = await _showLogoutConfirmation();
                          if (shouldLogout) {
                            // Handle Logout Action
                            // Implement logout logic here
                            _clearSavedCredentials(); // Clear saved credentials
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LandingPage(), 
                              ),
                            );
                          }
                        },
                       icon: Icon(Icons.logout), // Add logout icon
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colors.black), // Set logout text color
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(190, 255, 255, 255), // Set logout button color
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(userId: widget.userId)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list_alt, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersPage(userId: widget.userId)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.local_offer, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServicesPage(userId: widget.userId)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.track_changes, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TrackOrdersPage(userId: widget.userId)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(userId: widget.userId)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
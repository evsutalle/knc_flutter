import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'OrdersPage.dart';
import 'ServicesPage.dart';
import 'TrackOrdersPage.dart';
import 'ProfilePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  final LatLng _location = LatLng(11.006713, 124.606866); // Dona Feliza Mejia coordinates
  final double _zoom = 13.0;
  String? _nickname;
  List<dynamic> _topServices = [];
  List<dynamic> _servicesOffered = []; // New list for all services

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  // Fetches nickname and sets greeting
  Future<void> _initializeUserDetails() async {
    await _getNickname();
    await _getTopServices(); // Fetch top services
    await _getServicesOffered(); // Fetch all services offered
  }

  // Fetch nickname from API
  Future<void> _getNickname() async {
    try {
      final response = await http.get(
        Uri.parse('https://kncprintz.com/knc/login/data.php?id=${widget.userId}')
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nickname = data["username"] ?? 'Error fetching username';
        });
      } else {
        setState(() {
          _nickname = 'Error fetching nickname';
        });
      }
    } catch (e) {
      setState(() {
        _nickname = 'Error fetching nickname';
      });
    }
  }

  // Fetch top services from API
  Future<void> _getTopServices() async {
    try {
      final response = await http.get(
        Uri.parse('https://kncprintz.com/knc/login/top_services.php')
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _topServices = data; // Now includes the image URLs
        });
      } else {
        setState(() {
          _topServices = []; // Set to empty if there's an error
        });
      }
    } catch (e) {
      setState(() {
        _topServices = []; // Set to empty if there's an error
      });
    }
  }

  // Fetch all services offered from API
  Future<void> _getServicesOffered() async {
    try {
      final response = await http.get(
        Uri.parse('https://kncprintz.com/knc/login/services_offered.php')
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _servicesOffered = data; // Fetch services
        });
      } else {
        setState(() {
          _servicesOffered = []; // Set to empty if there's an error
        });
      }
    } catch (e) {
      setState(() {
        _servicesOffered = []; // Set to empty if there's an error
      });
    }
  }

  // Navigation handler
  void _onIconTapped(int index) {
    final pages = [
      HomePage(userId: widget.userId),
      OrdersPage(userId: widget.userId),
      ServicesPage(userId: widget.userId),
      TrackOrdersPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
    ];
    Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
  }

  // Open Facebook page
  void _openFacebook() async {
    const url = 'https://www.facebook.com/share/8AkoFwHj5NWPgi6N/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to handle back button press
  Future<bool> _onWillPop() async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Exit', style: TextStyle(color: Colors.black)), // Set title text color to black
        content: Text('Are you sure you want to exit the app?', style: TextStyle(color: Colors.black)), // Set content text color to black
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.black)), // Set Cancel button text color to black
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit', style: TextStyle(color: Colors.black)), // Set Logout button text color to black
          ),
        ],
      );
    },
  );
}

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId'); // Clear userId from shared preferences
    Navigator.pushReplacementNamed(context, '/'); // Navigate to landing page
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
          child: Column(
            children: [
              // Greeting Container
              Container(
                height: MediaQuery.of(context).size.height * 0.25, // Adjusted height for better responsiveness
                color: const Color.fromARGB(210, 0, 0, 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05, // Slightly increased horizontal padding
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align logo to the start
                    crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                    children: [
                      // Logo positioned closer to the left side
                      Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02), // Small right padding for logo
                        child: Image.asset(
                          'assets/logo.png', // Replace with your actual logo image
                          width: MediaQuery.of(context).size.width * 0.3, // Responsive logo size
                          height: MediaQuery.of(context).size.width * 0.3, // Maintain aspect ratio
                        ),
                      ),
                      // Flexible space for the text
                      Flexible( 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                          children: [
                            const SizedBox(height: 10), // Space above the text
                            Text(
                              "Hi, welcome to KNC Printz",
                              style: GoogleFonts.nunito(
                                fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left, // Align text to the left
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _nickname ?? 'Loading...',
                              style: GoogleFonts.nunito(
                                fontSize: MediaQuery.of(context).size.width * 0.075, // Responsive font size for nickname
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left, // Align text to the left
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Top Services Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.1), // Change this color as needed
                    borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Inner padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Top Services",
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Set title text color to black
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_topServices.isNotEmpty)
                          SizedBox(
                            height: 150, // Increased height for bigger services
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _topServices.length,
                              itemBuilder: (context, index) {
                                final service = _topServices[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 16.0), // Add margin to the right
                                  width: 150, // Increased width for bigger services
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8), // Rounded corners for service containers
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        service['uploaded_image_url'],
                                        width: 120, // Adjusted width for bigger services
                                        height: 120, // Adjusted height for bigger services
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        service['service_name'],
                                        style: TextStyle(color: Colors.black), // Set service text color to black
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Text("No services available", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
     // Services Offered Section
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.lightGreenAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Services Offered",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          if (_servicesOffered.isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25, // Adjust height based on screen size
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _servicesOffered.length,
                itemBuilder: (context, index) {
                  final service = _servicesOffered[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width for service cards
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded( // Use Expanded to fit the image within available space
                          child: Image.network(
                            service['uploaded_image_url'] ?? '', // Default to an empty string if key is not found
                            width: double.infinity, // Set width to fill the container
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Image not available')); // Handle image loading error
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['service_name'] ?? 'No Name', // Fallback if service name is missing
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['description'] ?? 'No description available', // Fallback description
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₱${service['price'] ?? 'N/A'}', // Fallback for price
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Center(child: Text("No services available", style: TextStyle(color: Colors.grey))),
          const SizedBox(height: 10), // Add some spacing
          // View More Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServicesPage(userId: widget.userId,)), // Navigate to ServicesPage
                );
              },
              child: Text(
                "View More",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),

              // Map Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25, // Adjusted height for the map
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _location,
                    zoom: _zoom,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('knc_printz'),
                      position: _location,
                      infoWindow: InfoWindow(title: 'KNC Printz'),
                    ),
                  },
                ),
              ),
              // Contact Information Section
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Us:",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "0917 312 1564",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "kncprintz@gmail.com",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: _openFacebook,
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            "Follow us on Facebook",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
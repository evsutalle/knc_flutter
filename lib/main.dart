import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Add http package
import 'dart:convert'; // For JSON decoding
import 'package:knc/routes/home_route.dart';
import 'login.dart';
import 'register.dart';
import 'ForgotPasswordPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNC Printz',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF0066CC),
          secondary: Color(0xFFFF0099),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16.0,
            color: Colors.white,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.white70,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      // Define your routes here
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/ForgotPasswordPage': (context) => ForgotPasswordPage(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final userId = args['userId'];
          return HomeRoute(userId: userId);
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoggedIn = false;

  // Function to check if user is logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.containsKey('userId'); 
    });
  }

  Future<List<dynamic>> fetchServices() async {
    final response = await http.get(Uri.parse('https://kncprintz.com/knc/login/services_offered.php')); // Replace with your API URL

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode the JSON response
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on initialization
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set background color to transparent
        elevation: 0, // Remove shadow
        flexibleSpace: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // Apply blur effect
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(172, 127, 126, 126).withOpacity(0.7), // Black background with transparency
            ),
            child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),// Remove padding
              child: Align(
                   alignment: Alignment.topLeft,  // Align to the top-left corner
                child: Image.asset(
                    'assets/logo.png',
                  height: 55,
                ),
              ),
            ),
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          if (!_isLoggedIn)
            IconButton(
              icon: Icon(FontAwesomeIcons.user),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              tooltip: 'Login',
              alignment: Alignment.centerLeft,
            ),
          if (!_isLoggedIn)
            IconButton(
              icon: Icon(FontAwesomeIcons.userPlus),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              tooltip: 'Register',
              alignment: Alignment.centerLeft,
            ),
        ],
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(231, 41, 4, 26),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Promotional Banner with Gradient
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0066CC),
                      Color(0xFFFF0099),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'KNC PRINTZ',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Make it happen',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

          // Services Offered
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(
    'Services We Offer',
    style: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 255, 255, 255),
    ),
  ),
),
FutureBuilder<List<dynamic>>(
  future: fetchServices(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      // Determine the number of columns based on screen width
      final width = MediaQuery.of(context).size.width;
      int crossAxisCount = width < 600 ? 2 : 3; // 2 columns for mobile, 3 for larger screens

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.75, // Adjust the aspect ratio if needed
        ),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final service = snapshot.data![index];
          return ServiceCard(
            serviceName: service['service_name'],
            description: service['description'],
            price: '₱${service['price']}',
            imageUrl: service['uploaded_image_url'],
          );
        },
      );
    }
  },
),


            Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: () {
      if (_isLoggedIn) {
        // If logged in, navigate to the home route
        final prefs = SharedPreferences.getInstance();
        prefs.then((prefs) {
          final userId = prefs.getString('userId');
          Navigator.pushReplacementNamed(context, '/home', arguments: {'userId': userId});
        });
      } else {
        // If not logged in, navigate to the login page
        Navigator.pushNamed(context, '/login');
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 229, 47, 11),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: GoogleFonts.poppins(fontSize: 18),
    ),
    child: Text('Explore Our Services'),
  ),
),

              // Footer
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(16),
                color: Color.fromARGB(255, 27, 35, 50),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '© 2024 KNC Printz. All rights reserved.',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              // Handle email click
                              final Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: 'kncprintz@gmail.com',
                                queryParameters: {'subject': 'KNC Printz Inquiry'},
                              );
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              } else {
                                // Handle the case where the URL cannot be launched
                                print('Could not launch $emailUri');
                              }
                            },
                            icon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // Handle phone number click
                              final Uri phoneUri = Uri(
                                scheme: 'tel',
                                path: '09173121564', // Replace with your phone number
                              );
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                // Handle the case where the URL cannot be launched
                                print('Could not launch $phoneUri');
                              }
                            },
                            icon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // Handle Facebook click
                              final Uri facebookUri = Uri.parse('https://www.facebook.com/kncprintz'); // Replace with your Facebook page URL
                              if (await canLaunchUrl(facebookUri)) {
                                await launchUrl(facebookUri);
                              } else {
                                // Handle the case where the URL cannot be launched
                                print('Could not launch $facebookUri');
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;
  final String price;
  final String imageUrl;

  const ServiceCard({
    required this.serviceName,
    required this.description,
    required this.price,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.width < 600 ? 80 : 100; // Adjust height based on screen size

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              serviceName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 4, 4, 4),
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              maxLines: 2, // Control line overflow
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              'Price: $price',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 4, 4, 4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/logo.png',
          height: 40,
        ),
      ),
      actions: [
        if (!_isLoggedIn)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Login',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
            ),
          ),
        if (!_isLoggedIn)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              'Register',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
            ),
          ),
      ],
    ),  
    body: Container(
      decoration: BoxDecoration(
color: Color(0xCCCC2B52),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Promotional Banner with Image
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/KNC.png'), // Replace with your image path
                  fit: BoxFit.cover, // Ensures the image covers the entire container
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
                              color: Colors.black54,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      // Applying different colors to each word
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Make ',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0066CC), // Blue color for "Make"
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: 'it ',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF0099), // Pink color for "it"
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: 'happen',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700), // Yellow color for "happen"
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
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
            // Services Offered with Navigation
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
                  final scrollController = ScrollController();
                  return SizedBox(
                    height: 300, // Set a fixed height for the card container
                    child: Row(
                      children: [
                        // Left Navigation Icon
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.white, size: 32),
                          onPressed: () {
                            scrollController.animateTo(
                              scrollController.offset - 250, // Adjust scroll offset
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
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
                          ),
                        ),
                        // Right Navigation Icon
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.white, size: 32),
                          onPressed: () {
                            scrollController.animateTo(
                              scrollController.offset + 250, // Adjust scroll offset
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // "Explore Our Services" Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to login.dart
                },
                style: ElevatedButton.styleFrom(
backgroundColor: Color(0xFFFABC3F),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Explore Our Services',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 28, 28, 28),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: 'kncprintz@gmail.com',
                              queryParameters: {'subject': 'KNC Printz Inquiry'},
                            );
                            if (await canLaunch(emailUri.toString())) {
                              await launch(emailUri.toString());
                            } else {
                              throw 'Could not launch email';
                            }
                          },
                          icon: Icon(Icons.email, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () async {
                            final Uri phoneUri = Uri(scheme: 'tel', path: '09173121564');
                            if (await canLaunch(phoneUri.toString())) {
                              await launch(phoneUri.toString());
                            } else {
                              throw 'Could not launch phone';
                            }
                          },
                          icon: Icon(Icons.phone, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () async {
                            final Uri facebookUri =
                                Uri.parse('https://www.facebook.com/kncprintz');
                            if (await canLaunch(facebookUri.toString())) {
                              await launch(facebookUri.toString());
                            } else {
                              throw 'Could not launch Facebook';
                            }
                          },
                          icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Set a fixed width for each card
      margin: EdgeInsets.only(right: 16), // Add margin to the right
      child: Card(
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
                height: 120,
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
      ),
    );
  }
}
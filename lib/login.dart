import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = "";
  bool _obscureText = true; // Initially hide the password
  bool _isLoading = false; // Loading state
  bool _rememberMe = false; // Remember me state

  // Function to load saved credentials
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? "";
      _passwordController.text = prefs.getString('password') ?? "";
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  // Function to save credentials
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setBool('rememberMe', _rememberMe);
  }

  Future<void> login() async {
    setState(() {
      _message = ""; // Clear previous messages
      _isLoading = true; // Show loading indicator
    });

    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _message = "No internet connection. Please try again.";
        _isLoading = false; // Hide loading indicator
      });
      return; // Exit early if no internet connection
    }

    try {
      final response = await http.post(
        Uri.parse('https://kncprintz.com/knc/login/login.php'), // Updated Hostinger URL
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');

        if (data['status'] == 'success') {
          print("Login successful, navigating to home");

          // Save credentials if rememberMe is checked
          if (_rememberMe) {
            _saveCredentials();
          }

          // Show dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login successfully!', style: TextStyle(color: Colors.green)), // Updated title
                actions: [],
              );
            },
          );

          // Wait for a moment before navigating
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: {
                'userId': data['id'].toString(), // Ensure userId is a string
                'nickname': data['nickname'], // Pass nickname as is
              },
            );
          });
        } else if (data['status'] == 'invalid_password') {
          setState(() {
            _message = "Incorrect password";
          });
        } else if (data['status'] == 'not_found') {
          setState(() {
            _message = "User not found";
          });
        } else {
          setState(() {
            _message = "An error occurred";
          });
        }
      } else {
        print('Server error: ${response.statusCode}');
        setState(() {
          _message = "Server error: ${response.statusCode}";
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _message = "An error occurred: $error";
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on initialization

    // Check if rememberMe is checked and navigate to home if so
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_rememberMe) {
        _handleRememberMe();
      }
    });
  }

  // Function to handle the rememberMe logic
  Future<void> _handleRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      // If userId is found, navigate to the home page directly
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'userId': userId},
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center, // Center widgets horizontally
            children: <Widget>[
              // Image with left margin
              Container(
                margin: const EdgeInsets.only(left: 20.0), // Add left margin
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double imageWidth = constraints.maxWidth * 1; // 80% of available width
                    double imageHeight = imageWidth; // Maintain aspect ratio
                    return Image.asset(
                      'assets/login.png',
                      height: imageHeight,
                      width: imageWidth,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              // Login form directly below the image
              Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(FontAwesomeIcons.user, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(FontAwesomeIcons.lock, color: Colors.blue),
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        SizedBox(width: 8),
                        Text('Remember Me', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text("Login", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 12),
                    if (_isLoading)
                      CircularProgressIndicator(),
                    if (!_isLoading)
                      Text(
                        _message,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: TextStyle(color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text("Register", style: TextStyle(color: const Color.fromARGB(255, 0, 166, 249))),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Forgot Password?", style: TextStyle(color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/ForgotPasswordPage');
                          },
                          child: Text("Reset", style: TextStyle(color: const Color.fromARGB(255, 0, 166, 249))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
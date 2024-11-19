
import 'package:flutter/material.dart';
import 'package:knc/login.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'terms_and_conditions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primaryColor: const Color(0xFF0066CC),
        fontFamily: 'Arial',
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _municipalityCityController = TextEditingController();
  bool _termsAccepted = false;
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showTermsAndConditionsModal() {
    showDialog(
      context: context,
      builder: (context) => const TermsAndConditions(),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms and conditions')),
        );
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      final otp = Random().nextInt(900000) + 100000;

      try {
        final smtpServer = gmail(
          'markgerald.talle@evsu.edu.ph', // Replace with your email
          'MARKEYrald18!', // Replace with your app password
        );

        final message = Message()
          ..from = const Address('kncprintz@gmail.com', 'KNC PRINTZ')
          ..recipients.add(_emailController.text)
          ..subject = 'Your OTP'
          ..text = 'Your OTP is: $otp';

        await send(message, smtpServer);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              email: _emailController.text,
              otp: otp,
              username: _usernameController.text,
              phone: _phoneController.text,
              password: _passwordController.text,
              firstName: _firstNameController.text,
              municipalityCity: _municipalityCityController.text,
            ),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error sending OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 231, 221, 221),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(_firstNameController, 'Name', false, icon: Icons.person),
                      _buildInputField(_usernameController, 'Username', false, icon: Icons.person),
                      _buildInputField(_emailController, 'Email', false, icon: Icons.email, validateEmail: true),
                      _buildInputField(_phoneController, 'Phone', false, icon: Icons.phone, keyboardType: TextInputType.phone),
                      _buildInputField(_passwordController, 'Password', true, icon: Icons.lock, isPassword: true),
                      _buildInputField(_confirmPasswordController, 'Confirm Password', true, icon: Icons.lock, isPassword: true),
                      _buildInputField(_municipalityCityController, 'Address', false, icon: Icons.location_city),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _termsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _termsAccepted = value!;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showTermsAndConditionsModal,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width > 360 ? 14 : 12,
                                      color: Colors.black87,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'terms and conditions',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Register'),
                        ),
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

Widget _buildInputField(TextEditingController controller, String label, bool isObscure,
      {IconData? icon, bool validateEmail = false, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black, // Changed to black
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null,
        ),
        obscureText: isPassword ? _obscureText : isObscure,
        keyboardType: isPassword ? TextInputType.visiblePassword : keyboardType,
        style: TextStyle(color: Colors.black), // Added style
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (validateEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}
class OtpVerificationPage extends StatefulWidget {
  final String email;
  final int otp;
  final String username;
  final String phone;
  final String password;
  final String firstName;
  final String municipalityCity;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.otp,
    required this.username,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.municipalityCity,
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    if (_otpController.text != widget.otp.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://kncprintz.com/knc/login/register.php'), // Replace with your server URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': widget.username,
        'email': widget.email,
        'phone': widget.phone,
        'password': widget.password,
        'first_name': widget.firstName,
        'municipality_city': widget.municipalityCity,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to login page after successful registration
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the OTP sent to your email:',
              style: TextStyle(fontSize: 18, color: Colors.black), // Added color
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black), // Added style
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text('Verify OTP'),
                  ),

          ],
        ),
      ),
    );
  }
}
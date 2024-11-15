import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _otp;
  bool _isLoading = false;
  bool _showEmailInput = true;
  bool _showOtpInput = false;
  bool _showPasswordInput = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';

  Future<void> _checkAccountAndSendOTP(String email) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://peachpuff-mosquito-118862.hostingersite.com/knc/login/check_account.php'),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Send OTP after confirming the account exists
        _sendOTP(email);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account does not exist')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to check account')),
      );
    }
  }

  Future<void> _sendOTP(String email) async {
    final otp = Random().nextInt(900000) + 100000;

    try {
      final smtpServer = gmail(
        'markgerald.talle@evsu.edu.ph',
        'MARKEYrald18!',
      );

      final message = Message()
        ..from = const Address('kncprintz@gmail.com', 'KNC PRINTZ')
        ..recipients.add(email)
        ..subject = 'Your OTP'
        ..text = 'Your Forgot Password OTP is: $otp';

      await send(message, smtpServer);

      setState(() {
        _otp = otp.toString();
        _isLoading = false; // Set loading to false after sending OTP
        _showEmailInput = false; // Hide the email input
        _showOtpInput = true; // Show the OTP input
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending OTP. Please try again.')),
      );
    }
  }

  Future<void> _verifyOTP(String otp) async {
    setState(() {
      _isLoading = true;
    });

    if (otp == _otp) {
      setState(() {
        _isLoading = false;
        _showOtpInput = false; // Hide the OTP input
        _showPasswordInput = true; // Show the password input
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified')),
      );
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP')),
      );
    }
  }

  Future<void> _updatePassword(String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://kncprintz.com/knc/login/forgot_pass.php'),
      body: {'email': _emailController.text, 'newPassword': newPassword},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'], style: const TextStyle(color: Colors.black))),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update password')),
      );
    }
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 8) {
        _passwordStrength = 0;
        _passwordStrengthLabel = 'Weak';
      } else {
        int strength = 0;
        if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
        if (RegExp(r'[a-z]').hasMatch(password)) strength++;
        if (RegExp(r'[0-9]').hasMatch(password)) strength++;
        if (RegExp(r'[!@#\$%\^&\*]').hasMatch(password)) strength++;

        _passwordStrength = strength / 4;
        switch (strength) {
          case 1:
            _passwordStrengthLabel = 'Weak';
            break;
          case 2:
            _passwordStrengthLabel = 'Medium';
            break;
          case 3:
          case 4:
            _passwordStrengthLabel = 'Strong';
            break;
          default:
            _passwordStrengthLabel = 'Weak';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.blue, // Facebook blue
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Wrap the Column in SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Facebook Logo (Replace with your own logo)
                // Image.asset(
                //   'assets/logo.png', // Replace with your logo path
                //   height: 100,
                // ),
                const SizedBox(height: 40),
                // Email Input
                if (_showEmailInput) ...[
                  const Text(
                    'Enter your email address to receive an OTP',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _checkAccountAndSendOTP(_emailController.text);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Facebook blue
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Send OTP'),
                  ),
                  const SizedBox(height: 32),
                ],
                // OTP Input
                if (_showOtpInput) ...[
                  const Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      hintText: 'OTP',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _verifyOTP(_otpController.text);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Facebook blue
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 32),
                ],
                // New Password Input
                if (_showPasswordInput) ...[
                  const Text(
                    'Enter New Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_showNewPassword,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_showNewPassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash),
                        onPressed: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: _checkPasswordStrength,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _passwordStrength,
                          backgroundColor: Colors.grey[300],
                          color: _passwordStrengthLabel == 'Weak'
                              ? Colors.red
                              : _passwordStrengthLabel == 'Medium'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _passwordStrengthLabel,
                        style: TextStyle(
                          color: _passwordStrengthLabel == 'Weak'
                              ? Colors.red
                              : _passwordStrengthLabel == 'Medium'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirmPassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _updatePassword(
                                _newPasswordController.text,
                                _confirmPasswordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Facebook blue
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Update Password'),
                  ),
                  const SizedBox(height: 32),
                ],
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
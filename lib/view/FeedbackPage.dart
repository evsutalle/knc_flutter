import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  final String userId;

  const FeedbackPage({super.key, required this.userId});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String _feedbackMessage = '';
  Color _feedbackMessageColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.commentDots,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Share Your Feedback',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Your Feedback',
                    hintText: 'Tell us what you think!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide your feedback';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Feedback'),
                            content: Text(
                                'Are you sure you want to submit this feedback?\n\n"${_feedbackController.text}"'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _sendFeedback();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Submit Feedback'),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    _feedbackMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: _feedbackMessageColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
Future<void> _sendFeedback() async {
  final apiUrl = 'https://kncprintz.com/knc/login/submit_feedback.php';
  final body = jsonEncode({
    'feedback': _feedbackController.text,
    'user_id': widget.userId,
  });

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        // Clear the input field
        _feedbackController.clear();

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.green,
              content: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.checkCircle,
                        size: constraints.maxWidth * 0.2, // Adjust icon size based on dialog width
                        color: Colors.white,
                      ),
                      SizedBox(width: constraints.maxWidth * 0.05), // Adjust spacing based on dialog width
                      Flexible(
                        child: Text(
                          'Feedback submitted successfully!',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.05, // Adjust font size based on dialog width
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Display error message in feedback container
        setState(() {
          _feedbackMessage = data['message'];
          _feedbackMessageColor = Colors.red;
        });
      }
    } else {
      // Handle server error
      setState(() {
        _feedbackMessage = 'Server error: ${response.statusCode}';
        _feedbackMessageColor = Colors.red;
      });
    }
  } catch (error) {
    // Handle connection error
    setState(() {
      _feedbackMessage = 'Connection error: $error';
      _feedbackMessageColor = Colors.red;
    });
  }
}



  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
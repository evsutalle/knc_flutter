import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HelpCenterPage extends StatefulWidget {
  final String userId;

  const HelpCenterPage({super.key, required this.userId});

  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isSendingMessage = false;

  // Send a message to the backend
  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();

      // Set the sending state to true, show a loading spinner while waiting for the response
      setState(() {
        _isSendingMessage = true;
      });

      try {
        // Send message to PHP backend
        final response = await http.post(
          Uri.parse('https://kncprintz.com/knc/login/chat.php'), // Replace with your actual URL
          body: {
            'user_id': widget.userId, // Pass user ID
            'message': message,
          },
        );

        if (response.statusCode == 200) {
          // Successfully sent message
          setState(() {
            _messages.add({
              'sender': 'User',
              'message': message,
            });
            _messageController.clear();

            // Process response from PHP (if any)
            final data = jsonDecode(response.body);
            if (data['response'] != null) {
              _messages.add({
                'sender': 'Staff',
                'message': data['response'],
              });
            }
          });
        } else {
          // Handle error from server response
          throw Exception('Error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle exception or connection error
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      } finally {
        // Set the sending state back to false after message is sent or error occurs
        setState(() {
          _isSendingMessage = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Help Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Here you can find answers to common questions and get support.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            // Chat Box
            Expanded(
              child: ListView.builder(
                reverse: true, // This ensures the latest message is at the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message['sender'] == 'User'
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'User'
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        message['message'],
                        style: TextStyle(
                          color: message['sender'] == 'User'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Message Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  _isSendingMessage
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(Icons.send),
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
  
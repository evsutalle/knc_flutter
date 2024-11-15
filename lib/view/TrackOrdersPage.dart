import 'package:flutter/material.dart';
import 'OrdersPage.dart';
import 'ServicesPage.dart';
import 'ProfilePage.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for Font Awesome icons

class TrackOrdersPage extends StatefulWidget {
  final String userId;

  const TrackOrdersPage({super.key, required this.userId});

  @override
  _TrackOrdersPageState createState() => _TrackOrdersPageState();
}

class _TrackOrdersPageState extends State<TrackOrdersPage> {
  late Future<List<OrderItem>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<OrderItem>> fetchOrders() async {
    const String apiUrl = 'https://kncprintz.com/knc/login/track.php';

    try {
      final response = await http.get(Uri.parse('$apiUrl?userId=${widget.userId}'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((order) => OrderItem.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception('Failed to load orders');
    }
  }

  double getOrderProgress(String status) {
    switch (status.toLowerCase()) {
      case 'progress':
        return 0.20;
      case 'graphic artist':
        return 0.40;
      case 'station 2':
        return 0.60;
      case 'station 3':
        return 0.80;
      case 'station 4':
        return 1.0;
      case 'completed':
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'Track Orders',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No orders to track yet.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              double progress = getOrderProgress(order.status ?? 'Pending');

              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(order.serviceName, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.details),
                          SizedBox(height: 4),
                          Text('Created At: ${order.createdAt}', style: TextStyle(color: Colors.grey)),
                          Text('Status: ${order.status ?? 'Pending'}', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          // Navigate to order details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(orderItem: order),
                            ),
                          );
                        },
                      ),
                    ),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Progress", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)), // Responsive font size
                          SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: progress, // Progress value from 0.0 to 1.0
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(order.status?.toLowerCase() == 'completed' ? Colors.green : Colors.blue,),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
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
                    MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.list_alt, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.local_offer, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ServicesPage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.track_changes, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TrackOrdersPage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem {
  final String serviceName;
  final String details;
  final String serviceType;
  final String createdAt;
  String? status;
  final String orderId;

  OrderItem({
    required this.serviceName,
    required this.details,
    required this.serviceType,
    required this.createdAt,
    this.status,
    required this.orderId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String details;

    if (json.containsKey('print_size')) {
      details = 'Size: ${json['print_size']}, Quantity: ${json['quantity']}, Price: ₱${json['price']}';
    } else if (json.containsKey('jersey_type')) {
      details = 'Type: ${json['jersey_type']}, Quantity: ${json['quantity']}, Price: ₱${json['price']}';
    } else if (json.containsKey('lighted')) {
      details = 'Size: ${json['size']}, Lighted: ${json['lighted']}, Quantity: ${json['quantity']}, Price: ₱${json['price']}';
    } else if (json.containsKey('item_type')) {
      details = 'Item Type: ${json['item_type']}, Size: ${json['size']}, Quantity: ${json['quantity']}, Price: ₱${json['price']}';
    } else if (json.containsKey('material')) {
      details = 'Material: ${json['material']}, Size: ${json['size']}, Quantity: ${json['quantity']}, Price per Sqft: ₱${json['price_per_sqft'] ?? 'N/A'}'; // Use ?? to provide a default value
    } else if (json.containsKey('price_per_sqft')) {
      details = 'Quantity: ${json['quantity']}, Price per Sqft: ₱${json['price_per_sqft']}';
    } else {
      details = 'Quantity: ${json['quantity']}, Price: ₱${json['price']}';
    }

    // Format the createdAt date
    DateTime createdDateTime = DateTime.parse(json['created_at']);
    String formattedCreatedAt = DateFormat('MMMM d, yyyy h:mm a').format(createdDateTime); // Format date and time

    return OrderItem(
      serviceName: json['service_name'] ?? 'Unknown Service',
      details: details,
      serviceType: json['service_type'] ?? 'Other',
      createdAt: formattedCreatedAt, // Use the formatted date
      status: json['status'] ?? 'ERROR',
      orderId: json['order_id'] ?? 'Unknown Order ID',
    );
  }
}

// Screen to display order details
class OrderDetailsScreen extends StatelessWidget {
  final OrderItem orderItem;

  const OrderDetailsScreen({super.key, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Order Details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderItem.serviceName,
              style: TextStyle(
                fontSize: screenWidth * 0.06, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenWidth * 0.02), // Responsive spacing
            // Align details vertically
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: orderItem.details.split(',').map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    detail.trim(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              "Status: ${orderItem.status}",
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              "Created At: ${orderItem.createdAt}",
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            // Add the message for completed status
            if (orderItem.status?.toLowerCase() == 'completed')
              Text(
                "Ready to pick up!",
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              "Order Progress",
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            LinearProgressIndicator(
              value: getOrderProgress(orderItem.status ?? 'Pending'),
              backgroundColor: const Color.fromARGB(255, 105, 44, 44),
              valueColor: AlwaysStoppedAnimation<Color>(
                orderItem.status?.toLowerCase() == 'completed' ? Colors.green : Colors.blue,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            // Vertical dot stages indicator
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildProgressDots(orderItem.status ?? 'Pending'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProgressDots(String status) {
    // Define the stages with icons
    final stages = [
      {"icon": FontAwesomeIcons.building, "label": "Front Desk"},
      {"icon": FontAwesomeIcons.palette, "label": "Graphic Artist"},
      {"icon": FontAwesomeIcons.print, "label": "Station 2 (Printing)"},
      {"icon": FontAwesomeIcons.tools, "label": "Station 3 (Produce)"},
      {"icon": FontAwesomeIcons.checkCircle, "label": "Station 4 (Final Touch)"},
    ];

    return List.generate(stages.length, (index) {
      Map stageData = stages[index];
      bool isActive = getOrderProgress(status) >= (index + 1) * 0.20; // Update progress calculation to check against (index + 1) * 0.20 for better accuracy

      // Specifically highlight Station 4 if the status is completed
      if (status.toLowerCase() == 'completed' && stageData["label"] == 'Station 4 (Final Touch)') {
        isActive = true; // Force Station 4 to be active
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16), // Increased space between dot and label
          // Display stage name only if the progress reaches this stage
          if (isActive || status.toLowerCase() == stageData["label"].toLowerCase())
            Row(
              children: [
                FaIcon(stageData["icon"], size: 16), // Icon
                SizedBox(width: 8), // Increased space between icon and text
                Text(
                  stageData["label"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          SizedBox(height: 20), // Increased space between rows
        ],
      );
    });
  }

  double getOrderProgress(String status) {
    switch (status.toLowerCase()) {
      case 'progress':
        return 0.20;
      case 'graphic artist':
        return 0.40;
      case 'station 2':
        return 0.60;
      case 'station 3':
        return 0.80;
      case 'station 4':
        return 1.0; // Station 4 as complete
      case 'completed':
        return 1.0; // Completed as full progress
      default:
        return 0.0; // For any other status or pending
    }
  }
}
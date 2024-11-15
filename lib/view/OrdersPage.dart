import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';
import 'ServicesPage.dart';
import 'TrackOrdersPage.dart';
import 'ProfilePage.dart';

class OrdersPage extends StatefulWidget {
  final String userId;

  const OrdersPage({super.key, required this.userId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<String> categories = [
    "Jersey",
    "Tarpaulin",
    "Souvenir",
    "Tshirt",
    "Sticker",
    "Signage",
  ];

  final List<IconData> categoryIcons = [
    FontAwesomeIcons.tshirt,
    FontAwesomeIcons.file,
    FontAwesomeIcons.userTie,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.print,
    FontAwesomeIcons.image,
    FontAwesomeIcons.file,
    FontAwesomeIcons.fileImage,
  ];

  String selectedCategory = "Jersey";
  Future<List<dynamic>>? _categoryOrders;

  @override
  void initState() {
    super.initState();
    _fetchCategoryOrders(selectedCategory);
  }

  Future<void> _fetchCategoryOrders(String category) async {
    String endpoint = '';
    switch (category) {
      case "Jersey":
        endpoint =
            'https://kncprintz.com/knc/login/jersey_orders.php?user_id=${widget.userId}';
        break;
      case "Tarpaulin":
        endpoint =
            'https://kncprintz.com/knc/login/tarp_orders.php?user_id=${widget.userId}';
        break;
      case "Souvenir":
        endpoint =
            'https://kncprintz.com/knc/login/souvenir_orders.php?user_id=${widget.userId}';
        break;
      case "Tshirt":
        endpoint =
            'https://kncprintz.com/knc/login/tshirt_orders.php?user_id=${widget.userId}';
        break;
      case "Sticker":
        endpoint =
            'https://kncprintz.com/knc/login/sticker_orders.php?user_id=${widget.userId}';
        break;
      case "Signage":
        endpoint =
            'https://kncprintz.com/knc/login/signage_orders.php?user_id=${widget.userId}';
        break;
      default:
        return;
    }

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      try {
        List<dynamic> orders = json.decode(response.body);
        setState(() {
          _categoryOrders = Future.value(orders);
        });
      } catch (e) {
        setState(() {
          _categoryOrders = Future.error('Invalid JSON response');
        });
      }
    } else {
      setState(() {
        _categoryOrders = Future.error('Failed to load orders');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(
          child: Text(
            'Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFFFF7FC),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                          _fetchCategoryOrders(selectedCategory);
                        });
                      },
                      child: Container(
                        width: 80,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: selectedCategory == categories[index]
                              ? Colors.blue
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              categoryIcons[index],
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              categories[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: _categoryOrders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.black)));
                  } else if (snapshot.hasData) {
                    final orders = snapshot.data!;
                    if (orders.isEmpty) {
                      return Center(
                          child: Text('No orders found.',
                              style: TextStyle(color: Colors.black)));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final createdDate = DateTime.parse(order['created_at']);
                        final formattedDate =
                            DateFormat('MMM dd, yyyy').format(createdDate);
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order['service_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Payment Method: ${order['payment_method']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Downpayment: ₱${order['downpayment']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Total Amount: ₱${order['total_amount']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Remaining Amount: ₱${order['remaining_amount']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Quantity: ${order['quantity']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: _getPaymentStatusColor(
                                            order['payment_status']),
                                      ),
                                      child: Text(
                                        order['payment_status'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Created At: $formattedDate',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text('No orders found.',
                            style: TextStyle(color: Colors.black)));
                  }
                },
              ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.list_alt, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.local_offer, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServicesPage(userId: widget.userId)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.track_changes, color: Colors.black),
                onPressed: () {
                  Navigator.push(
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
                  Navigator.push(
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
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color.fromARGB(222, 245, 132, 57);
      case 'failed':
        return Colors.red;
      case 'Ppaid':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
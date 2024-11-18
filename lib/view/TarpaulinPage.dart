import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';   // Add this import


const String apiBaseUrl = 'https://kncprintz.com/knc/login';
const String jerseyEndpoint = '/get_tarp.php';
const String orderEndpoint = '/order_tarp.php';

// PayMongo API Credentials
const String payMongoSecretKey = 'sk_test_opFhcL5QjofwJW4JwL92Dt85'; // Replace with your actual test secret key
const String payMongoBaseUrl = 'https://api.paymongo.com/v1';

class TarpaulinPage extends StatefulWidget {
  final String userId;

  const TarpaulinPage({super.key, required this.userId});

  @override
  _TarpaulinPageState createState() => _TarpaulinPageState();
}

class _TarpaulinPageState extends State<TarpaulinPage> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDtfServices();
  }

  Future<void> fetchDtfServices() async {
    try {
    final response = await http.get(Uri.parse('$apiBaseUrl$jerseyEndpoint'));

      if (response.statusCode == 200) {
        setState(() {
          services = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorMessage('Failed to load Tarpaulin services. Please try again later.');
      }
    } catch (e) {
      _showErrorMessage('Error fetching services: $e');
    }
  }

  void _showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 400,
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            backgroundDecoration: BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  // Function to close the modal
  void _closeModal(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

void _showOrderModal(BuildContext context, Map<String, dynamic> service) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? designFile;
  String selectedPaymentMethod = 'GCash';
  bool withDesign = false;
  bool withoutDesign = false;

  double totalAmount = 0.0;
  double downPayment = 0.0;
  double remainingBalance = 0.0;

  void _updateCalculations(StateSetter setState) {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(service['price_per_sqft'].toString()) ?? 0.0;
    final addFee = double.tryParse(service['add_fee'].toString()) ?? 0.0;

    // Calculate total amount based on quantity and price
    totalAmount = quantity * price;

    // Calculate the base down payment as 50% of the total amount
    double baseDownPayment = totalAmount * 0.5;

    // Set downPayment with the additional fee if withoutDesign is true
    downPayment = baseDownPayment;
    if (withoutDesign) {
      // Add the design fee if 'withoutDesign' is selected
      downPayment += addFee;
    }

    // Calculate remaining balance based on the base down payment, excluding addFee
    remainingBalance = totalAmount - downPayment;

    // Update the state with the calculated values
    setState(() {
      totalAmount = totalAmount;
      downPayment = downPayment;
      remainingBalance = remainingBalance;
    });
  }

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        quantityController.addListener(() {
          _updateCalculations(setState);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Order ${service['service_name']}',
            style: TextStyle(
                color: Color(0xFFD91656), fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price: ₱${service['price_per_sqft']}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color: Color(0xFFD91656)),
                      prefixIcon: Icon(
                        Icons.confirmation_num,
                        color: Color(0xFFD91656),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD91656)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD91656)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid quantity.';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  // Checkbox for With Design
                  Row(
                    children: [
                      Checkbox(
                        value: withDesign,
                        onChanged: (value) {
                          setState(() {
                            withDesign = value!;
                            if (withDesign) {
                              withoutDesign = false;
                            }
                            _updateCalculations(setState);
                          });
                        },
                      ),
                      Text('With Design', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  // Checkbox for Without Design
                  Row(
                    children: [
                      Checkbox(
                        value: withoutDesign,
                        onChanged: (value) {
                          setState(() {
                            withoutDesign = value!;
                            if (withoutDesign) {
                              withDesign = false;
                            }
                            _updateCalculations(setState);
                          });
                        },
                      ),
                      Text('Without Design', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 10),
                  RadioListTile<String>(
                    title: Text('GCash', style: TextStyle(color: Colors.black)),
                    value: 'GCash',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Card', style: TextStyle(color: Colors.black)),
                    value: 'Card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Additional Description',
                      labelStyle: TextStyle(color: Color(0xFFD91656)),
                      prefixIcon: Icon(
                        Icons.description,
                        color: Color(0xFFD91656),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD91656)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD91656)),
                      ),
                    ),
                    maxLines: 3,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Divider(
                      color: Color(0xFFD91656).withOpacity(0.2), thickness: 1),
                  SizedBox(height: 5),
                  Text(
                    'Total Amount: ₱${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'Downpayment (50%): ₱${downPayment.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8), fontSize: 15),
                  ),
                  Text(
                    'Remaining Balance: ₱${remainingBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6), fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          designFile = File(pickedFile.path);
                        });
                      }
                    },
                    icon: Icon(Icons.upload_file, color: Colors.white),
                    label: Text(
                      designFile == null
                          ? 'Upload Design'
                          : designFile!.path.split('/').last,
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD91656),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final checkoutUrl = await _createPayMongoPayment(
                              service,
                              quantityController.text,
                              descriptionController.text,
                              designFile,
                              selectedPaymentMethod);
                          if (checkoutUrl != null) {
                            await launchUrl(Uri.parse(checkoutUrl));
                            _closeModal(context);
                            await _placeOrder(
                              service,
                              quantityController.text,
                              descriptionController.text,
                              designFile,
                              selectedPaymentMethod,
                              withDesign,
                              withoutDesign,
                            );
                          } else {
                            _showErrorMessage(
                                'Failed to create PayMongo payment. Please try again later.');
                          }
                        }
                      },
                      child: Text(
                        'Place Order',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD91656),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}


  Future<String?> _createPayMongoPayment(
      Map<String, dynamic> service,
      String quantity,
      String description,
      File? designFile,
      String paymentMethod) async {
    try {
      final price = double.tryParse(service['price_per_sqft'].toString()) ?? 0.0;
      final totalAmount = price * int.parse(quantity);
      final downPayment = totalAmount * 0.5;

      // Create PayMongo Payment Intent
      final response = await http.post(
        Uri.parse('$payMongoBaseUrl/links'),
        headers: {
          'accept': 'application/json',
          'authorization': 'Basic c2tfdGVzdF9vcEZoY0w1UWpvZndKVzRKd0w5MkR0ODU6',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "attributes": {
              "amount": (downPayment * 100).toInt(), // Amount in cents
              "description":
                  'Order ${service['service_name']} Payment', // Description
              "remarks": "hahaha",
            }
          }
        }),
      );

      print('PayMongo Response Status Code: ${response.statusCode}');
      print('PayMongo Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final paymentIntent = responseBody['data'];
        return paymentIntent['attributes']['checkout_url'];
      } else {
        _showErrorMessage('Failed to create PayMongo payment.');
        return null;
      }
    } catch (e) {
      _showErrorMessage('Error creating PayMongo payment: $e');
      return null;
    }
  }

Future<void> _placeOrder(
  Map<String, dynamic> service,
  String quantity,
  String description,
  File? designFile,
  String paymentMethod,
  bool withDesign,
  bool withoutDesign, // Add this argument
) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$apiBaseUrl$orderEndpoint'));

    // Required fields:
    request.fields['user_id'] = widget.userId; // Use the passed userId
    request.fields['tarp_id'] = service['tarp_id'].toString();
    request.fields['service_name'] = service['service_name'];
    request.fields['size'] = service['size'];
    request.fields['description'] = service['description'];
    request.fields['price_per_sqft'] = service['price_per_sqft'].toString();
    request.fields['quantity'] = quantity;
    request.fields['payment_method'] = paymentMethod; // Send payment method
    request.fields['descriptions'] = description;

    // Optional fields:
    request.fields['uploaded_image'] = service['uploaded_image'] ?? '';

   // Calculate total amount and downpayment based on design checkbox
    double totalAmount = double.parse(service['price_per_sqft'].toString()) *
        int.parse(quantity);
    double downPayment = totalAmount * 0.5;

    // Check for design fee addition based on the design option
    if (withDesign || withoutDesign) {
      double addFee = double.tryParse(service['add_fee'].toString()) ?? 0.0;
      downPayment += addFee;  // Add the design fee to the downpayment
    }

    // Calculate remaining amount (totalAmount - downPayment)
    double remainingAmount = totalAmount - downPayment;

    request.fields['downpayment'] = downPayment.toStringAsFixed(2);
    request.fields['total_amount'] = totalAmount.toStringAsFixed(2);
    request.fields['remaining_amount'] = remainingAmount.toStringAsFixed(2);

    // Add design file if available
    if (designFile != null) {
      request.files.add(http.MultipartFile(
          'design',
          designFile.readAsBytes().asStream(),
          designFile.lengthSync(),
          filename: designFile.path.split('/').last));
    }

    // Add the "with_design" field to the request as 1 for with design, 0 for without design
    request.fields['check_design'] = withDesign ? '1' : '0';

    final response = await request.send();
    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody');
      final responseJson = json.decode(responseBody);

      if (responseJson['status'] == 'success') {
        _showSuccessMessage(
            'Order placed successfully! Your order ID is ${responseJson['order_id']}.');
      } else {
        _showErrorMessage(
            'Failed to place order. ${responseJson['message'] ?? 'Please try again later.'}');
      }
    } else {
      _showErrorMessage(
          'Failed to place order. Please try again later.');
    }
  } catch (e) {
    _showErrorMessage('Error placing order: $e');
  }
}

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Tarpaulin Services', style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF2196F3), // Material Blue
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.grey[100], // Background color for the screen
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 5, // Slight elevation for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2), // Subtle shadow
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showZoomableImage(context, service['uploaded_image_url']);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: service['uploaded_image_url'],
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Details Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200], // Light background for details
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service Name
                                Text(
                                  service['service_name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Size
                                _buildDetailText('Size: ', service['size']),
                                SizedBox(height: 8),
                                // Price per Sq Ft
                                _buildDetailText('Price: ', '₱${service['price_per_sqft']} per sq ft'),
                                SizedBox(height: 8),
                                // Description
                                _buildDetailText('Description: ', service['description']),
                                SizedBox(height: 16),
                                // Order Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showOrderModal(context, service);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 37, 231, 19), // Accent color
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Order Now'),
                                        SizedBox(width: 8),
                                        Icon(
                                          FontAwesomeIcons.cartShopping,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
  );
}

// Helper function to build detail text
Widget _buildDetailText(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label + value, // Concatenate label and value
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato',
        ),
      ),
      SizedBox(height: 4),
    ],
  );
}
}
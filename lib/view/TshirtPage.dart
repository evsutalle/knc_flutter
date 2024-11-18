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
const String tshirtEndpoint = '/get_tshirt.php';
const String orderEndpoint = '/order_tshirt.php';

// PayMongo API Credentials
const String payMongoSecretKey = 'sk_test_opFhcL5QjofwJW4JwL92Dt85'; // Replace with your actual test secret key
const String payMongoBaseUrl = 'https://api.paymongo.com/v1';

class TshirtPage extends StatefulWidget {
  final String userId;

  TshirtPage({required this.userId});

  @override
  _TshirtPageState createState() => _TshirtPageState();
}

class _TshirtPageState extends State<TshirtPage> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTshirtServices();
  }

  Future<void> fetchTshirtServices() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl$tshirtEndpoint'));

      if (response.statusCode == 200) {
        setState(() {
          services = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorMessage('Failed to load Tshirt Printing services. Please try again later.');
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
  TextEditingController descriptionController = TextEditingController();
  File? designFile;
  String selectedPaymentMethod = 'GCash';
  bool withDesign = false;
  int checkDesign = 0; // Initialize checkDesign to 0

  // Group size controllers for better readability
  final sizeControllers = {
    'XS': TextEditingController(),
    'S': TextEditingController(),
    'M': TextEditingController(),
    'L': TextEditingController(),
    'XL': TextEditingController(),
    'XXL': TextEditingController(),
    'XXXL': TextEditingController(),
  };

  double totalAmount = 0.0;
  double downPayment = 0.0;
  double remainingBalance = 0.0;
  int totalQuantity = 0;

  // Calculate total and update state
  void _calculateTotal() {
    totalQuantity = sizeControllers.values
        .map((controller) => int.tryParse(controller.text) ?? 0) // Treat empty inputs as 0
        .reduce((a, b) => a + b); // Sum all quantities
    final price = double.tryParse(service['price'].toString()) ?? 0.0;
    totalAmount = totalQuantity * price;
    downPayment = totalAmount * 0.5;
    remainingBalance = totalAmount - downPayment;
  }

  // Build size fields dynamically
  Widget _buildSizeFields() {
    return Column(
      children: sizeControllers.entries.map((entry) {
        final size = entry.key;
        final controller = entry.value;
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '$size Size',
            labelStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.checkroom, color: Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (_) {
            _calculateTotal(); // Update totals whenever input changes
          },
        );
      }).toList(),
    );
  }

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
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
                    'Price: ₱${service['price']}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  // Size fields
                  _buildSizeFields(),
                  SizedBox(height: 10),
                  // Design selection options
                  Text(
                    "Design Options",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: withDesign,
                            onChanged: (value) {
                              setState(() {
                                withDesign = value!;
                                checkDesign = withDesign ? 1 : 0;
                              });
                            },
                          ),
                          Text('With Design', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: !withDesign,
                            onChanged: (value) {
                              setState(() {
                                withDesign = value!;
                                checkDesign = withDesign ? 1 : 0;
                              });
                            },
                          ),
                          Text('Without Design', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
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
                  SizedBox(height: 10),
                  // Payment methods
                  Column(
                    children: [
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
                    ],
                  ),
                  SizedBox(height: 10),
                  // Additional Description
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Additional Description',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.description, color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    maxLines: 3,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  // Total amount and downpayment
                  Divider(color: Colors.black.withOpacity(0.2), thickness: 1),
                  SizedBox(height: 5),
                  Text(
                    'Total Amount: ₱${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
                  // Place Order button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final checkoutUrl = await _createPayMongoPayment(
                              service,
                              totalQuantity.toString(),
                              descriptionController.text,
                              designFile,
                              selectedPaymentMethod);
                          if (checkoutUrl != null) {
                            await launchUrl(Uri.parse(checkoutUrl));
                            _closeModal(context);

                            await _placeOrder(
                              service,
                              sizeControllers['XS']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['XS']!.text,
                              sizeControllers['S']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['S']!.text,
                              sizeControllers['M']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['M']!.text,
                              sizeControllers['L']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['L']!.text,
                              sizeControllers['XL']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['XL']!.text,
                              sizeControllers['XXL']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['XXL']!.text,
                              sizeControllers['XXXL']!.text.isEmpty
                                  ? '0'
                                  : sizeControllers['XXXL']!.text,
                              descriptionController.text,
                              withDesign ? designFile : null,
                              selectedPaymentMethod,
                              checkDesign,
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


  Widget _buildSizeField(String size, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            size,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Qty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (_) {
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveLabel(String text, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 16 : 14; // Adjust for larger and smaller screens

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
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
      final price = double.tryParse(service['price'].toString()) ?? 0.0;
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
  String? xs,
  String? small,
  String? medium,
  String? large,
  String? xl,
  String? xxl,
  String? xxxl,
  String description,
  File? designFile,
  String paymentMethod,
  int checkDesign,
) async {
  try {
    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl$orderEndpoint'),
    );

    // Add required fields
    request.fields['user_id'] = widget.userId.toString(); // Ensure user_id is a string
    request.fields['tshirt_id'] = service['tshirt_id'].toString();
    request.fields['service_name'] = service['service_name'] ?? '';
      request.fields['description'] = service['description'];
    request.fields['price'] = service['price'].toString();
    request.fields['payment_method'] = paymentMethod;
    request.fields['xs'] = (int.tryParse(xs ?? '') ?? 0).toString(); // Handle null or empty values
    request.fields['small'] = (int.tryParse(small ?? '') ?? 0).toString();
    request.fields['medium'] = (int.tryParse(medium ?? '') ?? 0).toString();
    request.fields['large'] = (int.tryParse(large ?? '') ?? 0).toString();
    request.fields['xl'] = (int.tryParse(xl ?? '') ?? 0).toString();
    request.fields['xxl'] = (int.tryParse(xxl ?? '') ?? 0).toString();
    request.fields['xxxl'] = (int.tryParse(xxxl ?? '') ?? 0).toString();
    request.fields['check_design'] = checkDesign == 1 ? '1' : '0'; // Send as a string
    request.fields['descriptions'] = description;
    request.fields['uploaded_image'] = service['uploaded_image'] ?? '';

    // Add the design file if available
    if (designFile != null) {
      var file = await http.MultipartFile.fromPath('design', designFile.path);
      request.files.add(file);
    }

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (responseJson['status'] == 'success') {
        // Show success message with the order ID
        _showSuccessMessage(
            'Order placed successfully! Your order ID is ${responseJson['order_id']}.' );
      } else {
        // Show error message based on the response from the server
        _showErrorMessage(
            'Failed to place order. ${responseJson['message'] ?? 'Please try again later.'}');
      }
    } else {
      // Handle unsuccessful response status code
      _showErrorMessage('Failed to place order. Please try again later.');
    }
  } catch (e) {
    // Handle any errors that occur during the process
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
      title: Text('Tshirt Services', style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF2196F3), // Material Blue
    ),
    body: Container(
      color: Colors.grey[100], // Background color for the screen
      child: ListView.builder(
        itemCount: services.length, // Assuming 'services' is a list
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
                          // Price
                          Text(
                            'Price: ₱${service['price']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Description
                          Text(
                            'Description: ${service['description']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                            ),
                          ),
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
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              ),
                               child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Order Now'),
                              SizedBox(width: 8),
                              Icon(
                                FontAwesomeIcons.arrowRight,
                                color: const Color.fromARGB(255, 0, 0, 0),
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
}
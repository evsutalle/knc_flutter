import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue, // Set the AppBar background to skyblue
        title: Text(
          'About Us',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontFamily: 'Roboto', // Example font family
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container( // Add a Container for background color
        color: Colors.grey[200], // Example background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Add SingleChildScrollView for scrolling 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KNC PRINTZ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Example color
                  fontFamily: 'Roboto', // Example font family
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your One-Stop Shop for Premium Printing Solutions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black, // Example color
                  fontFamily: 'Roboto', // Example font family
                ),
              ),
              SizedBox(height: 24),
              // Service Icons and Descriptions
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Example color
                      fontFamily: 'Roboto', // Example font family
                    ),
                  ),
                  SizedBox(height: 16),
                  // Wrap each service in a Column for better layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.flag, size: 32, color: Colors.blue), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'High-Quality Tarpaulin Printing: Make a lasting impression with our vibrant and durable tarpaulin prints, ideal for outdoor advertising, events, and promotional campaigns.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.tshirt, size: 32, color: Colors.green), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Quality & Affordable T-Shirt Printing: Express your brand or personal style with custom-designed t-shirts, printed with precision and care, ensuring a comfortable fit and vibrant colors.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.print, size: 32, color: Colors.orange), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Full Sublimation, Panaflex, Uniform, Souvenir, DTF Printing, Large Format: We handle all your printing needs, from small-scale designs to large-format projects, guaranteeing consistent quality and timely delivery.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Why Choose KNC PRINTZ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Example color
                      fontFamily: 'Roboto', // Example font family
                    ),
                  ),
                  SizedBox(height: 16),
                  // Wrap each benefit in a Column for better layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.star, size: 32, color: Colors.yellow), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Unwavering Commitment to Quality: We use only the finest materials and cutting-edge printing technology to ensure exceptional results with every order.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.user, size: 32, color: Colors.purple), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Personalized Service: We work closely with our clients to understand their unique vision and provide tailored solutions that exceed expectations.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.moneyBillWave, size: 32, color: Colors.pink), // Example color
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Competitive Pricing: We offer competitive pricing without compromising on quality, ensuring you get the best value for your investment.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Example color
                                fontFamily: 'Roboto', // Example font family
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
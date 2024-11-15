// terms_and_conditions.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Terms and Conditions',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite, // Ensures it takes the max width
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to KNC PRINTZ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using the KNC PRINTZ website and mobile application (the "Service") operated by KNC PRINTZ ("us", "we", or "our").',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Definitions
              Text(
                'Definitions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'For the purposes of these Terms, the following definitions shall apply:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              _buildDefinition('Service', 
                'means the KNC PRINTZ website and mobile application operated by KNC PRINTZ.'),
              _buildDefinition('User', 
                'means an individual accessing or using the Service, whether or not they have registered with the Service.'),
              _buildDefinition('Content', 
                'means any and all information, data, text, software, music, sound, photographs, graphics, video, messages, or other materials that are uploaded, posted, transmitted, or otherwise made available via the Service.'),
              SizedBox(height: 24),
              // User Responsibilities
              Text(
                'User Responsibilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'As a User of the Service, you agree to:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              _buildUserResponsibility('Provide accurate and complete information when registering with the Service.'),
              _buildUserResponsibility('Maintain the confidentiality of your account password and access credentials.'),
              _buildUserResponsibility('Use the Service only for lawful purposes and in accordance with these Terms.'),
              _buildUserResponsibility('Not to use the Service in any way that could damage, disable, overburden, or impair the Service or interfere with any other party\'s use and enjoyment of the Service.'),
              _buildUserResponsibility('Not to use the Service to transmit any harmful, illegal, threatening, abusive, harassing, defamatory, obscene, or otherwise objectionable Content.'),
              _buildUserResponsibility('Not to use the Service to impersonate any person or entity, or to falsely state or misrepresent your affiliation with any person or entity.'),
              _buildUserResponsibility('Not to interfere with or disrupt the Service or servers or networks connected to the Service.'),
              _buildUserResponsibility('Not to violate any applicable local, state, national, or international law or regulation.'),
              SizedBox(height: 24),
              // Intellectual Property
              Text(
                'Intellectual Property',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The Service and its original Content (excluding Content provided by Users) are and shall remain the exclusive property of KNC PRINTZ and its licensors. The Service is protected by copyright, trademark, and other laws of both the United States and foreign countries.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Termination
              Text(
                'Termination',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We may terminate or suspend access to the Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Disclaimer
              Text(
                'Disclaimer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your use of the Service is at your own risk. The Service is provided "as is" and "as available". KNC PRINTZ disclaims all warranties of any kind, express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement, or course of performance. KNC PRINTZ does not warrant that the Service will be uninterrupted or error-free, that defects will be corrected, or that the Service is free of viruses or other harmful components.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Limitation of Liability
              Text(
                'Limitation of Liability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'In no event shall KNC PRINTZ, its directors, employees, partners, agents, suppliers, or licensors be liable for any direct, indirect, incidental, special, consequential, or punitive damages, including, but not limited to, loss of use, data, or profits, arising out of or in any way connected with the use of the Service, whether based on contract, tort, negligence, strict liability, or otherwise, even if KNC PRINTZ has been advised of the possibility of such damages.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Governing Law
              Text(
                'Governing Law',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'These Terms shall be governed and construed in accordance with the laws of [State, Country], without regard to its conflict of law provisions.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Entire Agreement
              Text(
                'Entire Agreement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'These Terms constitute the entire agreement between you and KNC PRINTZ regarding your use of the Service and supersede all prior or contemporaneous communications and proposals, whether oral or written, between you and KNC PRINTZ (including, but not limited to, any prior versions of the Terms).',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Severability
              Text(
                'Severability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms shall remain in effect.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 24),
              // Contact Us
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'If you have any questions about these Terms, please contact us:\n\nKNC PRINTZ\nkncprintz@gmail.com\n0917 312 1564',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDefinition(String term, String definition) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.circleCheck,
          size: 16,
          color: Colors.green,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '"$term" $definition',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserResponsibility(String responsibility) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.circleCheck,
          size: 16,
          color: Colors.green,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            responsibility,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    );
  }
}

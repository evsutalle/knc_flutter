import 'package:flutter/material.dart';
import 'TrackOrdersPage.dart';
import 'ProfilePage.dart';
import 'home_page.dart';
import 'OrdersPage.dart';
import 'TshirtPage.dart';
import 'TarpaulinPage.dart';
import 'JerseyPage.dart';
import 'SouvenirPage.dart';
import 'SignagePage.dart';
import 'StickerPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServicesPage extends StatelessWidget {
  final String userId;

  const ServicesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Offered', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFFFF7FC),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildCategoryCard(context, 'Jersey', FontAwesomeIcons.basketball, (context) => JerseyPage(userId: userId)),
            _buildCategoryCard(context, 'Souvenir', FontAwesomeIcons.gift, (context) => SouvenirPage(userId: userId)),
            _buildCategoryCard(context, 'Signage', FontAwesomeIcons.photoFilm, (context) => SignagePage(userId: userId)),
            _buildCategoryCard(context, 'Tshirt', FontAwesomeIcons.print, (context) => TshirtPage(userId: userId)),
            _buildCategoryCard(context, 'Sticker', FontAwesomeIcons.borderAll, (context) => StickerPage(userId: userId)),
            _buildCategoryCard(context, 'Tarpaulin', FontAwesomeIcons.file, (context) => TarpaulinPage(userId: userId)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Widget Function(BuildContext) pageBuilder) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: pageBuilder)),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home, 'page': HomePage(userId: userId)},
      {'icon': Icons.list_alt, 'page': OrdersPage(userId: userId)},
      {'icon': Icons.local_offer, 'page': ServicesPage(userId: userId)},
      {'icon': Icons.track_changes, 'page': TrackOrdersPage(userId: userId)},
      {'icon': Icons.person, 'page': ProfilePage(userId: userId)},
    ];

    return BottomAppBar(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.map((item) {
            return IconButton(
              icon: Icon(item['icon'], color: Colors.black),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => item['page']),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:login/Pages/Reports/RetailerEntry.dart';
import 'package:login/Pages/Reports/order_update.dart';
import 'app_links.dart';
import 'package:login/Logic/QR_scanner.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: [
            Container(
              height: 90, // Adjust height to reduce size
              color: const Color.fromARGB(255, 27, 104, 236),
              alignment: Alignment.center, // Center the text
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildSidebarMenu(context, 'Transactions', transactionLinks),
            _buildSidebarMenu(context, 'Reports', reportLinks),
            _buildSidebarMenu(context, 'Masters', masterLinks),
            _buildSidebarMenu(context, 'Miscellaneous', miscLinks),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarMenu(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> links,
  ) {
    return ExpansionTile(
      title: Padding(
        padding:
            const EdgeInsets.only(left: 16.0), // Shift the title slightly right
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Set the title color to black
            fontWeight: FontWeight.bold, // Bold the title
          ),
        ),
      ),
      children: links.map<Widget>((link) {
        return _buildSubMenu(context, link);
      }).toList(),
    );
  }

  Widget _buildSubMenu(BuildContext context, Map<String, dynamic> link) {
    return PopupMenuButton<String>(
      offset: const Offset(150, 0), // Adjust the dropdown position to the right
      child: Padding(
        padding: const EdgeInsets.only(
            left: 30.0), // Shift submenu items slightly right
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              link['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right:
                      30.0), // Adjust the arrow position slightly to the left
              child: const Icon(Icons.arrow_right, size: 16),
            ),
          ],
        ),
      ),
      onSelected: (value) {
        if (value == 'Rural Retailer Entry/Update') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RetailerRegistrationPage()),
          );
        } else if (value == 'Token Scan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrCodeScanner()),
          );
        } else if (value == 'Order Update') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderUpdate()),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$value clicked')));
        }
      },
      itemBuilder: (context) => link['subLinks']
          .map<PopupMenuItem<String>>((subLink) => PopupMenuItem<String>(
                value: subLink,
                child: Text('• $subLink'),
              ))
          .toList(),
    );
  }
}
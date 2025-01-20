import 'package:flutter/material.dart';
import 'package:login/Logic/QR_scanner.dart';
import 'package:login/Pages/ProfilePage/Addhar.dart';
import 'package:login/Pages/ProfilePage/view_oder.dart';
import 'package:login/Pages/content.dart';

import 'package:login/custom_app_bar/bottom_nav_bar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android;

    int _selectedIndex = 2;

    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContentPage()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QrCodeScanner()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    }

    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      endDrawer: const CustomSidebar(),
      body: Stack(
        children: [
          // Main content
          Container(
            color: Colors.grey.shade300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Static Heading bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: const Center(
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // My Profile Section
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade400,
                                  child: const Icon(Icons.person,
                                      size: 30, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Raghav',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '7340031941',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Chip(
                                            label: Text('Retailer'),
                                            backgroundColor:
                                                Colors.blue.shade100,
                                          ),
                                          SizedBox(width: 8),
                                          Chip(
                                            label: Text('38% Completed'),
                                            backgroundColor:
                                                Colors.red.shade100,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Edit Profile Clicked')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Account Section
                          const Text(
                            'Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAccountField(
                              context, 'Manage Orders', Icons.shopping_bag),
                          _buildAccountField(
                              context, 'Address Details', Icons.location_on),
                          _buildAccountField(
                              context, 'Manage Bank', Icons.account_balance),
                          _buildAccountField(context, 'Manage UPI',
                              Icons.account_balance_wallet),
                          _buildAccountField(
                              context, 'KYC Details', Icons.vpn_key),
                          _buildAccountField(
                              context, 'Misc. Details', Icons.settings),
                          const SizedBox(height: 32),
                          // Language Section
                          const Text(
                            'Language',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAccountField(
                              context, 'Select Language', Icons.language,
                              trailing: const Text('English')),
                          const SizedBox(height: 32),
                          // About Us Section
                          const Text(
                            'About Us',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAccountField(
                              context, 'View About Us', Icons.info),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Floating Bottom Navigation Bar
          if (isMobile)
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color:
                      Colors.transparent, // Ensure no background blocks content
                  child: CustomBottomNavigationBar(
                    currentIndex: _selectedIndex,
                    onItemTapped: (index) {
                      _onItemTapped(index);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccountField(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Manage Orders') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageOrderPage(),
            ),
          );
        } else if (title == 'KYC Details') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AadharCardKYCPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title Clicked')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
          ],
        ),
      ),
    );
  }
}
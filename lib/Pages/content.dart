import 'package:flutter/material.dart';
import 'package:login/Pages/ProfilePage/Profile.dart';
import 'package:login/Pages/Reports/RetailerEntry.dart';
import 'package:login/Logic/carousal.dart';

import 'package:login/custom_app_bar/bottom_nav_bar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';

import 'package:login/Logic/QR_scanner.dart';

import 'package:flutter/foundation.dart';

void main() {
  runApp(const ContentPage());
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android
          ? const HomeMobile()
          : const HomePage(),
    );
  }
}

class AppConfig {
  static const double smallScreenBreakpoint = 800.0;

  // Box padding
  static const double boxPadding = 16.0;

  // Default box styles
  static const double borderRadius = 8.0;
  static const double shadowBlurRadius = 6.0;
  static const double shadowSpreadRadius = 2.0;

  // Colors
  static const Color boxBackgroundColor = Colors.white;
  static const Color boxShadowColor = Colors.black26;
  static const Color borderColor = Colors.grey;

  // Font sizes
  static const double titleFontSize = 16.0;
  static const double valueFontSize = 12.0;

  // Hardcoded values
  static const Map<String, List<String>> boxContents = {
    'Credit Limit': [
      'Credit Limit: 0',
      'Open Billing: 0',
      'Open Order: 0',
    ],
    'Primary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0',
    ],
    'Secondary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0',
    ],
    'My Network': [
      'Total Unique Billed: 0',
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0',
    ],
  };
}

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int selectedIndex = 0;

    void onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContentPage()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QrCodeScanner()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    }

    return Scaffold(
      appBar:  CustomAppBar(),
      endDrawer: const CustomSidebar(),
      body: Container(
        color: Colors.blue.shade600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static Heading bar
            Container(
              padding: const EdgeInsets.all(AppConfig.boxPadding),
              color: AppConfig.boxBackgroundColor,
              child: const Center(
                child: Text(
                  'Birla White',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carousel with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: AppConfig.boxPadding,
                      ),
                      child: const CustomCarousel(),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Boxes layout for mobile
                          Column(
                            children: AppConfig.boxContents.entries
                                .map((entry) => _buildBox(
                                      title: entry.key,
                                      values: entry.value,
                                      height: screenHeight / 4,
                                      width: screenWidth,
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 16),

                          // Quick Menu for mobile
                          _buildQuickMenu(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight / 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
        onItemTapped: (index) {
          selectedIndex = index;
          onItemTapped(index);
        },
      ),
    );
  }

  // Widget for building individual boxes
  Widget _buildBox({
    required String title,
    required List<String> values,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: AppConfig.boxPadding),
      decoration: BoxDecoration(
        color: AppConfig.boxBackgroundColor,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppConfig.boxShadowColor,
            blurRadius: AppConfig.shadowBlurRadius,
            spreadRadius: AppConfig.shadowSpreadRadius,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConfig.boxPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppConfig.titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.auto_graph, size: 80, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: values.length,
              itemBuilder: (context, index) {
                final valueParts = values[index].split(':');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.remove,
                          size: 16, color: Colors.grey), // Dash-like icon
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          valueParts[0].trim(),
                          style: const TextStyle(
                            fontSize: AppConfig.valueFontSize,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          valueParts[1].trim(),
                          style: const TextStyle(
                            fontSize: AppConfig.valueFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for building the quick menu
  Widget _buildQuickMenu({
    required double screenWidth,
    required double screenHeight,
  }) {
    final iconNames = [
      'Retailer Registration',
      'Order History',
      'Sales Report',
      'Inventory',
      'Settings',
      'Help Center',
      'Customer Support',
      'Analytics',
      'Promotions',
      'Account Management',
      'Delivery Status',
      'Feedback',
    ];

    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: iconNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (iconNames[index] == 'Retailer Registration') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RetailerRegistrationApp(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.analytics,
                            size: 36, color: Colors.black),
                        const SizedBox(height: 8),
                        Text(
                          iconNames[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < AppConfig.smallScreenBreakpoint;

    return Scaffold(
      appBar:  CustomAppBar(),
      endDrawer: const CustomSidebar(),
      body: Container(
        color: Colors.blue.shade600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static Heading bar
            Container(
              padding: const EdgeInsets.all(AppConfig.boxPadding),
              color: AppConfig.boxBackgroundColor,
              child: const Center(
                child: Text(
                  'Birla White',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carousel with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: AppConfig.boxPadding,
                      ),
                      child: const CustomCarousel(),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(AppConfig.boxPadding),
                      child: Column(
                        children: [
                          // Boxes layout adjustment based on screen size
                          if (isSmallScreen)
                            Column(
                              children: AppConfig.boxContents.entries
                                  .map((entry) => _buildBox(
                                        title: entry.key,
                                        values: entry.value,
                                        height: (screenHeight / 2) -
                                            (AppConfig.boxPadding * 2),
                                        width: screenWidth,
                                      ))
                                  .toList(),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: AppConfig.boxContents.entries
                                  .map((entry) => _buildBox(
                                        title: entry.key,
                                        values: entry.value,
                                        width: (screenWidth / 4) -
                                            (AppConfig.boxPadding * 2),
                                        height: screenHeight / 2,
                                      ))
                                  .toList(),
                            ),

                          const SizedBox(height: 16),

                          // Quick Menu layout adjustment based on screen size
                          if (isSmallScreen)
                            _buildQuickMenu(
                              isSmallScreen: isSmallScreen,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            )
                          else
                            _buildQuickMenu(
                              isSmallScreen: isSmallScreen,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building individual boxes
  Widget _buildBox({
    required String title,
    required List<String> values,
    double? width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: AppConfig.boxPadding),
      decoration: BoxDecoration(
        color: AppConfig.boxBackgroundColor,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppConfig.boxShadowColor,
            blurRadius: AppConfig.shadowBlurRadius,
            spreadRadius: AppConfig.shadowSpreadRadius,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConfig.boxPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppConfig.titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Add Graph Icon
          const Center(
            child: Icon(Icons.auto_graph, size: 80, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          // Values below the graph icon
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: values.length,
              itemBuilder: (context, index) {
                final valueParts = values[index].split(':');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.remove,
                          size: 16, color: Colors.grey), // Dash-like icon
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          valueParts[0].trim(),
                          style: const TextStyle(
                            fontSize: AppConfig.valueFontSize,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          valueParts[1].trim(),
                          style: const TextStyle(
                            fontSize: AppConfig.valueFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget for building the quick menu
  Widget _buildQuickMenu({
    required bool isSmallScreen,
    required double screenWidth,
    required double screenHeight,
  }) {
    final iconNames = [
      'Retailer Registration',
      'Order History',
      'Sales Report',
      'Inventory',
      'Settings',
      'Help Center',
      'Customer Support',
      'Analytics',
      'Promotions',
      'Account Management',
      'Delivery Status',
      'Feedback',
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 0 : AppConfig.boxPadding * 2,
        top: AppConfig.boxPadding,
        bottom: AppConfig.boxPadding * 2,
      ),
      child: Align(
        alignment: isSmallScreen ? Alignment.center : Alignment.topLeft,
        child: Container(
          width: isSmallScreen
              ? double.infinity
              : screenWidth * 0.4, // Adjust width for larger screens
          height: screenHeight / 2, // Fixed height
          decoration: BoxDecoration(
            color: AppConfig.boxBackgroundColor,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppConfig.boxShadowColor,
                blurRadius: AppConfig.shadowBlurRadius,
                spreadRadius: AppConfig.shadowSpreadRadius,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppConfig.boxPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3x3 grid
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: iconNames.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (iconNames[index] == 'Retailer Registration') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RetailerRegistrationApp(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppConfig.borderColor),
                            borderRadius:
                                BorderRadius.circular(AppConfig.borderRadius),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.analytics,
                                  size: 36, color: Colors.black),
                              const SizedBox(height: 8),
                              Text(
                                iconNames[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
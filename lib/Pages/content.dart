import 'package:flutter/material.dart';
import 'package:login/Pages/ProfilePage/Profile.dart';
import 'package:login/Pages/ProfilePage/view_oder.dart';
import 'package:login/Pages/Reports/RetailerEntry.dart';
import 'package:login/Logic/carousal.dart';

import 'package:login/custom_app_bar/bottom_nav_bar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';

import 'package:login/Logic/QR_scanner.dart';

import 'package:flutter/foundation.dart';


import 'package:flutter/animation.dart';

void main() {
  runApp(const ContentPage());
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeMobile(),
    );
  }
}

class AppConfig {
  static const double smallScreenBreakpoint = 800.0;
  static const double boxPadding = 16.0;
  static const double borderRadius = 8.0;
  static const double shadowBlurRadius = 6.0;
  static const double shadowSpreadRadius = 2.0;
  static final Color boxBackgroundColor = Colors.blue.shade200;
  static const Color boxShadowColor = Colors.black26;
  static const Color borderColor = Colors.grey;
  static const double titleFontSize = 16.0;
  static const double valueFontSize = 12.0;
  static const Map<String, List<String>> boxContents = {
    'Credit Limit': ['Credit Limit: 0', 'Open Billing: 0', 'Open Order: 0'],
    'Primary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
    'Secondary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
    'My Network': [
      'Total Unique Billed: 0',
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
  };
}

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBase(
      isMobile: true,
      quickMenuItems: _quickMenuItems,
     orderItems: _orderItems,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBase(
      isMobile: false,
      quickMenuItems: _quickMenuItems,
      orderItems: _orderItems,
    );
  }
}

class HomeBase extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> quickMenuItems;
  final List<Map<String, dynamic>> orderItems;

  const HomeBase({
    required this.isMobile,
    required this.quickMenuItems,
    required this.orderItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < AppConfig.smallScreenBreakpoint;
    
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: AppConfig.boxPadding),
                          child: const CustomCarousel(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: AppConfig.boxPadding),
                          child: PointsWidget(),
                        ), // Add the PointsWidget here
                        _buildHorizontalQuickMenu(),
                        
                        _buildOrderCards(),
                        Padding(
                          padding: const EdgeInsets.all(AppConfig.boxPadding),
                          child: _buildBoxesLayout(isMobile, isSmallScreen,
                              screenWidth, screenHeight),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      _selectedIndex = index;
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.boxPadding),
      color: Colors.blue.shade50,
      child: const Center(
        child: Text(
          'Birla White',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBoxesLayout(bool isMobile, bool isSmallScreen,
      double screenWidth, double screenHeight) {
    final boxContents = AppConfig.boxContents.entries.map((entry) => _buildBox(
          title: entry.key,
          values: entry.value,
          width: isMobile || isSmallScreen
              ? screenWidth
              : (screenWidth / 4) - (AppConfig.boxPadding * 2),
          height: isMobile || isSmallScreen
              ? (screenHeight / (isSmallScreen ? 2 : 4)) - AppConfig.boxPadding
              : screenHeight / 2,
        ));
    return isMobile || isSmallScreen
        ? Column(children: boxContents.toList())
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: boxContents.toList());
  }

  Widget _buildBox(
      {required String title,
      required List<String> values,
      required double width,
      required double height}) {
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
                  color: Colors.black),
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
                      const Icon(Icons.remove, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          valueParts[0].trim(),
                          style: const TextStyle(
                              fontSize: AppConfig.valueFontSize,
                              color: Colors.black54),
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
                              color: Colors.black),
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

  Widget _buildHorizontalQuickMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Menu',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickMenuItems.length,
              itemBuilder: (context, index) {
                final item = quickMenuItems[index];
                return GestureDetector(
                  onTap: () => _handleQuickMenuItemTap(context, item['label']),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 36,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['label'].replaceAll(' ', '\n') as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
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

  void _handleQuickMenuItemTap(BuildContext context, String label) {
    if (label == 'Retailer Registration') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RetailerRegistrationApp()),
      );
    } else if (label == 'Order History') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManageOrderPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label clicked')),
      );
    }
  }
}

final List<Map<String, dynamic>> _quickMenuItems = [
  {'icon': Icons.app_registration, 'label': 'Retailer Registration'},
  {'icon': Icons.history, 'label': 'Order History'},
  {'icon': Icons.bar_chart, 'label': 'Sales Report'},
  {'icon': Icons.inventory, 'label': 'Inventory'},
  {'icon': Icons.settings, 'label': 'Settings'},
  {'icon': Icons.help, 'label': 'Help Center'},
  {'icon': Icons.support_agent, 'label': 'Customer Support'},
  {'icon': Icons.analytics, 'label': 'Analytics'},
  {'icon': Icons.campaign, 'label': 'Promotions'},
  {'icon': Icons.account_circle, 'label': 'Account Management'},
  {'icon': Icons.local_shipping, 'label': 'Delivery Status'},
  {'icon': Icons.feedback, 'label': 'Feedback'},
];


class PointsWidget extends StatefulWidget {
  const PointsWidget({super.key});

  @override
  _PointsWidgetState createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<PointsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    final coins = 5000;
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: coins).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("backg.jpeg"),
          fit: BoxFit.cover
        ),
        
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Coin Image without circular shape
          Flexible(child: 
          Container(
            height: 50, // Adjust size to fill container
            width: 120, // Adjust size to fill container
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Center(
              child: Image(
                
                image: AssetImage('coin1.jpeg'),
                fit: BoxFit.cover, // Cover to fill the container
                height: 70,
                width: 120,
              ),
            ),
          ),),
          // Points Text with Dollar sign
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'MY POINTS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 8.0), // Space between text and dollar sign
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '\$', // Dollar sign inside circle
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    _animation.value.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          // Right Coin Image without circular shape
          Container(
            height: 75, // Adjust size to fill container
            width: 110, // Adjust size to fill container
            decoration: BoxDecoration(
              color: Colors.transparent, // Transparent background
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Center(
              child: Image(
                image: AssetImage('coin2.jpeg'),
                fit: BoxFit.cover, // Cover to fill the container
                height: 50,
                width: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _orderItems=[

        {
          'title': 'Order 1',
          'status': '1',
          'trackingNumber': '#2548658',
          'orderNumber': '12345777',
          'warehouse': 'Warehouse',
          'date': '11/16/2024',
        },
        {
          'title': 'Order 2',
          'status': '3',
          'trackingNumber': '#2548659',
          'orderNumber': '12345778',
          'warehouse': 'Warehouse',
          'date': '11/16/2024',
        },
        {
          'title': 'Order 3',
          'status': '2',
          'trackingNumber': '#2548660',
          'orderNumber': '12345779',
          'warehouse': 'Warehouse',
          'date': '11/16/2024',
        },
      ];


Widget orderCard(int index) {
  // Get the item from _orderItems using the index
  final orderData = _orderItems[index];
  
  return Container(
    width: 300,
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.blue.shade200,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row( children: [ Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            'Tracking number',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: button1(int.parse(orderData['status'])), // Convert status string to int
        ),]),
        const SizedBox(height: 8.0),
      Text(
      orderData['trackingNumber'], // Use tracking number from data
      style: const TextStyle(
        color: Color.fromARGB(255, 59, 88, 255),
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      ),
      const SizedBox(height: 16.0),
      Row(
      children: [
        const Icon(
        Icons.person,
        color: Colors.white,
        size: 20.0,
        ),
        const SizedBox(width: 8.0),
        Text(
        orderData['orderNumber'], // Use order number from data
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        ),
        const Spacer(),
        Text(
        orderData['date'], // Use date from data
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
        ),
      ],
      ),
      const SizedBox(height: 8.0),
      Row(
      children: [
        const Icon(
        Icons.warehouse,
        color: Colors.white,
        size: 20.0,
        ),
        const SizedBox(width: 8.0),
        Text(
        orderData['warehouse'], // Use warehouse from data
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        ),
        const Spacer(),
        Text(
        orderData['date'], // Use date from data
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
        ),
      ],
      ),
  ]
  ));
  }
  
 Widget _buildOrderCards() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Orders Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
            height: 150, // Increased height
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                _orderItems.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  width: 280,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: orderCard(index),
                  ),
                ),
              ),
            ),
          
        ),
      ],
    ),
  );


}
  Widget button1(int n) {
  String buttonText;
  Color buttonColor;

  switch (n) {
    case 1:
      buttonText = 'Pending';
      buttonColor = Colors.orange;
      break;
    case 2:
      buttonText = 'Completed';
      buttonColor = Colors.blue;
      break;
    case 3:
      buttonText = 'Approved';
      buttonColor = Colors.green;
      break;
    default:
      buttonText = 'Pending';
      buttonColor = Colors.orange;
  }

  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
    ),
    child: Text(
      buttonText,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


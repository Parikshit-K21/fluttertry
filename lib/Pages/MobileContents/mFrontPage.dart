import 'dart:io';
import 'package:flutter/material.dart';

import '../Orders/view_oder.dart';
import '../Reports/RetailerEntry.dart';

class Mfrontpage extends StatefulWidget {
  const Mfrontpage({Key? key}) : super(key: key);

  @override
  State<Mfrontpage> createState() => _MfrontpageState();
}

class _MfrontpageState extends State<Mfrontpage> {
  late ScrollController _scrollController;
  double _scrollControllerOffset = 0.0;

  _scrollListener() {
    setState(() {
      _scrollControllerOffset = _scrollController.offset;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FadeAppBar(scrollOffset: _scrollControllerOffset),
  backgroundColor: const Color(0xff123456),
  body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.white,
      // image: DecorationImage(
      //   image: AssetImage('assets/backg.jpeg'),
      //   fit: BoxFit.cover,
      // ),
    ),
    child: Container(
      
      
          child: Column(
            children: [
              // Quick Menu Section
              buildHorizontalQuickMenu()
                 
            ],
          ),
        ),
    
  ),
);

  }
}

class FadeAppBar extends StatelessWidget  implements PreferredSizeWidget{
  final double scrollOffset;
  
  const FadeAppBar({Key? key, required this.scrollOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = "Admin";
    return SafeArea(
  top: false,
  child: Container(
    height: 130, // Adjust height as needed to accommodate both rows
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    color: Colors.blue.shade200.withOpacity((scrollOffset / 400).clamp(0, 1).toDouble()),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start, // Align items at the start
      children: [
        // First Row with Company Logo and Profile Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items in a row
          children: [
            // Company Logo
            Container(
              child: Image.asset(
                'assets/BWlogo.jpeg', 
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 20), 

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between children
                children: [
                  // Text on the left
                  Text(
                    "Welcome Back, $a", 
                    style: const TextStyle(
                      color: Color.fromARGB(255, 30, 84, 235), 
                      fontSize: 15, 
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  // IconButton on the right
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white), // Profile icon
                    onPressed: () {
                      // Handle profile button press
                      print("Profile icon pressed");
                    },
                  ),
                ],
              )

          ],
        ),
        const SizedBox(height: 10), // Space between the rows
        // Search Input Widget
        const Flexible(child: SearchInput()), // Search input below the icons
      ],
    ),
  ),
);

  }
  @override
  Size get preferredSize => const Size.fromHeight(130); // Set preferred height for app bar
}


class SearchInput extends StatelessWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          spreadRadius: 0,
          color: Colors.grey.withOpacity(.1),
        ),
      ]),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon:
              const Icon(Icons.search, size: 20, color: Color(0xffFF5A60)),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for reports, orders, etc.',
          hintStyle:
              TextStyle(color: Colors.black.withOpacity(.40)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          border:
              const OutlineInputBorder(borderRadius:
                  BorderRadius.all(Radius.circular(15.0))),
          enabledBorder:
              const OutlineInputBorder(borderSide:
                  BorderSide(color:
                      Colors.white, width:
                      1.0),
                  borderRadius:
                  BorderRadius.all(Radius.circular(15.0))),
          focusedBorder:
              const OutlineInputBorder(borderSide:
                  BorderSide(color:
                      Colors.white, width:
                      2.0),
                  borderRadius:
                  BorderRadius.all(Radius.circular(15.0))),
        ),
        onChanged:(value) {},
      ));
   }
}

final List<Map<String, dynamic>> quickMenuItems = [
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

void handleQuickMenuItemTap(BuildContext context, String label) {
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

 Widget buildHorizontalQuickMenu() {
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
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: GridView.builder(
               
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Set to 4 items per row
              childAspectRatio: 1, // Make items square
            ),
              itemCount:quickMenuItems.length , 
              itemBuilder: (context, index) {
                final item = quickMenuItems[index];
                return GestureDetector(
                  onTap: () => handleQuickMenuItemTap(context, item['label']),
                  
                    child:  Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          
                        ),
                        child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the icon in the circle
                children: [
                  Icon(
                    item['icon'] as IconData, // Assuming 'icon' is part of the item map
                    size: 36,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 4), // Space between icon and label
                  Text(
                    item['label'].replaceAll(' ', '\n'), // Replace spaces with newlines for better formatting
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                      ),
                      
                    ],
                      ),
                      )
                    );
             }),
          )
        ],
      ),
    );
    
  }
            
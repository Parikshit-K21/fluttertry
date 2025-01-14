

import 'package:flutter/material.dart';
import 'package:login/Modal/data.dart';
import 'package:login/Pages/ProfilePage/Profile.dart';
import 'package:login/Pages/Reports/RetailReg.dart';

import 'package:login/Pages/Reports/RetailerEntry.dart';
import 'package:login/Pages/content.dart';
import 'package:login/custom_app_bar/menuChange.dart';
import 'package:login/Pages/Reports/order_update.dart';
import 'package:login/Logic/QR_scanner.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {

late String? selectedRole = 'user';
final List<String> roles = ['user', 'admin'];
  
  
  // Role-specific menu data
var adminMenu = menuData;

// Use user menu  
var userMenu = menuData2;
  late final Map<String, Map<String, dynamic>> roleMenuData;
@override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  void _loadMenuData() {
    setState(() {
      // Force reload menu data from data.dart
      adminMenu = menuData;
      userMenu = menuData2;
      roleMenuData = {
        'admin': adminMenu,
        'user': userMenu,
      };
    });
  }


 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reload when returning to this page
      if (mounted) _loadMenuData();
    });
  }


  Map<String, dynamic> get currentMenuData => 
    roleMenuData[selectedRole ?? 'user'] ?? roleMenuData['user']!;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
//will cause your widget to rebuild automatically whenever that specific property changes.
    return AppBar(
      backgroundColor: Colors.blueAccent,
      flexibleSpace: GestureDetector(
        onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const ContentPage()),
        //   );
        },
        
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
    child: Expanded(
        child: DropdownButton<String>(
          dropdownColor: Colors.blue,
          value: selectedRole ?? 'user',
          
          hint: const Text(
            'Select Role',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          icon: const Icon(Icons.person, color: Colors.white),
          underline: Container(),
          items: roles.map<DropdownMenuItem<String>>((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                role,
                style: TextStyle(
                  color: selectedRole == role ? Colors.red : Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedRole = newValue!;
            });
          },
        ),
      ),
      ),
      title: screenWidth > 800
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    _buildMenu(context, 'Transactions', currentMenuData['transactionLinks'] ?? []),
                    _buildMenu(context, 'Reports', currentMenuData['reportLinks'] ?? []),
                    _buildMenu(context, 'Master', currentMenuData['masterLinks'] ?? []),
                    _buildMenu(context, 'Misc', currentMenuData['miscLinks'] ?? []),
                  ],
            )
          : null,
          
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.list, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Open right sidebar
          },
        ),
        IconButton(
          icon: const Icon(Icons.update_rounded, color: Colors.white),
          hoverColor: const Color.fromARGB(255, 5, 50, 87),
         
          onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuManagementPage2(jsonData: currentMenuData, roleName: selectedRole!,)),
            );},
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ],
    );
  }
  


  Widget _buildMenu(BuildContext context, String title, List items) {
  return PopupMenuButton<String>(
    tooltip: title,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
    itemBuilder: (context) => items.map<PopupMenuEntry<String>>((item) {
      if (item is Map<String, dynamic>) {
        return PopupMenuItem<String>(
          child: PopupMenuButton<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['title']),
                const Icon(Icons.arrow_right, size: 16),
              ],
            ),
            itemBuilder: (context) => 
              (item['subLinks'] as List).map<PopupMenuItem<String>>((subLink) =>
                PopupMenuItem<String>(
                  value: subLink,
                  child: Text(subLink),
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () {
                        if (subLink == 'Rural Retailer Entry/Update') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RetailerRegistrationApp(),
                            ),
                          );
                        } else if (subLink == 'Token Scan') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QrCodeScanner(),
                            ),
                          );
                          } else if (subLink == 'Retailer Registration') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RetailReg(),
                            ),
                          );
                        } else if (subLink == 'Order Update') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderUpdate(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: $subLink')),
                          );
                      }}
                    );
                  },
                ),
              ).toList(),
          ),
        );
      }
              return PopupMenuItem<String>(
                value: item.toString(),
                child: Text(item.toString()),
              );
            }).toList(),
          );
}

 
  @override
  Size get preferredSize => const Size.fromHeight(70);
}


class MenuItem {
  final String title;
  final List<String> subLinks;

  MenuItem({required this.title, required this.subLinks});
}

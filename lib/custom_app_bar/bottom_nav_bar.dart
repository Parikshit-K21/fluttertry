import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 100.0, // Increase height for more space
        margin: const EdgeInsets.only(
            bottom: 10.0,
            left: 10.0,
            right: 10.0), // Add bottom margin to give the "hanging" effect
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
            bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0, 3), // Shadow for the hanging effect
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: currentIndex,
          iconSize: 30.0, // Increase the size of the icons
          selectedFontSize: 16.0, // Larger font for selected items
          unselectedFontSize: 14.0, // Font size for unselected items
          selectedItemColor: Colors.purple,
          backgroundColor: Colors
              .transparent, // Transparent background for the bottom bar itself
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold), // Bold text for selected
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500), // Semi-bold text for unselected
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
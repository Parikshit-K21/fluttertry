import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70.0,
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100, // White background for the bar
          borderRadius: BorderRadius.circular(25.0), // Rounded edges
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow for the bar
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none, // Allows floating QR icon
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Icon
                  GestureDetector(
                    onTap: () => onItemTapped(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: currentIndex == 0 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color:
                                currentIndex == 0 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer for QR scanner
                  const SizedBox(width: 70.0),
                  // Profile Icon
                  GestureDetector(
                    onTap: () => onItemTapped(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: currentIndex == 2 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                            color:
                                currentIndex == 2 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Floating QR Scanner Icon
            Positioned(
              top: -10.0,
              bottom: -10, // Floating effect
              left: MediaQuery.of(context).size.width / 2 - 80,
              child: GestureDetector(
                onTap: () => onItemTapped(1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color of floating button
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: currentIndex == 1 ? Colors.white : Colors.black,
                    size: 60.0, // Ensures the QR icon size is consistent
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
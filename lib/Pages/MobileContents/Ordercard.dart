import 'package:flutter/material.dart';
import 'package:login/Pages/Orders/orderTrack.dart';

final List<Map<String, dynamic>> orderItems=[

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



Widget orderCard(int index, BuildContext context) {
  // Get the item from _orderItems using the index
  final orderData = orderItems[index];
  
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
          child: button1(context,int.parse(orderData['status'])), // Convert status string to int
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
  
 Widget buildOrderCards(BuildContext context) {
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
                orderItems.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  width: 280,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: orderCard(index, context),
                  ),
                ),
              ),
            ),
          
        ),
      ],
    ),
  );


}
  Widget button1(BuildContext context, int n) {
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
    onPressed: () { 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderTimelineScreen(n: n)),
      );
    },
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

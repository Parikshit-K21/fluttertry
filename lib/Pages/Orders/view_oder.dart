import 'package:flutter/material.dart';
import 'package:login/Logic/globals.dart' as global_state;

class ManageOrderPage extends StatelessWidget {
  const ManageOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the global productList 
    List<Map<String, dynamic>> productList = global_state.productList;

    // Group products by scheduleDate
    Map<String, List<Map<String, dynamic>>> groupedByDate = {};

    for (var product in productList) {
      if (product['scheduleDate'] != null) {
        if (groupedByDate.containsKey(product['scheduleDate'])) {
          groupedByDate[product['scheduleDate']]?.add(product);
        } else {
          groupedByDate[product['scheduleDate']] = [product];
        }
      }
    }

    // Calculate total outstanding amount
    double totalOutstanding = 0;
    for (var product in productList) {
      if (product['qty'] != null && product['qty'] != '') {
        double qty = double.parse(product['qty']);
        double kg = _extractKgFromProduct(product['product']);
        double price = kg * 1000 * qty; // Price per product
        totalOutstanding += price;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.teal.shade50, // Background color for the full page
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[700],
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Outstanding:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${totalOutstanding.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groupedByDate.keys.length,
                itemBuilder: (context, index) {
                  String date = groupedByDate.keys.elementAt(index);
                  List<Map<String, dynamic>> products = groupedByDate[date]!;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple, // Border color
                        width: 2, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scheduled Date: $date',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...products.map((product) {
                            double qty = double.parse(product['qty'] ?? '0');
                            double kg =
                                _extractKgFromProduct(product['product']);
                            double price = kg * 1000 * qty;

                            return ListTile(
                              title: Text('${product['product']}'),
                              subtitle: Text(
                                  'Qty: $qty, ₹${price.toStringAsFixed(2)}'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _extractKgFromProduct(String productName) {
    final regex = RegExp(r'(\d+)\s*kg');
    final match = regex.firstMatch(productName);
    return match != null ? double.parse(match.group(1)!) : 0.0;
  }
}
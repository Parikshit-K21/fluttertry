import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

int _scannedCount = 0; // Global variable to track scan count

void main() {
  runApp(const QrCodeScanner());
}

class QrCodeScanner extends StatelessWidget {
  const QrCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(),
      endDrawer: const CustomSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Token Scan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Token Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 24),   
            Text(
              'Scan Count: $_scannedCount',
              style: const TextStyle(fontSize: 16),
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // Dark blue shade
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    final scannedValue = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QrCodeScannerPage(),
                      ),
                    );

                    if (scannedValue != null) {
                      setState(() {
                        _tokenController.text = scannedValue;
                       _scannedCount += 10; // Increase count by 10 on successful scan

                      });
                    }
                  },
                  child: const Text(
                    'Scan Token',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

class QrCodeScannerPage extends StatelessWidget {
  QrCodeScannerPage({super.key});

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning...'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final barcode = barcodes.first;

              if (barcode.rawValue != null) {
                await controller
                    .stop()
                    .then((value) => controller.dispose())
                    .then(
                        (value) => Navigator.of(context).pop(barcode.rawValue));
              }
            },
          ),
          Center(
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

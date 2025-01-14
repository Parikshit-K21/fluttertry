import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AadharCardKYCPage extends StatefulWidget {
  const AadharCardKYCPage({super.key});

  @override
  _AadharCardKYCPageState createState() => _AadharCardKYCPageState();
}

class _AadharCardKYCPageState extends State<AadharCardKYCPage> {
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  String? requestId;
  String? captchaImage;
  String? shareCode = "1234"; // Example Share Code
  bool isOtpSent = false;

  final String clientId = "test-client";
  final String clientSecret = "891707ee-d6cd-4744-a28d-058829e30f12";
  final String productInstanceId = "891707ee-d6cd-4744-a28d-058829e30f12";

  Future<void> generateOtp() async {
    const String url = "https://dg-sandbox.setu.co/api/okyc";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "x-client-id": clientId,
        "x-client-secret": clientSecret,
        "x-product-instance-id": productInstanceId,
      },
      body: json.encode({"redirectURL": "https://setu.co"}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        requestId = data['id'];
        isOtpSent = true;
      });
      print("Request ID: $requestId");
    } else {
      print("Failed to create OKYC request: ${response.body}");
    }
  }

  Future<void> initiateRequest() async {
    if (requestId == null) return;

    final String url =
        "https://dg-sandbox.setu.co/api/okyc/$requestId/initiate";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-client-id": clientId,
        "x-client-secret": clientSecret,
        "x-product-instance-id": productInstanceId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        captchaImage = data['captchaImage'];
      });
      print("Captcha Image Received");
    } else {
      print("Failed to initiate request: ${response.body}");
    }
  }

  Future<void> verifyOtp() async {
    if (requestId == null || aadharController.text.isEmpty) return;

    final String url = "https://dg-sandbox.setu.co/api/okyc/$requestId/verify";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "x-client-id": clientId,
        "x-client-secret": clientSecret,
        "x-product-instance-id": productInstanceId,
      },
      body: json.encode({
        "aadhaarNumber": aadharController.text,
        "captchaCode": captchaController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("OTP Verified Successfully");
    } else {
      print("Failed to verify OTP: ${response.body}");
    }
  }

  Future<void> completeKYC() async {
    if (requestId == null || otpController.text.isEmpty) return;

    final String url =
        "https://dg-sandbox.setu.co/api/okyc/$requestId/complete";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "x-client-id": clientId,
        "x-client-secret": clientSecret,
        "x-product-instance-id": productInstanceId,
      },
      body: json.encode({
        "otp": otpController.text,
        "shareCode": shareCode,
        "aadhaarNumber": aadharController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("KYC Completed: ${data['aadhaar']}");
    } else {
      print("Failed to complete KYC: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aadhar Card KYC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Aadhar Card Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: aadharController,
                decoration: const InputDecoration(
                  labelText: 'Aadhar Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Aadhar Number',
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 150, // Set the width of the button
                  child: ElevatedButton(
                    onPressed: generateOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900], // Dark blue color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Generate OTP',
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                  ),
                ),
              ),
              if (isOtpSent) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: captchaController,
                  decoration: const InputDecoration(
                    labelText: 'Captcha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: verifyOtp,
                  child: const Text('Verify OTP'),
                ),
                ElevatedButton(
                  onPressed: completeKYC,
                  child: const Text('Complete KYC'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
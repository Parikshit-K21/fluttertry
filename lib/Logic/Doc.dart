import 'package:shared_preferences/shared_preferences.dart';

Future<String> generateDocuNumb(String year, String area, String product) async {
  final prefs = await SharedPreferences.getInstance();

  // Generate a unique key based on year, area, and product
  final key = '$year-$area-$product';

  // Get the current serial number or initialize it to 1
  int serialNumber = prefs.getInt(key) ?? 1;

  // Increment the serial number and save it
  prefs.setInt(key, serialNumber + 1);

  // Format the document number
  return '$year/$area/$product/${serialNumber.toString().padLeft(3, '0')}';
}

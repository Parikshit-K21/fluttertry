import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login/Modal/AreaHeir.dart';



class ApiService {
  static const String baseUrl = "http://localhost:5126/api/Control";

  Future<List<dynamic>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch data. Status Code: ${response.statusCode}");
    }
  }

  
Future<List<AreaHierarchy>> getAreas() async {
    final response = await http.get(Uri.parse("$baseUrl/areaLoc"));

    if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => AreaHierarchy(
      areaCode: data['AreaCode'],
      areaDesc: data['AreaDesc'],
      districtNames: List<String>.from(data['DistrictNames']),
    )).toList();
  } else {
    throw Exception("Failed to fetch data. Status Code: ${response.statusCode}");
  }
  }


  Future<List> getone(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch data. Status Code: ${response.statusCode}");
    }
  }

  Future<void> del(String id) async{

    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return  print("DELTED THE DATA");
    } else {
      throw Exception("Failed to fetch data. Status Code: ${response.statusCode}");
    }
  }


   Future<void> sendData(String doc, String processType,
                         String description, DateTime date, 
                          String meetingVenue, String location, 
                          String district, String pincode, String product) async {
  final url=baseUrl;
  final dateString = date.toIso8601String();

  final body = jsonEncode({
    'Doc': doc,
    'Area': pincode,
    'Loc': location,
    'Pro': processType,
    'Act': description,
    'Date': dateString,
    'Met': meetingVenue,
    'Dist': district,
    'Prod': product,
  });

  print(body);

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 201) {
    // Handle successful response
    print('Data sent successfully');
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
  }
}


  Future<List<String>> getDistinctValues(String columnName) async {
    final response = await http.get(Uri.parse("$baseUrl/distinct/$columnName"));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch distinct values for $columnName");
    }
  }
 
}


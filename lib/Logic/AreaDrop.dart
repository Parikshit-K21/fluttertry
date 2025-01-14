import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AreaDistrictDropdown extends StatefulWidget {
  final String apiUrlAreas; // API URL for fetching areas
  final String apiUrlDistricts; // API URL for fetching districts

  const AreaDistrictDropdown({
    super.key,
    required this.apiUrlAreas,
    required this.apiUrlDistricts,
  });

  @override
  State<AreaDistrictDropdown> createState() => _AreaDistrictDropdownState();
}

class _AreaDistrictDropdownState extends State<AreaDistrictDropdown> {
  List<dynamic> _areas = [];
  List<dynamic> _districts = [];
  String? _selectedAreaCode;

  Future<void> _fetchAreas() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrlAreas));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _areas = data;
        });
      } else {
        // Handle API error
        print('Failed to load areas: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching areas: $e');
    }
  }

  Future<void> _fetchDistricts(String areaCode) async {
    try {
      final response = await http.get(Uri.parse('${widget.apiUrlDistricts}/$areaCode'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _districts = data;
        });
      } else {
        // Handle API error
        print('Failed to load districts: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching districts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedAreaCode,
          onChanged: (newValue) async {
            setState(() {
              _selectedAreaCode = newValue;
            });
            await _fetchDistricts(newValue!); // Fetch districts for the selected area
          },
          items: _areas.map((area) {
            return DropdownMenuItem<String>(
              value: area['areaCode'],
              child: Text('${area['areaCode']} - ${area['areaDesc']}'),
            );
          }).toList(),
          decoration: InputDecoration(labelText: 'Select Area'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _districts.isNotEmpty ? _districts[0] : null,
          onChanged: (newValue) {
            // Handle district selection changes here
          },
          items: _districts.map((district) {
            return DropdownMenuItem<String>(
              value: district,
              child: Text(district),
            );
          }).toList(),
          decoration: InputDecoration(labelText: 'Select District'),
        ),
      ],
    );
  }
}
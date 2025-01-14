import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login/Control/ApiCon.dart';

import 'package:http/http.dart' as http;

class SearchTablePage extends StatefulWidget {
  const SearchTablePage({super.key});

  @override
  _SearchTablePageState createState() => _SearchTablePageState();
}

class _SearchTablePageState extends State<SearchTablePage> {
  ApiService api= ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _tableData = [];
  bool _isLoading = false;

  Future<void> _fetchTableData(String docuNumb) async {
    if (docuNumb.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:5126/api/Control/$docuNumb');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _tableData = data.map((item) => {
            "docuNumb": item["docuNumb"],
            "areaCode": item["areaCode"],
            "location": item["location"],
            "ProcesTp": item["ProcesTp"],
            "ActiDesc": item["ActiDesc"],
            "ObjADate": item["ObjADate"],
            "MeetgVen": item["MeetgVen"],
            "Distictd": item["Distictd"],
            "PRoduct": item["PRoduct"],
          }).toList();
        });
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAllData() async {
    setState(() {
      _isLoading = true;
    });

     final url = Uri.parse('http://localhost:5126/api/Control');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _tableData = data.map((item) => {
            "docuNumb": item["docuNumb"],
            "areaCode": item["areaCode"],
            "location": item["location"],
            "ProcesTp": item["ProcesTp"],
            "ActiDesc": item["ActiDesc"],
            "ObjADate": item["ObjADate"],
            "MeetgVen": item["MeetgVen"],
            "Distictd": item["Distictd"],
            "PRoduct": item["PRoduct"],
          }).toList();
        });} else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Table by DocuNumb'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter DocuNumb',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _fetchTableData(_searchController.text),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchAllData,
              child: Text('Show All Data'),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : _tableData.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
                            columns: [
                              DataColumn(label: Text('DocuNumb')),
                              DataColumn(label: Text('AreaCode')),
                              DataColumn(label: Text('Location')),
                              DataColumn(label: Text('ProcesTp')),
                              DataColumn(label: Text('ActiDesc')),
                              DataColumn(label: Text('ObjADate')),
                              DataColumn(label: Text('MeetgVen')),
                              DataColumn(label: Text('Distictd')),
                              DataColumn(label: Text('PRoduct')),
                            ],
                            rows: _tableData.map((row) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(row['docuNumb'] ?? '')),
                                  DataCell(Text(row['areaCode'] ?? '')),
                                  DataCell(Text(row['location'] ?? '')),
                                  DataCell(Text(row['ProcesTp'] ?? '')),
                                  DataCell(Text(row['ActiDesc'] ?? '')),
                                  DataCell(Text(row['ObjADate'] ?? '')),
                                  DataCell(Text(row['MeetgVen'] ?? '')),
                                  DataCell(Text(row['Distictd'] ?? '')),
                                  DataCell(Text(row['PRoduct'] ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        ),
                      )
                    : Text('No data found'),
          ],
        ),
      ),
    );
  }
}

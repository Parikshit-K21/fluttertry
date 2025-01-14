import 'dart:io';
import 'package:path/path.dart' as path;


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class MenuModel {
     String roleName;
     List<MenuItem> transactionLinks;
    List<MenuItem> reportLinks;
     List<MenuItem> masterLinks;
     List<String> miscLinks;

    MenuModel({
        required this.roleName,
        required this.transactionLinks,
        required this.reportLinks,
        required this.masterLinks,
        required this.miscLinks,
    });

    factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      roleName: json['roleName'] ?? '',
      transactionLinks: List<MenuItem>.from(
          (json['transactionLinks'] ?? []).map((e) => MenuItem.fromJson(e))),
      reportLinks: List<MenuItem>.from(
          (json['reportLinks'] ?? []).map((e) => MenuItem.fromJson(e))),
      masterLinks: List<MenuItem>.from(
          (json['masterLinks'] ?? []).map((e) => MenuItem.fromJson(e))),
      miscLinks: List<String>.from(json['miscLinks'] ?? []), // Handle as List<String>
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
      'transactionLinks': transactionLinks.map((item) => item.toJson()).toList(),
      'reportLinks': reportLinks.map((item) => item.toJson()).toList(),
      'masterLinks': masterLinks.map((item) => item.toJson()).toList(),
      'miscLinks': miscLinks, // Handle as List<String>
    };
  }
}

class MenuItem {
  final String title;
  final List<String> subLinks;

  MenuItem({required this.title, required this.subLinks});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      subLinks: List<String>.from(json['subLinks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subLinks': subLinks,
    };
  }
}


 

class MenuManagementPage2 extends StatefulWidget {
  final String roleName;
  final Map<String, dynamic> jsonData;

  MenuManagementPage2({required this.roleName, required this.jsonData});

  @override
  _MenuManagementPage2State createState() => _MenuManagementPage2State();
}
class _MenuManagementPage2State extends State<MenuManagementPage2> {
  late MenuModel _menuModel ;
  

  @override
  void initState() {
    super.initState();
    _menuModel = MenuModel.fromJson(widget.jsonData); // Use the passed data directly
  }

  Future<void> _delData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${widget.roleName}_menu');
  }
  Future<void> _showMenuData() async {
    String jsonData = jsonEncode(_menuModel.toJson());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Menu Data"),
          content: SingleChildScrollView(
            child: Text(jsonData),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  
 
 
  Future<void> _saveMenuData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${widget.roleName}_menu', jsonEncode(_menuModel.toJson()));
    data = prefs.getString('${widget.roleName}_menu');
  }
  String? data;
  
  
  Future<void> _loadMenuData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('${widget.roleName}_menu');

    if (jsonString != null) {
      setState(() {
        _menuModel = MenuModel.fromJson(jsonDecode(jsonString));
      });
    } else {
      setState(() {
        _menuModel = MenuModel(
          roleName: widget.roleName,
          transactionLinks: [],
          reportLinks: [],
          masterLinks: [],
          miscLinks: [],
        );
      });
    }

  }



Future<void> _saveToDataFile() async {
  try {
    // Get absolute path to data.dart
   final String projectPath = Directory.current.path;
    final String filePath = path.join(projectPath, 'lib', 'Modal', 'data.dart');
    final File file = File(filePath);
    
    // print('Current Directory Path: $path');
    // print('Full File Path: ${file.path}');
    // print('File exists: ${await file.exists()}');
    // Generate menu data string
    if (!await file.exists()) {
      throw FileSystemException('data.dart not found at: $filePath');
    }
    final menuDataString = '''
const Map<String, dynamic> ${widget.roleName == 'admin' ? 'menuData' : 'menuData2'} = 
${const JsonEncoder.withIndent('  ').convert(_menuModel.toJson())};
''';

    // Read existing content
    if (!await file.exists()) {
      throw Exception('data.dart not found');
    }
    
    String contents = await file.readAsString();
    
    // Update content based on role
    if (widget.roleName == 'admin') {
      int startIndex = contents.indexOf('const Map<String, dynamic> menuData =');
      int endIndex = contents.indexOf('const Map<String, dynamic> menuData2');
      
      if (startIndex == -1 || endIndex == -1) {
        throw Exception('Menu data section not found');
      }
      
      contents = contents.replaceRange(startIndex, endIndex, menuDataString);
    } else {
      int startIndex = contents.indexOf('const Map<String, dynamic> menuData2 =');
      int endIndex = contents.lastIndexOf('};') + 2;
      
      if (startIndex == -1) {
        throw Exception('Menu data2 section not found');
      }
      
      contents = contents.replaceRange(startIndex, endIndex, menuDataString);
    }

    // Write updated content
    await file.writeAsString(contents, mode: FileMode.write);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu data saved successfully')),
     );
    //  Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CustomAppBar(), // Replace with your main page
    //   ),
    // );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving menu data: $e')),
    );
  }
}

 

void _addTransactionLink(String title) {
    setState(() {
      // Ensure transactionLinks is initialized
      _menuModel.transactionLinks.add(MenuItem(title: title, subLinks: []));
    });
  }

  void _deleteTransactionLink(int index) {
    setState(() {
      _menuModel.transactionLinks.removeAt(index);
    });
  }

  void _addReportLink(String title) {
  setState(() {
    // Ensure reportLinks is initialized
    _menuModel.reportLinks.add(MenuItem(title: title, subLinks: []));
    _saveMenuData(); // Save after adding
  });
}

void _deleteReportLink(int index) {
  setState(() {
    if (_menuModel.reportLinks.isNotEmpty) { // Check if there are links before accessing
      _menuModel.reportLinks.removeAt(index);
      _saveMenuData(); // Save after deleting
    }
  });
}

void _addMasterLink(String title) {
  setState(() {
    // Ensure masterLinks is initialized
    _menuModel.masterLinks.add(MenuItem(title: title, subLinks: []));
    _saveMenuData(); // Save after adding
  });
}

void _deleteMasterLink(int index) {
    setState(() {
 // Check for null before accessing
      _menuModel.masterLinks.removeAt(index);
        });
}

void _addMiscLink(String title) {
    setState(() {
      _menuModel.miscLinks.add(title);
    });
}

void _deleteMiscLink(int index) {
    setState(() {
 // Check for null before accessing
      _menuModel.miscLinks.removeAt(index);
        });
}


  void _addSubLink(String linkType, int menuIndex, String newSubLink) {
  setState(() {
    // Add sub-link based on the type of link
    if (linkType == 'transaction') {
      _menuModel.transactionLinks[menuIndex].subLinks.add(newSubLink);
    } else if (linkType == 'report') {
      _menuModel.reportLinks[menuIndex].subLinks.add(newSubLink);
    } else if (linkType == 'master') {
      _menuModel.masterLinks[menuIndex].subLinks.add(newSubLink);
    } else if (linkType == 'misc') {
      _menuModel.miscLinks[menuIndex] = newSubLink;
    }
     _saveMenuData(); // Save after adding
  });
}

void _deleteSubLink(String linkType, int menuIndex, int subLinkIndex) {
  setState(() {
    // Delete sub-link based on the type of link
    if (linkType == 'transaction') {
      _menuModel.transactionLinks[menuIndex].subLinks.removeAt(subLinkIndex);
    } else if (linkType == 'report') {
      _menuModel.reportLinks[menuIndex].subLinks.removeAt(subLinkIndex);
    } else if (linkType == 'master') {
      _menuModel.masterLinks[menuIndex].subLinks.removeAt(subLinkIndex);
    } else if (linkType == 'misc') {
      _menuModel.miscLinks.removeAt(menuIndex);
    }
     _saveMenuData(); // Save after deleting
  });
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("${_menuModel.roleName} Menu")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Transaction Links Section
            const Text("Transaction Links", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ListView.builder(
              itemCount: (_menuModel.transactionLinks.length).clamp(0, 10), // Limit to max of 10
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final menuItem = _menuModel.transactionLinks[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(menuItem.title),
                    children: [
                      ...menuItem.subLinks.map<Widget>((subLink) => ListTile(
                        title: Text(subLink),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSubLink('transaction', index, menuItem.subLinks.indexOf(subLink)),
                        ),
                      )).toList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _addSubLink('transaction', index, value);
                                  }
                                },
                                decoration: const InputDecoration(labelText: 'Add Sub Link'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Add Transaction Link Input
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _addTransactionLink(value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Add Transaction Link'),
                    ),
                  ),
                ],
              ),
            ),

            // Report Links Section
            const Text("Report Links", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ListView.builder(
              itemCount: (_menuModel.reportLinks.length).clamp(0, 10), // Limit to max of 10
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final reportItem = _menuModel.reportLinks[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(reportItem.title),
                    children: [
                      ...reportItem.subLinks.map<Widget>((subLink) => ListTile(
                        title: Text(subLink),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSubLink('report', index, reportItem.subLinks.indexOf(subLink)),
                        ),
                      )).toList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _addSubLink('report', index, value);
                                  }
                                },
                                decoration: const InputDecoration(labelText: 'Add Sub Link'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Add Report Link Input
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _addReportLink(value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Add Report Link'),
                    ),
                  ),
                ],
              ),
            ),

            // Master Links Section
            const Text("Master Links", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ListView.builder(
              itemCount: (_menuModel.masterLinks.length).clamp(0, 10), // Limit to max of 10
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final masterItem = _menuModel.masterLinks[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(masterItem.title),
                    children: [
                      ...masterItem.subLinks.map<Widget>((subLink) => ListTile(
                        title: Text(subLink),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSubLink('master', index, masterItem.subLinks.indexOf(subLink)),
                        ),
                      )).toList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                          Row(children:[
                            Expanded(child:
                              TextField(onSubmitted:(value){
                                if(value.isNotEmpty){
                                  _addSubLink('master', index, value);
                                }
                              },
                              decoration:
                              const InputDecoration(labelText:'Add Sub Link'),),),],),),],),);
              },
            ),
            // Add Master Link Input
            Padding(
              padding:
                const EdgeInsets.symmetric(vertical:
                8.0),
              child:
                Row(children:[
                  Expanded(child:
                    TextField(onSubmitted:(value){
                      if(value.isNotEmpty){
                        _addMasterLink(value);
                      }
                    },
                    decoration:
                    const InputDecoration(labelText:'Add Master Link'),),),],),),

            // Misc Links Section
            const Text("Misc Links", style:
            TextStyle(fontSize:
            20,
            fontWeight:
            FontWeight.bold)),
            ListView.builder(itemCount:
             (_menuModel.miscLinks.length).clamp(0,
             10), // Limit to max of 10
             shrinkWrap:
             true,
             physics:
             const NeverScrollableScrollPhysics(),
             itemBuilder:(context,
             index){
               final miscItem =
               _menuModel.miscLinks[index];
               return Card(child:
               ListTile(
                 title: Text(miscItem),
                 trailing: IconButton(
                   icon: const Icon(Icons.delete),
                   onPressed: () => _deleteMiscLink(index),
                 ),
               ));
             },),

             // Add Misc Link Input
             Padding(padding:
             const EdgeInsets.symmetric(vertical:
             8.0),
             child:
             Row(children:[
               Expanded(child:
               TextField(onSubmitted:(value){
                 if(value.isNotEmpty){
                   _addMiscLink(value);
                 }
               },
               decoration:
               const InputDecoration(labelText:'Add Misc Link'),),),],),),

                Padding(padding:
             const EdgeInsets.symmetric(vertical:
             8.0),
           child:
            Row(children:[
               Expanded(child:
            ElevatedButton(
      onPressed: () async {
        await _delData();
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data deleted successfully')),
        );
      },
      child: const Text('Delete Data'),
    ),),
    Expanded(child:
            ElevatedButton(
      onPressed: () async {
        await _showMenuData();
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Show Data')),
        );
      },
      child: const Text('SHOw DATa'),
    ),),
    Expanded(
  child: ElevatedButton(
    onPressed: _saveToDataFile,
    child: const Text('Save to File'),
  ),
),
    ],),),
          ],

          
        ),
       
   
      ),
    
  ),
  
  );
}
}
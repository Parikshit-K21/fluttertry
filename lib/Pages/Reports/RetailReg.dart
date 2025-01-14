import 'package:flutter/material.dart';

import 'package:login/Pages/Reports/Display.dart';
import 'package:login/custom_app_bar/app_bar.dart';



class RetailReg extends StatefulWidget {
  const RetailReg({super.key});

  @override
  State<RetailReg> createState() => _FrontState();
}

class _FrontState extends State<RetailReg> {
  String? selectedProd1;
  String? selectedUnloadPoint;
  String? selectedprodss;

  bool _isAddChecked = false;
  bool _isRemoveChecked = false;
  bool _isUpdateChecked = false;
    bool _showDocuNumCard = false;

  
    List<Map<String, String>> tableData1 = [
  {'Description': 'Security', 'Lacs': '0.00'},
  {'Description': 'Credit Limit', 'Lacs': '0.00'},
  {'Description': 'Credit Limit', 'Lacs': '0.00'},
  {'Description': 'Credit Limit', 'Lacs': '0.00'},
  {'Description': 'Credit Limit', 'Lacs': '0.00'},
    {'Description': 'Credit Limit', 'Lacs': '0.00'},
  
  // ... other rows
];


List<Map<String, String>> tableData2 = [
  {'Detail': 'Purchaser Name:', 'Data': 'SHREE RAMDAS CEMENT AGENCY'},
  {'Detail': 'Mobile No:', 'Data': '9414048399'},
  {'Detail': 'Purchaser Type:', 'Data': 'ULTRA TECH RETAILERS'},
  {'Detail': 'Address:', 'Data': 'NH. 8 PIPALI STAND ANTELA ( VIRAT NAGAR)'},
];

 final List<String> DocuNumOptions=['DOC001','DOC002','DOC003'];
  final List<String> prod1Options = ['White Cement', 'WaterProof Putty', 'Wall Care Putty'];
  final List<String> unloadPointOptions = ['Delhi', 'Mumbai', 'Pune'];

@override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(),
    body: LayoutBuilder(

      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Retailer Registration',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
               const SizedBox(height: 16.0),
                  // Use a Container with a specific color for the background
                  Container(
                    color: Colors.lightBlue.shade100, // Adjust the color as needed
                    padding: const EdgeInsets.all(16.0),
                    child: 
                constraints.maxWidth > 800
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildShowCard()),
                          const SizedBox(width: 16.0),                          
                          Expanded(child: _buildPurchaserDetailCard()),
                          const SizedBox(width: 16.0),
                          Expanded(child: _buildCreditLimitCard()),
                          const SizedBox(height: 16.0),
                        ],

                      )
                    : Column(
                        children: [
                            _buildShowCard(),
                          const SizedBox(width: 16.0),
                          _buildPurchaserDetailCard(),
                          const SizedBox(height: 16.0),
                          _buildCreditLimitCard(),
                           const SizedBox(height: 16.0),
                      

                        ],
                      ),),
                       Container(
                    color: Colors.lightBlue.shade100, // Adjust the color as needed
                    padding: const EdgeInsets.all(16.0),
                    child:  BelowCard(),),
                const SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  SearchTablePage()),
          );
                      
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 31, 110, 247),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 16,color: Color.fromARGB(253, 253, 253, 253))),
                  ),
                ),
            ],
            ),
          ),
        );
      },
    ),
  );
}
  

  Widget _buildShowCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text("Process Type"),
            _buildProcessTypeCheckboxes(),
             
            const Text(
              'Product and Unload Point',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildProductDropdown(label: 'Prod1', options: prod1Options),
            const SizedBox(height: 16.0),
            _buildProductDropdown(label: 'Unload Point', options: unloadPointOptions),
            const SizedBox(height: 16.0),
            if (_showDocuNumCard) _buildDocuNumCard(label: 'Document NO.', options: DocuNumOptions),
          if (_showDocuNumCard) ...[
          ],
          ],
        ),
      ),
    );
  }


  Widget _buildProductDropdown({required String label, required List<String> options}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: selectedProd1,
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: (value) => setState(() => selectedProd1 = value),
      
    );
    
  }
  

Widget _buildPurchaserDetailCard(){
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Purchaser Details', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),
          _buildTable(tableData2)
        ],
      ),
    ),
  );
}
Widget _buildDetailRow({required String label, required String value}) {
  return Row(
    children: [
      Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
      Text(value),
    ],
  );
}

Widget _buildCreditLimitCard() {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Credit Limit', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),
          _buildTable(tableData1)
        ],
      ),
    ),
  );
}



Widget _buildTable(List<Map<String, String>> tableData) {
  return DataTable(
    columnSpacing: 16.0,
    columns: tableData.isNotEmpty
        ? tableData.first.keys.map((key) => DataColumn(label: Text(key))).toList()
        : [],
    rows: tableData.map((row) {
      return DataRow(
        cells: row.entries.map((entry) {
          return DataCell(Text(entry.value));
        }).toList(),
      );
    }).toList(),
  );
}

Widget _buildRoundedCheckbox(String label, bool isChecked, void Function(bool?)? onChanged) {
  return Row(
    children: [
      Checkbox(
        value: isChecked,
        onChanged: onChanged,
        shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
      ),
      const SizedBox(width: 8.0),
      Text(label),
    ],
  );
}


  Widget _buildProcessTypeCheckboxes() {
    return Row(
      children: [
        _buildRoundedCheckbox('Add', _isAddChecked, (value) {
          setState(() {
            _isAddChecked = value!;
            _isRemoveChecked = false;
            _isUpdateChecked = false;
            _showDocuNumCard = false; // Reset DocuNum card
          });
        }),
        const SizedBox(width: 8.0),
        _buildRoundedCheckbox('Remove', _isRemoveChecked, (value) {
          setState(() {
            _isAddChecked = false;
            _isRemoveChecked = value!;
            _isUpdateChecked = false;
            _showDocuNumCard = true; // Show DocuNum card
          });
        }),
        const SizedBox(width: 8.0),
        _buildRoundedCheckbox('Update', _isUpdateChecked, (value) {
          setState(() {
            _isAddChecked = false;
            _isRemoveChecked = false;
            _isUpdateChecked = value!;
            _showDocuNumCard = true; // Show DocuNum card
          });
        }),
      ],
    );
  }

  Widget _buildDocuNumCard({required String label, required List<String> options}) {
    if (_showDocuNumCard) {
      return Card(
        child:(
       DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: selectedProd1,
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: (value) => setState(() => selectedProd1 = value),
       )
    )
      
      );
    } else {
      return Container();
    }
  }



Widget BelowCard(){
      return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    flex: constraints.maxWidth > 600 ? 2 : 1,
              child: DropdownButtonFormField<String>(
                value: null, // No initial selection
                items: const [
                  DropdownMenuItem(
                    value: 'Product 1',
                    child: Text('Product 1'),
                  ),
                   DropdownMenuItem(
                    value: 'Product 2',
                    child: Text('Product 2'),
                  ),
                  // Add more products as needed
                ],
                onChanged: (value) {
                  // Handle product selection if needed
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Expanded(
              child: Text(
                '15/12/2024', // Replace with desired date format
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: (){
            //               Navigator.push(
            // context,
            // MaterialPageRoute(
            //     builder: (context) =>  FilterPage()),);
                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                      ElevatedButton(
                        onPressed: (){Show();} ,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
      );
}
  Show() {
     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('CLicked'),
                        ),
                      );
  }
  
  }
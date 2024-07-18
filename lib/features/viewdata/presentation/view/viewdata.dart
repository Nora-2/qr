//new update
// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/features/core.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});
  static String id = 'viewdata';
  @override
  // ignore: library_private_types_in_public_api
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  List<Map<String, dynamic>> _qrcodes = [];
  late DatabaseHelper _dbHelper;
  final TextEditingController _searchControllerID = TextEditingController();
  final TextEditingController _searchControllerQR = TextEditingController();
  final TextEditingController _searchControllerDatetime =
      TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();

  }

  @override
  void dispose() {
    _dbHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primarycolor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white, // Use a different back icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Core()),
              );
            },
          ),
          title: const Text('View QR Codes',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              )),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete_sweep,
                color: Colors.white,
              ),
              onPressed: () async {
                _deleteAllQRCodes(context);
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewDataScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
          
             Padding(
                padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.05,left: 16,right: 16),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                                  _searchQuery = _searchControllerID.text;
                      _loadDataID(_searchQuery);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.02),
                     labelText: 'ID',
                  hintText: 'Search by Id',
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF047EB0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      )),
                 controller: _searchControllerID,
                ),
              ),
             Padding(
                padding: EdgeInsets.only(bottom: height * 0.05,left: 16,right: 16),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _searchQuery = _searchControllerQR.text;
                        _loadDataQR(_searchQuery);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.02),
                      
                    labelText: 'BARCODE',
                    hintText: 'Search by Barcode',
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF047EB0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      )),
                   controller: _searchControllerQR,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.05,left: 16,right: 16),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                          _searchQuery = _searchControllerDatetime.text;
                          _loadDataDatetime(_searchQuery);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.02),
                      labelText: 'Date',
                      hintText: 'Search by Date',
                      labelStyle: TextStyle(
                        fontSize: 25,
                        color: primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF047EB0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF88AACA),
                        ),
                      )),
                  controller: _searchControllerDatetime,
                ),
              ),
              _qrcodes.isEmpty
                  ? const Center(child: Text('No data found'))
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Barcode \n الباركود')),
                          DataColumn(label: Text('DateTime \n التاريخ')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _qrcodes.map<DataRow>((code) {
                          return DataRow(
                            cells: [
                              DataCell(Text('${code['id']}')),
                              // ignore: sized_box_for_whitespace
                              DataCell(Container(
                                  width: 100,
                                  child: Text('${code['qrCode']}'))),
                              DataCell(Text('${code['datetime']}')),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    _deleteQRCode(context, code['id'],
                                        _qrcodes.indexOf(code));
                                    await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewDataScreen(),
                                      ),
                                    );
                                    customAwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            title: 'Success',
                                            onOkPressed: () {
                                              Navigator.pop(context);
                                            },
                                            description:
                                                'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
                                            buttonColor:
                                                const Color(0xff00CA71))
                                        .show();
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ],
          ),
        ));
  }

  Future<void> _loadDataID(String id) async {
    await _dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (id.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await _dbHelper.queryQRCodeById(id);
    }
    setState(() {
      _qrcodes = qrcodes;
    });
  }

  Future<void> _loadDataQR(String qr) async {
    await _dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (qr.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await _dbHelper.queryQRCodeBycode(qr);
    }
    setState(() {
      _qrcodes = qrcodes;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _searchControllerDatetime.text =
            "${picked.year}/${picked.month}/${picked.day}";
        _searchQuery = _searchControllerDatetime.text;
        _loadDataDatetime(_searchQuery);
      });
    }
  }

  Future<void> _loadDataDatetime(String datetime) async {
    await _dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (datetime.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await _dbHelper.queryQRCodeBytime(datetime);
    }
    setState(() {
      _qrcodes = qrcodes;
    });
  }
  Future<void> _deleteAllQRCodes(BuildContext context) async {
    await _dbHelper.deleteAllQRCodes();
    _loadDataID(''); // Wait for data to update

    customAwesomeDialog(
            context: context,
            onOkPressed: () {
              Navigator.pop(context);
            },
            dialogType: DialogType.success,
            title: 'Success',
            description:
                'All Barcodes deleted successfully! \n تم حذف كل الباركود بنجاح',
            buttonColor: const Color(0xff00CA71))
        .show();
  }

  Future<void> _deleteQRCode(BuildContext context, int id, int index) async {
    await _dbHelper.deleteQRCode(id);
    _loadDataID(''); // Wait for data to update
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/features/core.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({Key? key}) : super(key: key);
  static String id = 'viewdata';
  @override
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  List<Map<String, dynamic>> _qrcodes = [];
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes = await _dbHelper.queryAllQRCodes();
    setState(() {
      _qrcodes = qrcodes;
    });
  }

  @override
  void dispose() {
    _dbHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white, // Use a different back icon
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Core()),
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
                MaterialPageRoute(builder: (context) => const ViewDataScreen()),
              );
            },
          ),
        ],
      ),
      body: _qrcodes.isEmpty
          ? const Center(child: Text('No data found'))
          : ListView.builder(
              itemCount: _qrcodes.length,
              itemBuilder: (context, index) {
                var code = _qrcodes[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('QR Code: ${code['qrCode']}'),
                    subtitle: Text(
                        'ID: ${code['id']}\n datatime ${code['datetime']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        _deleteQRCode(context, code['id'], index);
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewDataScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteAllQRCodes(BuildContext context) async {
    await _dbHelper.deleteAllQRCodes();
    _loadData(); // Wait for data to update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All QR Codes deleted successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _deleteQRCode(BuildContext context, int id, int index) async {
    await _dbHelper.deleteQRCode(id);
    _loadData(); // Wait for data to update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code deleted successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

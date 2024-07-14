// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({Key? key}) : super(key: key);

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
        title: const Text('View QR Codes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _deleteAllQRCodes(context);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ViewDataScreen()),
              // );
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
                    subtitle: Text('ID: ${code['id']}\n ${code['datetime']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteQRCode(context, code['id'], index);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ViewDataScreen()),
                        // );
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

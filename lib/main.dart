import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/blocobserver.dart';
import 'package:qr_code_app/features/excel/presentation/view/excel.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';
import 'package:qr_code_app/features/viewdata/presentation/view/viewdata.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart'; // Import your DatabaseHelper class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initDatabase(); // Initialize SQLite database
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  MyHome()),
                );
              },
              child: const Text('Scan QR Code'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DownloadDataScreen()),
                );
              },
              child: const Text('Download Data as Excel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewDataScreen()),
                );
              },
              child: const Text('View QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

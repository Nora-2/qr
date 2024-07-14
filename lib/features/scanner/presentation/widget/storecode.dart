import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';

DateTime dateToday = DateTime.now();
String date = dateToday.toString().substring(0, 10);

void storeCode(BuildContext context, TextEditingController codeController) async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primarycolor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        content: const Text(
          'Please enter a code',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFFF1F4FF),
          ),
        ),
      ),
    );
    return;
  }

  // Initialize the DatabaseHelper instance
  DatabaseHelper dbHelper = DatabaseHelper();

  // Query all existing QR codes from the local database
  List<Map<String, dynamic>> existingCodes = await dbHelper.queryAllQRCodes();

  // Check if the entered code already exists in the local database
  if (existingCodes.any((element) => element['qrCode'] == enteredCode)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:  primarycolor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        content: Text(
          'Code already exists: $enteredCode',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFFF1F4FF),
          ),
        ),
      ),
    );
    return;
  }

  // Prepare the new QR code data
  Map<String, dynamic> newCode = {
    'qrCode': enteredCode,
    'datetime': date,
  };

  // Insert the new QR code into the local database
  await dbHelper.insertQRCode(newCode);

  // Show a success message using a SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:  primarycolor,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      content: const Text(
        'Code stored successfully!',
        style: TextStyle(
          fontSize: 17,
          color: Color(0xFFF1F4FF),
        ),
      ),
    ),
  );
}

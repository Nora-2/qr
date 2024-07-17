// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

DateTime now = DateTime.now();
String date =
    '${now.year}/${now.month}/${now.day}-${now.hour}:${now.minute}';

void storeCode(
    BuildContext context, TextEditingController codeController) async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isEmpty) {
    // Show AlertDialog
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            title: 'Info',
            description:
                'Please enter the Barcode ... \n ... من فضلك ادخل الباركود',
            buttonColor: primarycolor)
        .show();

    return;
  }

  // Initialize the DatabaseHelper instance
  DatabaseHelper dbHelper = DatabaseHelper();

  // Query all existing QR codes from the local database
  List<Map<String, dynamic>> existingCodesList = await dbHelper.queryAllQRCodes();
  
  // Create a HashMap for fast lookup
  var existingCodesMap = <String, Map<String, dynamic>>{};
  for (var code in existingCodesList) {
    existingCodesMap[code['qrCode']] = code;
  }

  // Check if the entered code already exists in the local database
  if (existingCodesMap.containsKey(enteredCode)) {
    var time = existingCodesMap[enteredCode]!['datetime'];
    // Show AlertDialog
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            description:
                'The Barcode already exists: $enteredCode \n هذا الباركود موجود بالفعل\n datetime: $time',
            buttonColor: Colors.red)
        .show();
    return;
  }

  // Prepare the new QR code data
  Map<String, dynamic> newCode = {
    'qrCode': enteredCode,
    'datetime': date,
  };

  // Insert the new QR code into the local database
  await dbHelper.insertQRCode(newCode);

  // Show AlertDialog
  if (enteredCode.isNotEmpty) {
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Success',
            description:
                'The Barcode stored successfully! \n تم حفظ الباركود بنجاح',
            buttonColor: Color(0xff00CA71))
        .show();
  }
}

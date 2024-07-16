// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

DateTime now = DateTime.now();
String date =
    'Date-${now.year}/${now.month}/${now.day} Time-${now.hour}:${now.minute}';

void storeCode(
    BuildContext context, TextEditingController codeController) async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isEmpty) {
    //Show AlertDialog
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
  List<Map<String, dynamic>> existingCodes = await dbHelper.queryAllQRCodes();
for (var i in existingCodes) {
        if (i['qrCode'] == enteredCode) {
        var  time = i['datetime'];
         customAwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            description:
                // ignore: unnecessary_brace_in_string_interps
                'The Barcode already exists: $enteredCode \n هذا الباركود موجود بالفعل\n datetime:${time}',
            buttonColor: Colors.red)
        .show();
        }
      }
  // Check if the entered code already exists in the local database
  if (existingCodes.any((element) => element['qrCode'] == enteredCode)) {
    //Show AlertDialog
    

    return;
  }

  // Prepare the new QR code data
  Map<String, dynamic> newCode = {
    'qrCode': enteredCode,
    'datetime': date,
  };

  // Insert the new QR code into the local database
  await dbHelper.insertQRCode(newCode);

  //Show AlertDialog
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

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';


void manualCode(
    BuildContext context, TextEditingController codeController) async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isEmpty) {
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


  DatabaseHelper dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> existingCodesList = await dbHelper.queryAllQRCodes();
 
  var existingCodesMap = <String, Map<String, dynamic>>{};
  for (var code in existingCodesList) {
    existingCodesMap[code['qrCode']] = code;
  }

   if (existingCodesMap.containsKey(enteredCode)) {
    var time = existingCodesMap[enteredCode]!['datetime'];
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

  Map<String, dynamic> newCode = {
    'qrCode': enteredCode,
    'datetime': date,
  };

  await dbHelper.insertQRCode(newCode);


 
}

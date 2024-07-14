import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

DateTime dateToday = DateTime.now();
String date = dateToday.toString().substring(0, 10);

void storeCode(
    BuildContext context, TextEditingController codeController) async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isEmpty) {
    //Show AlertDialog
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            title: 'Info',
            description: 'Please enter the barcode ... \n ... من فضلك ادخل الباركود',
            buttonColor: Color(0xff0098FF)
            )
        .show();

    return;
  }

  // Initialize the DatabaseHelper instance
  DatabaseHelper dbHelper = DatabaseHelper();

  // Query all existing QR codes from the local database
  List<Map<String, dynamic>> existingCodes = await dbHelper.queryAllQRCodes();

  // Check if the entered code already exists in the local database
  if (existingCodes.any((element) => element['qrCode'] == enteredCode)) {

    //Show AlertDialog
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            description:
                'The barcode already exists: $enteredCode \n هذا الباركود موجود بالفعل',
            buttonColor: Color(0xffD93E47))
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

  //Show AlertDialog
  customAwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Success',
          description:
              'The barcode stored successfully! \n تم حفظ الباركود بنجاح',
          buttonColor: Color(0xff00CA71))
      .show();
 
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart'; // Adjust import as per your project structure
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart'; // Adjust import as per your project structure

part 'excel_state.dart'; // Define your ExcelState

class ExcelCubit extends Cubit<ExcelState> {
  ExcelCubit() : super(ExcelInitial());

  static ExcelCubit get(context) => BlocProvider.of(context);

  dynamic filePath;

  Future<void> downloadData(BuildContext context) async {
    try {
      // Fetch data from SQLite database using helper
      List<Map<String, dynamic>> data = await retrieveAllCodes();

      if (data.isEmpty) {
        throw Exception('No data available to export.');
      }

      // Create Excel instance
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['QR Codes'];

      // Write headers to Excel sheet
      List<String> headers = ['ID', 'QRCode', 'Date'];
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject
            .cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}1'));
        cell.value = headers[i];
      }

      // Write data rows to Excel sheet
      for (int i = 0; i < data.length; i++) {
        List<dynamic> row = data[i].values.toList();
        for (int j = 0; j < row.length; j++) {
          var cell = sheetObject.cell(CellIndex.indexByString(
              '${String.fromCharCode(65 + j)}${i + 2}'));
          cell.value = row[j];
        }
      }

      // Get the directory to save the file
      var directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access external storage directory.');
      }

      filePath = '${directory.path}/QRCodes.xlsx';

      // Save the Excel file
      var bytes = excel.encode();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes!);

      // Show dialog to inform user about successful download
      // showdialogcustomconvert(
      //     context, filePath); // Implement this function as per your needs

      //Show AlertDialog
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              description:
                  'Excel file downloaded successfully! \n تم تنزيل ملف اكسل بنجاح',
              buttonColor:const Color(0xff00CA71))
          .show();

      // Emit success state
      emit(ExcelDownloadSuccess());
    } catch (e) {
      //Show AlertDialog
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'Failed to download Excel: $e \n فشل في تنزيل ملف اكسل',
              buttonColor: buttoncolor)
          .show();

      // Emit failure state
      emit(ExcelDownloadFailed());
    }
  }

  Future<List<Map<String, dynamic>>> retrieveAllCodes() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    return await dbHelper.queryAllQRCodes();
  }
}

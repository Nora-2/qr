// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart'; // Adjust import as per your project structure
import 'package:qr_code_app/core/utilis/showdialog.dart'; // Adjust import as per your project structure

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
      List<String> headers = ['ID','QRCode','Date'];
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}1'));
        cell.value = headers[i];
      }

      // Write data rows to Excel sheet
      for (int i = 0; i < data.length; i++) {
        List<dynamic> row = data[i].values.toList();
        for (int j = 0; j < row.length; j++) {
          var cell = sheetObject.cell(CellIndex.indexByString('${String.fromCharCode(65 + j)}${i + 2}'));
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
      showdialogcustomconvert(context, filePath); // Implement this function as per your needs


      // Show SnackBar using ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:  primarycolor,
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  content: const Text(
                    'Excel file downloaded successfully!',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFF1F4FF),
                    ),
                  ),
                ),
              );

      // Emit success state
      emit(ExcelDownloadSuccess());
    } catch (e) {
       
      // Show SnackBar using ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:  primarycolor,
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  content: Text(
                    'Failed to download data: $e',
                    style:const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFF1F4FF),
                    ),
                  ),
                ),
              );
      

      // Emit failure state
      emit(ExcelDownloadFailed());
    }
  }

  Future<List<Map<String, dynamic>>> retrieveAllCodes() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    return await dbHelper.queryAllQRCodes();
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/utilis/showdialog.dart';

part 'excel_state.dart';

class ExcelCubit extends Cubit<ExcelState> {
  ExcelCubit() : super(ExcelInitial());
  static ExcelCubit get(context) => BlocProvider.of(context);
  dynamic filePath;
  Future<void> downloadData(BuildContext context) async {
    try {
      // Fetch data from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('qrcodes').get();
      List<Map<String, dynamic>> data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['QR Codes'];
      List<String> headers = data.isNotEmpty ? data.first.keys.toList() : [];
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject
            .cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}1'));
        cell.value = headers[i];
      }
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
      filePath = '${directory!.path}/QRCodes.xlsx';

      // Save the Excel file
      var bytes = excel.encode();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes!);
      showdialogcustomconvert(context, filePath);
      emit(filedownloadsecss());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to download data: $e')));
      emit(filedownloadfailed());
    }
  }
}

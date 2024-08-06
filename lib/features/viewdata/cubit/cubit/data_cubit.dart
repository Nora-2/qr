// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  static DataCubit get(context) => BlocProvider.of(context);
  DatabaseHelper dbHelper = DatabaseHelper();

  final TextEditingController searchControllerID = TextEditingController();
  final TextEditingController searchControllerQR = TextEditingController();
  final TextEditingController searchControllerDatetime =
      TextEditingController();
  String searchQuery = '';
  List<Map<String, dynamic>> qrcodes = [];
  String? selectedItem;

  Future<void> deleteData(int id, BuildContext context) async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteQRCode(id);
      await dbHelper.rearrangeIds(); // Rearrange IDs after deletion
      emit(DataDeletedSuccessfully());

      //Show AlertDialog
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              description:
                  'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
              buttonColor: const Color(0xff00CA71))
          .show();
    } catch (e) {
      emit(DataDeletionError());

      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'Error deleting the Barcode \n خطأ في حذف هذا الباركود',
              buttonColor: const Color(0xffD93E47))
          .show();

      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> loadDataID(String id) async {
    await dbHelper.initDatabase();

    if (id.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeById(id);
    }

    qrcodes = qrcodes;
    print(qrcodes);
  }

  Future<void> loadDataQR(String qr) async {
    await dbHelper.initDatabase();

    if (qr.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeBycode(qr);
    }

    emit(DataLoaded(qrcodes));
    print(qrcodes);
  }

  dynamic filePath;
  Future<void> generateExcel(
      List<Map<String, dynamic>> qrcodes, BuildContext context) async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['QR Codes'];
    sheetObject.appendRow([
      'ID',
      'Barcode \n الباركود',
      'DateTime \n التاريخ',
      'Company \n الشركة',
    ]);

    for (var code in qrcodes) {
      sheetObject.appendRow([
        code['id'],
        code['qrCode'],
        code['datetime'],
        code['company'],
      ]);
    }
    var bytes = excel.encode();

    if (bytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    // Get the directory to save the file
    var directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('Could not access external storage directory.');
    }

    filePath = '${directory.path}/  Barcode.xlsx';

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    // Show dialog to inform user about successful download

    //Show AlertDialog
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Success',
            description:
                'Excel file downloaded successfully! \n تم تنزيل ملف اكسل بنجاح',
            buttonColor: const Color(0xff00CA71))
        .show();

    // Show success dialog
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description:
          'Excel file downloaded successfully! \n تم تنزيل ملف اكسل بنجاح',
      buttonColor: const Color(0xff00CA71),
    ).show();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      searchControllerDatetime.text =
          "${picked.year}/${picked.month}/${picked.day}";
      searchQuery = searchControllerDatetime.text;
      loadDataDatetime(searchQuery);
    }
  }

  Future<void> loadDataDatetime(String datetime) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.initDatabase();
    if (datetime.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeBytime(datetime);
    }


    emit(DataLoaded(qrcodes));
    print(qrcodes);
  }

  Future<void> loadDataDatecompany(String company) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.initDatabase();
    if (company.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeBycompainy(company);
    }
 emit(DataLoaded(qrcodes));
    print(qrcodes);
  }

  Future<void> deleteAllQRCodes(BuildContext context) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteAllQRCodes();
    loadDataID(''); // Wait for data to update

    customAwesomeDialog(
            context: context,
            onOkPressed: () {
              Navigator.pop(context);
            },
            dialogType: DialogType.success,
            title: 'Success',
            description:
                'All Barcodes deleted successfully! \n تم حذف كل الباركود بنجاح',
            buttonColor: const Color(0xff00CA71))
        .show();
  }

  Future<void> deleteQRCode(BuildContext context, int id, int index) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteQRCode(id);
    loadDataID(''); // Wait for data to update
  }

  Future<void> deleteAllData(BuildContext context) async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteAllQRCodes();
      await dbHelper.resetIds();
      emit(AllDataDeletedSuccessfully());
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              description:
                  'All Barcodes deleted successfully! \n تم حذف الباركود كل بنجاح',
              buttonColor: const Color(0xff00CA71))
          .show();
    } catch (e) {
      emit(DataDeletionError());
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'Error deleting all the Barcodes \n خطأ في حذف كل الباركود',
              buttonColor: const Color(0xffD93E47))
          .show();

      // ignore: avoid_print
      print('$e');
    }
  }
}

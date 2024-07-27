// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  static DataCubit get(context) => BlocProvider.of(context);

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

  late DatabaseHelper dbHelper;
  final TextEditingController searchControllerID = TextEditingController();
  final TextEditingController searchControllerQR = TextEditingController();
  final TextEditingController searchControllerDatetime =
      TextEditingController();
  String searchQuery = '';
  List<Map<String, dynamic>> qrcodes = [];

  Future<void> loadDataID(String id) async {
    await dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (id.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeById(id);
    }

    qrcodes = qrcodes;
  }

  Future<void> loadDataQR(String qr) async {
    await dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (qr.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeBycode(qr);
    }

    qrcodes = qrcodes;
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
    await dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (datetime.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await dbHelper.queryQRCodeBytime(datetime);
    }

    qrcodes = qrcodes;
  }

  Future<void> deleteAllQRCodes(BuildContext context) async {
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
    await dbHelper.deleteQRCode(id);
    loadDataID(''); // Wait for data to update
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

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

      //Show AlertDialog
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
      await dbHelper.resetIds(); // Reset IDs after deleting all data
      emit(AllDataDeletedSuccessfully());

      //Show AlertDialog
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

      //Show AlertDialog
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

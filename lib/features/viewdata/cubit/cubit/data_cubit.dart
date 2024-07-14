import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code deleted successfully!')),
      );
    } catch (e) {
      emit(DataDeletionError());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting QR Code: $e')),
      );
    }
  }

  Future<void> deleteAllData(BuildContext context) async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteAllQRCodes();
      await dbHelper.resetIds(); // Reset IDs after deleting all data
      emit(AllDataDeletedSuccessfully());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All QR Codes deleted successfully!')),
      );
    } catch (e) {
      emit(DataDeletionError());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting all QR Codes: $e')),
      );
    }
  }
}

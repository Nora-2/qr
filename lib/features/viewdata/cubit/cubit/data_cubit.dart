
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/scanner/cubit/cubit/scanner_cubit.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  static DataCubit get(context) => BlocProvider.of(context);

  Future<void> deleteData(String docId,BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('qrcodes')
          .doc(docId)
          .delete();
      await rearrangeAndSetCurrentId();
      await ScannerCubit.get(context).rearrangeAndSetCurrentId();
      emit(DataDeletedSuccessfully());

      const SnackBar(content: Text('QR Code deleted successfully!'));
    } catch (e) {
      emit(DataDeletionError());

      SnackBar(content: Text('Error deleting QR Code: $e'));
    }
  }

  Future<void> deleteAllData(BuildContext context) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('qrcodes').get();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await _resetCurrentId();
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

  Future<void> rearrangeAndSetCurrentId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .orderBy('id')
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      int currentId = 1;

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'id': currentId});
        currentId++;
      }

      await batch.commit();

      DocumentReference idRef =
          FirebaseFirestore.instance.collection('metadata').doc('currentId');
      await idRef.set({'id': currentId});
    } catch (e) {
      print("Error rearranging IDs and setting currentId: $e");
    }
  }

  Future<void> _resetCurrentId() async {
    DocumentReference idRef =
        FirebaseFirestore.instance.collection('metadata').doc('currentId');
    await idRef.set({'id': 1});
  }
}

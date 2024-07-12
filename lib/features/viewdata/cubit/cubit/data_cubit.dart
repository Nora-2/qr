import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

    static DataCubit get(context) => BlocProvider.of(context);
  Future<void> deleteData(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('qrcodes')
          .doc(docId)
          .delete();
      // ignore: use_build_context_synchronously

      const SnackBar(content: Text('QR Code deleted successfully!'));
    } catch (e) {
      print("Error deleting QR code: $e");
      
      // ignore: use_build_context_synchronously

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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All QR Codes deleted successfully!')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting all QR Codes: $e')),
      );
    }
  }
}

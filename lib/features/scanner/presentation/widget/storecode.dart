// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';

void storeCode(BuildContext context,TextEditingController code) async {
    String enteredCode = code.text.trim();

    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a code')),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('qrCode', isEqualTo: enteredCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Code already exists: $enteredCode')),
        );
        return;
      }

      int nextId = await _getNextId();
      String docId = nextId.toString();

      await FirebaseFirestore.instance.collection('qrcodes').doc(docId).set({
        'id': docId,
        'qrCode': enteredCode,
        'datetime': formattedTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code stored successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error storing code: $e')),
      );
    }
  }

  Future<int> _getNextId() async {
    DocumentReference idRef =
        FirebaseFirestore.instance.collection('metadata').doc('currentId');
    DocumentSnapshot idSnapshot = await idRef.get();

    if (idSnapshot.exists) {
      var data = idSnapshot.data() as Map<String, dynamic>;
      int currentId = data['id'] ?? 0;
      await idRef.update({'id': currentId + 1});
      return currentId + 1;
    } else {
      await idRef.set({'id': 1});
      return 1;
    }
  }







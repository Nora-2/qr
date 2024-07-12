import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(ScannerInitial());
  static ScannerCubit get(context) => BlocProvider.of(context);
   Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;

  Widget buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }



  void _onQRViewCreated(QRViewController controller,) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanning) {
        return;
      }
   
        result = scanData;
        isScanning = false;
        controller.pauseCamera();
        checkAndStoreQRCode(scanData.code,);
      
    });
  }

  void startSingleScan() {
   
      result = null;
      isScanning = true;
      controller?.resumeCamera();
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

  Future<void> checkAndStoreQRCode(
    String? qrCode,
  
  ) async {
    if (qrCode == null) return;

    try {
      // Check if the QR code already exists in the collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('qrCode', isEqualTo: qrCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        
            SnackBar(content: Text('QR Code already exists: $qrCode'));
        return;
      }

      // If it doesn't exist, proceed to store it
      int nextId = await _getNextId();
      String docId = nextId.toString();

      DocumentReference docRef =
          FirebaseFirestore.instance.collection('qrcodes').doc(docId);

      await docRef.set({
        'id': docId,
        'qrCode': qrCode,
        'datetime': formattedTime,
      });

       const SnackBar(content: Text('QR Code stored successfully!'));
    } catch (e) {
     SnackBar(content: Text('Error storing QR Code: $e'));
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }


import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart'; // Import your DatabaseHelper

part 'scanner_state.dart';
DateTime dateToday = DateTime.now();
String date = dateToday.toString().substring(0, 10);

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(ScannerInitial());

  static ScannerCubit get(context) => BlocProvider.of(context);

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;
  int currentId = 1; // Current ID variable

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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanning) {
        return;
      }

      result = scanData;
      isScanning = false;
      controller.pauseCamera();
      checkAndStoreQRCode(scanData.code);
    });
  }

  void startSingleScan() {
    result = null;
    isScanning = true;
    controller?.resumeCamera();
  }

  Future<int> _getNextId() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> codes = await dbHelper.queryAllQRCodes();
    int nextId = codes.isNotEmpty ? codes.last['id'] + 1 : 1;
    return nextId;
  }

  Future<void> checkAndStoreQRCode(String? qrCode) async {
    if (qrCode == null) return;

    try {
      int docId = await _getNextId(); // Get the current ID

      // Initialize the DatabaseHelper instance
      DatabaseHelper dbHelper = DatabaseHelper();

      // Check if the QR code already exists in the local database
      List<Map<String, dynamic>> existingCodes = await dbHelper.queryAllQRCodes();
      if (existingCodes.any((element) => element['qrCode'] == qrCode)) {
        emit(QRCodeExists(qrCode));
        return;
      }

      // If it doesn't exist, proceed to store it
      Map<String, dynamic> newCode = {
        'id': docId,
        'qrCode': qrCode,
        'datetime': date,
      };
      await dbHelper.insertQRCode(newCode);

      emit(QRCodeStored());
    } catch (e) {
      emit(QRCodeError(e.toString()));
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
}

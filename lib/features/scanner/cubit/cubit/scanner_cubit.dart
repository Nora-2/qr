import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart'; // Import your DatabaseHelper

part 'scanner_state.dart';

DateTime now = DateTime.now();
String date =
    '${now.year}/${now.month}/${now.day}-${now.hour}:${now.minute}:${now.second}';

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
        ? 180.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: primarycolor,
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
        result = scanData;
        isScanning = true;
        controller.pauseCamera();
        checkAndStoreQRCode(scanData.code);
      }
    });

    // Start scanning automatically
    controller.resumeCamera();
  }

  Future<void> checkAndStoreQRCode(String? qrCode) async {
    if (qrCode == null) return;

    try {
      // Initialize the DatabaseHelper instance
      DatabaseHelper dbHelper = DatabaseHelper();

      // Fetch all QR codes and store them in a HashMap for fast lookup
      List<Map<String, dynamic>> existingCodesList =
          await dbHelper.queryAllQRCodes();
      var existingCodesMap = <String, Map<String, dynamic>>{};
      for (var code in existingCodesList) {
        existingCodesMap[code['qrCode']] = code;
      }

      // Check if the QR code already exists in the local database
      if (existingCodesMap.containsKey(qrCode)) {
        var time = existingCodesMap[qrCode]!['datetime'];
        emit(QRCodeExists(qrCode, time));
        isScanning = false; // Reset scanning state
        controller?.resumeCamera(); // Resume camera for next scan
        return;
      }

      // If it doesn't exist, proceed to store it
      Map<String, dynamic> newCode = {
        'qrCode': qrCode,
        'datetime': date,
      };
      await dbHelper.insertQRCode(newCode);

      emit(QRCodeStored());
      isScanning = false; // Reset scanning state
      controller?.resumeCamera(); // Resume camera for next scan
    } catch (e) {
      emit(QRCodeError(e.toString()));
      isScanning = false; // Reset scanning state in case of error
      controller?.resumeCamera(); // Resume camera for next scan
    }
  }

  void startSingleScan() {
    result = null;
    isScanning = true;
    controller?.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'No permission to access the camera \n لا تصريح بالوصول إلى الكاميرا',
              buttonColor: const Color(0xffD93E47))
          .show();
    }
  }
}

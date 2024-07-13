part of 'scanner_cubit.dart';

@immutable
abstract class ScannerState {}

class ScannerInitial extends ScannerState {}

class QRCodeStored extends ScannerState {}

class QRCodeExists extends ScannerState {
  final String qrCode;

  QRCodeExists(this.qrCode);
}

class QRCodeError extends ScannerState {
  final String error;

  QRCodeError(this.error);
}

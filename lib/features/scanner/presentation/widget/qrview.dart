import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/scanner/cubit/cubit/scanner_cubit.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      ScannerCubit.get(context).controller?.pauseCamera();
    }
    ScannerCubit.get(context).controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ScannerCubit(),
        child: BlocConsumer<ScannerCubit, ScannerState>(
          listener: (context, state) {
            if (state is QRCodeStored) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('QR Code stored successfully!')),
              );
            } else if (state is QRCodeExists) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('QR Code already exists: ${state.qrCode}')),
              );
            } else if (state is QRCodeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error storing QR Code: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: ScannerCubit.get(context).buildQrView(context)),
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (ScannerCubit.get(context).result != null)
                            Text(
                                'Code: ${ScannerCubit.get(context).result!.code}')
                          else
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScannerCubit.get(context).startSingleScan();
                                },
                                child: const Text(
                                  'Scan',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  @override
  void dispose() {
    ScannerCubit.get(context).controller?.dispose();
    ScannerCubit.get(context).close(); // Ensure to close the cubit
    super.dispose();
  }
}

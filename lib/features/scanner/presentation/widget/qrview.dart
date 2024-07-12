// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps
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
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      ScannerCubit.get(context).controller!.pauseCamera();
    }
    ScannerCubit.get(context).controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ScannerCubit(),
        child: BlocConsumer<ScannerCubit, ScannerState>(
          listener: (context, state) {},
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
                              height: 20,
                              width: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScannerCubit.get(context).startSingleScan();
                                },
                                child: const Text('Scan'),
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
    super.dispose();
  }
}

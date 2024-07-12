import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/excel/cubit/cubit/excel_cubit.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ExcelCubit(),
        child: BlocConsumer<ExcelCubit, ExcelState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () => ExcelCubit.get(context).downloadData,
                child:const Text('Download Data as Excel'),
              ),
            );
          },
        ));
  }
}

//new update
// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/features/home/home.dart';
import 'package:qr_code_app/features/viewdata/cubit/cubit/data_cubit.dart';
import 'package:qr_code_app/features/viewdata/presentation/widgets.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});
  static String id = 'viewdata';
  @override
  // ignore: library_private_types_in_public_api
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {


  @override
  void initState() {
    super.initState();
 DataCubit.get(context).dbHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    DataCubit.get(context).dbHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
        create: (context) => DataCubit(),
        child: BlocConsumer<DataCubit, DataState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: primarycolor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white, // Use a different back icon
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Core()),
                      );
                    },
                  ),
                  title: const Text('View QR Codes',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      )),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        DataCubit.get(context).deleteAllQRCodes(context);
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewDataScreen()),
                        );
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.05,
                            bottom: height * 0.05,
                            left: 16,
                            right: 16),
                        child: customidfield(width: width, height: height),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: height * 0.05, left: 16, right: 16),
                        child: customqrfield(width: width, height: height),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: height * 0.05, left: 16, right: 16),
                        child: customsearchdatefield(width: width, height: height),
                      ),
                      DataCubit.get(context).qrcodes.isEmpty
                          ? const Center(child: Text('No data found'))
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(
                                      label: Text('Barcode \n الباركود')),
                                  DataColumn(
                                      label: Text('DateTime \n التاريخ')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: DataCubit.get(context).qrcodes.map<DataRow>((code) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${code['id']}')),
                                      // ignore: sized_box_for_whitespace
                                      DataCell(Container(
                                          width: 100,
                                          child: Text('${code['qrCode']}'))),
                                      DataCell(Text('${code['datetime']}')),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            DataCubit.get(context).deleteQRCode(context, code['id'],
                                                DataCubit.get(context).qrcodes.indexOf(code));
                                            await Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ViewDataScreen(),
                                              ),
                                            );
                                            customAwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.success,
                                                    title: 'Success',
                                                    onOkPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    description:
                                                        'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
                                                    buttonColor:
                                                        const Color(0xff00CA71))
                                                .show();
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                    ],
                  ),
                ));
          },
        ));
  }
}

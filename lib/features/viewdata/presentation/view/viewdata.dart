//new update
// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/features/home/home.dart';
import 'package:qr_code_app/features/viewdata/cubit/cubit/data_cubit.dart';
import 'package:qr_code_app/features/viewdata/presentation/view/confirmdelelt.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});
  static String id = 'viewdata';
  @override
  // ignore: library_private_types_in_public_api
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    _dbHelper.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> selectedQRCodes = [];
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
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () async {
                      final qrcodes = DataCubit.get(context).qrcodes;
                      await DataCubit.get(context)
                          .generateExcel(qrcodes, context);
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
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  DataCubit.get(context).searchQuery =
                                      DataCubit.get(context)
                                          .searchControllerID
                                          .text;
                                  DataCubit.get(context).loadDataID(
                                      DataCubit.get(context).searchQuery);
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            labelText: 'ID',
                            hintText: 'Search by Id',
                            labelStyle: TextStyle(
                              fontSize: 25,
                              color: primarycolor,
                              fontWeight: FontWeight.bold,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF047EB0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            )),
                        controller: DataCubit.get(context).searchControllerID,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: height * 0.05, left: 16, right: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  DataCubit.get(context).searchQuery =
                                      DataCubit.get(context)
                                          .searchControllerQR
                                          .text;
                                  DataCubit.get(context).loadDataQR(
                                      DataCubit.get(context).searchQuery);
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            labelText: 'BARCODE',
                            hintText: 'Search by Barcode',
                            labelStyle: TextStyle(
                              fontSize: 25,
                              color: primarycolor,
                              fontWeight: FontWeight.bold,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF047EB0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            )),
                        controller: DataCubit.get(context).searchControllerQR,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: height * 0.05, left: 16, right: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {
                                setState(() {
                                  DataCubit.get(context).selectDate(context);
                                  DataCubit.get(context).searchQuery =
                                      DataCubit.get(context)
                                          .searchControllerDatetime
                                          .text;
                                  DataCubit.get(context).loadDataDatetime(
                                      DataCubit.get(context).searchQuery);
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            labelText: 'Date',
                            hintText: 'Search by Date',
                            labelStyle: TextStyle(
                              fontSize: 25,
                              color: primarycolor,
                              fontWeight: FontWeight.bold,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF047EB0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF88AACA),
                              ),
                            )),
                        controller:
                            DataCubit.get(context).searchControllerDatetime,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: height * 0.05,
                        left: 16,
                        right: 16,
                      ),
                      child: Container(
                        height: height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xFF88AACA),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Center(
                            child: FutureBuilder<List<String>>(
                              future: _dbHelper.fetchCompanyNames(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<String>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No company names found');
                                } else {
                                  return DropdownSearch<String>(
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: snapshot.data!,
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          labelText: 'select company'),
                                    ),
                                    selectedItem:
                                        DataCubit.get(context).selectedItem,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        DataCubit.get(context).selectedItem =
                                            newValue;

                                        DataCubit.get(context).searchQuery =
                                            newValue!;

                                        DataCubit.get(context)
                                            .loadDataDatecompany(
                                                DataCubit.get(context)
                                                    .searchQuery);
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCubit.get(context).qrcodes.isEmpty
                        ? const Center(child: Text('No data found'))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Select')),
                                  DataColumn(label: Text('ID')),
                                  DataColumn(
                                      label: Text('Barcode \n الباركود')),
                                  DataColumn(
                                      label: Text('DateTime \n التاريخ')),
                                  DataColumn(label: Text('Company \n الشركة')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: DataCubit.get(context)
                                    .qrcodes
                                    .map<DataRow>((code) {
                                  bool isSelected = selectedQRCodes.any(
                                      (selectedCode) =>
                                          selectedCode['id'] == code['id']);

                                  return DataRow(
                                    selected: isSelected,
                                    onSelectChanged: (selected) {
                                      setState(() {
                                        if (selected ?? false) {
                                          if (!selectedQRCodes.any(
                                              (selectedCode) =>
                                                  selectedCode['id'] ==
                                                  code['id'])) {
                                            selectedQRCodes.add(code);
                                          }
                                        } else {
                                          selectedQRCodes.removeWhere(
                                              (selectedCode) =>
                                                  selectedCode['id'] ==
                                                  code['id']);
                                        }
                                      });
                                    },
                                    cells: [
                                      DataCell(Checkbox(
                                        value: isSelected,
                                        onChanged: (selected) {
                                          setState(() {
                                            if (selected ?? false) {
                                              if (!selectedQRCodes.any(
                                                  (selectedCode) =>
                                                      selectedCode['id'] ==
                                                      code['id'])) {
                                                selectedQRCodes.add(code);
                                              }
                                            } else {
                                              selectedQRCodes.removeWhere(
                                                  (selectedCode) =>
                                                      selectedCode['id'] ==
                                                      code['id']);
                                            }
                                          });
                                        },
                                      )),
                                      DataCell(Text(
                                          '${code['id']}')), // Ensure correct key usage
                                      DataCell(Text(
                                          '${code['qrCode']}')), // Ensure correct key usage
                                      DataCell(Text(
                                          '${code['datetime']}')), // Ensure correct key usage
                                      DataCell(Text(
                                          '${code['Company']}')), // Ensure correct key usage
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            bool? confirmDelete =
                                                await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  const confirmdelete(),
                                            );

                                            if (confirmDelete == true) {
                                              int docId = code['id'];
                                              await DataCubit.get(context)
                                                  .deleteData(docId, context);
                                              setState(() {
                                                DataCubit.get(context)
                                                    .qrcodes
                                                    .removeWhere((element) =>
                                                        element['id'] ==
                                                        code['id']);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.02, bottom: height * 0.08),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.08,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: primarycolor,
                          shadowColor: Colors.grey,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: selectedQRCodes.isEmpty
                            ? null
                            : () async {
                                bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const confirmdelete();
                                  },
                                );

                                if (confirmDelete == true) {
                                  OverlayEntry? overlayEntry;
                                  OverlayState? overlayState =
                                      Overlay.of(context);

                                  overlayEntry = OverlayEntry(
                                    builder: (context) => const Positioned(
                                      child: Material(
                                        color: Colors.black45,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  );
                                  overlayState.insert(overlayEntry);

                                  try {
                                    var idsToDelete = selectedQRCodes
                                        .map((code) => code['id'] as int)
                                        .toList();
                                    await _dbHelper.deleteselectedData(
                                        idsToDelete, context);

                                    setState(() {
                                      selectedQRCodes.clear();
                                      DataCubit.get(context)
                                          .qrcodes
                                          .removeWhere((element) => idsToDelete
                                              .contains(element['id']));
                                      DataCubit.get(context).qrcodes.sort(
                                          (a, b) => (a['id'] as int)
                                              .compareTo(b['id'] as int));
                                    });
                                  } catch (e) {
                                    print(
                                        'Error deleting selected QR codes: $e');
                                  } finally {
                                    overlayEntry.remove();
                                  }
                                }
                              },
                        child: const Text('Delete Selected'),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}

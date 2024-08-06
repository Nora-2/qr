// ignore_for_file: avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';
import 'package:qr_code_app/core/widgets/CustomButton.dart';
import 'package:qr_code_app/core/widgets/toppart.dart';
import 'package:qr_code_app/features/EnterCompanies.dart';
import 'package:qr_code_app/features/excel/presentation/view/excel.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';
import 'package:qr_code_app/features/viewdata/presentation/view/viewdata.dart';

class Core extends StatefulWidget {
  const Core({super.key});
  static String id = 'homepage';

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  final TextEditingController company = TextEditingController();

  String? selectedItem;
  List<String> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanyNames();
  }

Future<void> _fetchCompanyNames() async {
    try {
      final databaseHelper = DatabaseHelper();
      List<Map<String, dynamic>> companyMaps = await databaseHelper.getAllCompanies();

      // Extract company names
      List<String> companyNames = companyMaps
          .map((companyMap) => companyMap['company'] as String)
          .toList();

      if (mounted) {
        setState(() {
          _dropdownItems = companyNames;
        });
      }
    } catch (e) {
      print("Error fetching company names: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: Column(
        children: [
          toppart(
            height: height,
            width: width,
            SpecificPage: const Entercompanies(),
          ),
          Container(
            height: height * 0.8,
            width: width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: height * 0.07)),
                  SizedBox(
                      width: width * 0.3,
                      height: height * 0.2,
                      child: Image.asset('assets/images/select (1).png')),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: const Text(
                        'Please Enter Company Name .... \n      من فضلك ادخل اسم الشركة',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.04,
                        bottom: height * 0.05,
                        left: width * 0.10,
                        right: width * 0.10),
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: primarycolor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Center(
                          child: DropdownSearch<String>(
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: _dropdownItems,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select a company",
                              ),
                            ),
                            selectedItem: selectedItem,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedItem = newValue;
                              });
                              if (newValue != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Scanner(company: newValue),
                                    ));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  const Text('Please Choose Your Operation ....',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.041, bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          if (selectedItem == null || selectedItem == '') {
                            customAwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    title: 'Info',
                                    description:
                                        'Please choose the company ... \n ...من فضلك اخترالشركة',
                                    buttonColor: primarycolor)
                                .show();
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Scanner(company: selectedItem!)),
                          );
                        },
                        child: const customButton(text: "Scan QR Code")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DownloadDataScreen()),
                          );
                        },
                        child:
                            const customButton(text: "Download Data as Excel")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewDataScreen()),
                          );
                        },
                        child: const customButton(text: "View QR Code")),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

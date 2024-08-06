// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';
import 'package:qr_code_app/core/widgets/toppart.dart';
import 'package:qr_code_app/features/home/home.dart';

class Entercompanies extends StatefulWidget {
  static String id = 'entercompanies';
  const Entercompanies({super.key});

  @override
  State<Entercompanies> createState() => _EntercompaniesState();
}

class _EntercompaniesState extends State<Entercompanies> {
  TextEditingController companyController = TextEditingController();
  TextEditingController editController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  bool isDataVisible = false;
  int? editingCompanyId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

Future<void> addCompany() async {
  if (companyController.text.trim().isEmpty) return;
  String companyName = companyController.text.trim();
  DatabaseHelper dbHelper = DatabaseHelper();

  try {
    await dbHelper.addCompany(companyName);
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description: 'Company added successfully! \n تم إضافة الشركة بنجاح',
      buttonColor: Colors.green,
    ).show();
    companyController.clear();
    loadData();
  } catch (e) {
    if (e.toString().contains('Company already exists')) {
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Company already exists! \n الشركة موجودة بالفعل',
        buttonColor: Colors.red,
      ).show();
    } else {
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Failed to add company: $e \n فشل في إضافة الشركة',
        buttonColor: Colors.red,
      ).show();
    }
  }
}


  Future<void> updateCompany(int id, String newName) async {
    if (newName.trim().isEmpty) return;
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.updateCompany(id, newName);
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description: 'Company updated successfully! \n تم تحديث الشركة بنجاح',
      buttonColor: Colors.green,
    ).show();
    setState(() {
      editingCompanyId = null;
      editController.clear();
    });
    loadData();
  }

  Future<void> deleteCompany(int id) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteCompany(id);
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description: 'Company deleted successfully! \n تم حذف الشركة بنجاح',
      buttonColor: Colors.green,
    ).show();
    loadData();
  }

  List<Map<String, dynamic>> companies = [];

  Future<void> loadData() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    companies = await dbHelper.getAllCompanies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            toppart(
              height: height,
              width: width,
              SpecificPage: const Core(),
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: height * 0.07)),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: Center(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter your company',
                            suffixIcon: const Icon(
                              Icons.edit,
                              size: 19,
                              color: Colors.black,
                            ),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blueGrey)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          controller: companyController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a company name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  if (editingCompanyId != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: Form(
                        key: _editFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Edit company name',
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.blueGrey)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(),
                                ),
                              ),
                              controller: editController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new company name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            SizedBox(
                              width: width * 0.7,
                              height: height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primarycolor,
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (_editFormKey.currentState!.validate()) {
                                    updateCompany(editingCompanyId!, editController.text.trim());
                                  }
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: 'MulishRomanBold',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.7,
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primarycolor,
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addCompany();
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'MulishRomanBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.7,
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primarycolor,
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isDataVisible = !isDataVisible;
                        });
                      },
                      child: const Text(
                        'View',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'MulishRomanBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isDataVisible)
                    SizedBox(
                      height: height * 0.7,
                      child: ListView.builder(
                        itemCount: companies.length,
                        itemBuilder: (context, index) {
                          var companyData = companies[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              child: ListTile(
                                title: Text(companyData['company']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          editingCompanyId = companyData['id'];
                                          editController.text = companyData['company'];
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteCompany(companyData['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(color: Colors.white, height: height * 0.7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

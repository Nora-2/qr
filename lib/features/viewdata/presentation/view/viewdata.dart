
// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/constant.dart';
import 'package:qr_code_app/core/utilis/databasehelper.dart';
import 'package:qr_code_app/features/core.dart';
import 'package:qr_code_app/widgets/AwesomeDiaglog.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});
  static String id = 'viewdata';
  @override
  // ignore: library_private_types_in_public_api
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  List<Map<String, dynamic>> _qrcodes = [];
  late DatabaseHelper _dbHelper;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';


  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
   // _loadData();
  }

  Future<void> _loadData(String id) async {
    await _dbHelper.initDatabase();
    List<Map<String, dynamic>> qrcodes;
    if (id.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await _dbHelper.queryQRCodeById(id);
    }
    setState(() {
      _qrcodes = qrcodes;
    });
  }


  @override
  void dispose() {
    _dbHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _deleteAllQRCodes(context);
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewDataScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by ID',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                      _loadData(_searchQuery);
                    });
                  },
                ),
              ),
            ),
          ),
            
            
             _qrcodes.isEmpty
            ? const Center(child: Text('No data found'))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Barcode \n الباركود')),
                      DataColumn(label: Text('DateTime \n التاريخ')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _qrcodes.map<DataRow>((code) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${code['id']}')),
                          // ignore: sized_box_for_whitespace
                          DataCell(Container(
                              width: 100, child: Text('${code['qrCode']}'))),
                          DataCell(Text('${code['datetime']}')),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                _deleteQRCode(context, code['id'],
                                    _qrcodes.indexOf(code));
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewDataScreen(),
                                  ),
                                );
                                customAwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        title: 'Success',
                                        onOkPressed: () {
                                          Navigator.pop(context);
                                        },
                                        description:
                                            'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
                                        buttonColor: const Color(0xff00CA71))
                                    .show();
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ),
        ],
              ));
  }

  Future<void> _deleteAllQRCodes(BuildContext context) async {
    await _dbHelper.deleteAllQRCodes();
    _loadData(''); // Wait for data to update

    customAwesomeDialog(
            context: context,
            onOkPressed: () {
              Navigator.pop(context);
            },
            dialogType: DialogType.success,
            title: 'Success',
            description:
                'All Barcodes deleted successfully! \n تم حذف كل الباركود بنجاح',
            buttonColor: const Color(0xff00CA71))
        .show();
  }

  Future<void> _deleteQRCode(BuildContext context, int id, int index) async {
    await _dbHelper.deleteQRCode(id);
    _loadData(''); // Wait for data to update
  }
}


// // ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_super_parameters

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_app/core/utilis/constant.dart';
// import 'package:qr_code_app/core/utilis/databasehelper.dart';
// import 'package:qr_code_app/core/widgets/AwesomeDiaglog.dart';
// import 'package:qr_code_app/features/viewdata/presentation/widget/colunm.dart';

// class ViewDataScreen extends StatefulWidget {
//   const ViewDataScreen({Key? key}) : super(key: key);
//   static String id = 'viewdata';
//   @override
//   _ViewDataScreenState createState() => _ViewDataScreenState();
// }

// class _ViewDataScreenState extends State<ViewDataScreen> {
//   List<Map<String, dynamic>> _qrcodes = [];
//   late DatabaseHelper _dbHelper;

//   @override
//   void initState() {
//     super.initState();
//     _dbHelper = DatabaseHelper();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     await _dbHelper.initDatabase();
//     List<Map<String, dynamic>> qrcodes = await _dbHelper.queryAllQRCodes();
//     setState(() {
//       _qrcodes = qrcodes;
//     });
//   }

//   @override
//   void dispose() {
//     _dbHelper.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primarycolor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: Colors.white, // Use a different back icon
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('View QR Codes',
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Pacifico',
//             )),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.delete_sweep,
//               color: Colors.white,
//             ),
//             onPressed: () async {
//               _deleteAllQRCodes(context);
//               await Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ViewDataScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _qrcodes.isEmpty
//           ? const Center(child: Text('No data found'))
//           : ListView.builder(
//               itemCount: _qrcodes.length,
//               itemBuilder: (context, index) {
//                 var code = _qrcodes[index];
//                 return Card(
//                     margin: const EdgeInsets.all(5),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
                       
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 10,right: 10),
//                             child: dataviewcolum(
//                               code: code,
//                               title: 'QR Code',
//                               value: '${code['qrCode']}',
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: dataviewcolum(
//                               code: code,
//                               title: 'ID',
//                               value: '${code['id']}',
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal:10.0),
//                             child: dataviewcolum(
//                               code: code,
//                               title: 'Datetime',
//                               value: '${code['datetime']}',
//                             ),
//                           ),
//                          const SizedBox(width: 50,),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () async {
//                               _deleteQRCode(context, code['id'], index);
//                               // await Navigator.pushReplacement(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) => const ViewDataScreen()),
//                               // );
//                             },
//                           ),
//                         ],
//                       ),
//                     ));
//               },
//             ),
//     );
//   }

//   Future<void> _deleteAllQRCodes(BuildContext context) async {
//     await _dbHelper.deleteAllQRCodes();
//     _loadData(); // Wait for data to update
//     customAwesomeDialog(
//             context: context,
//             dialogType: DialogType.success,
//             title: 'Success',
//             description:
//                 ' All QR Codes deleted successfully!,! \n تم مسح جميع الملفات بنجاح',
//             buttonColor: const Color(0xff00CA71))
//         .show();
//   }

//   Future<void> _deleteQRCode(BuildContext context, int id, int index) async {
//     await _dbHelper.deleteQRCode(id);
//     _loadData(); // Wait for data to update

//     customAwesomeDialog(
//             context: context,
//             dialogType: DialogType.success,
//             title: 'Success',
//             description: 'QR Code deleted successfully! \n تم مسح الكود بنجاح',
//             buttonColor: const Color(0xff00CA71))
//         .show();
//   }
// }

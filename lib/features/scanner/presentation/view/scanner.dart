import 'package:flutter/material.dart';
import 'package:qr_code_app/features/core.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/customformfield.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/qrview.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/storecode.dart';

DateTime now = DateTime.now();
String formattedTime =
    'Date-${now.year}/${now.month}/${now.day} Time-${now.hour}:${now.minute}:${now.second}';

class Scanner extends StatelessWidget {
  Scanner({super.key});

  final TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF2452B1),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.2,
            width: width,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height * 0.01),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Core()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: const Center(
                    child: Text('Naham Inventory',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                  ),
                ),
              ],
            ),
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
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: height * 0.07)),
                SizedBox(
                    width: width * 0.4,
                    height: height * 0.3,
                    child: Image.asset('assets/images/scan.png')),
                const Text('Place the QR code in the area',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
                const Text(
                  'Scanning will be started automatically',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.06,
                      bottom: height * 0.06,
                      left: width * 0.06,
                      right: width * 0.062),
                  child: CustomFormField(
                    ispass: false,
                    hint: 'Enter your Code',
                    suffix: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRViewExample()));
                      },
                    ),
                    preicon: const Icon(
                      Icons.edit,
                      size: 19,
                      color: Colors.black,
                    ),
                    controller: code,
                  ),
                ),
                SizedBox(
                  width: width * 0.84,
                  height: height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF2452B1),
                      shadowColor: Colors.grey, // Shadow color
                      elevation: 5, // Elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => storeCode(context, code),
                    child: const Text(
                      'Store Code',
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
        ],
      ),
    );
  }
}

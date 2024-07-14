import 'package:qr_code_app/features/excel/presentation/view/excel.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';
import 'package:qr_code_app/features/viewdata/presentation/view/viewdata.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/features/welcome.dart';
import 'package:qr_code_app/widgets/CustomButton.dart';

class Core extends StatelessWidget {
  const Core({super.key});

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
                        MaterialPageRoute(
                            builder: (context) => const welcomePage()),
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
            child: SingleChildScrollView(
              child: Column(
                
                children: [
                  Padding(padding: EdgeInsets.only(top: height * 0.07)),
                  SizedBox(
                      width: width * 0.3,
                      height: height * 0.2,
                      child: Image.asset('assets/images/select (1).png')),
                  const Text('Please Choose Your Operation ....',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  Padding(
                    padding:
                        EdgeInsets.only(top: height * 0.1, bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Scanner()),
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
                                builder: (context) => const DownloadDataScreen()),
                          );
                        },
                        child:
                            const customButton(text: "Download Data as Excel")),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewDataScreen()),
                        );
                      },
                      child: const customButton(text: "View QR Code")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

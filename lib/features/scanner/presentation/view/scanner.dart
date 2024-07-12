import 'package:flutter/material.dart';

import 'package:qr_code_app/features/scanner/presentation/widget/customformfield.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/qrview.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/storecode.dart';

DateTime now = DateTime.now();
String formattedTime =
    '${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}';

class MyHome extends StatelessWidget {
  MyHome({super.key});

  final TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * .4,
          ),
          CustomFormField(
            ispass: false,
            hint: 'Enter your Code',
            suffix: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRViewExample()));
              },
            ),
            preicon: const Icon(
              Icons.edit,
              size: 19,
              color: Colors.black,
            ),
            controller: code,
          ),
          SizedBox(
            height: size.height * .02,
          ),
          ElevatedButton(
            onPressed: () => storeCode(context, code),
            child: const Text('Store Code'),
          ),
        ],
      ),
    );
  }
}

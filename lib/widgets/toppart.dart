
import 'package:flutter/material.dart';
import 'package:qr_code_app/features/core.dart';

class toppart extends StatelessWidget {
  const toppart({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.2,
      width: width,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: height * 0.05),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Core()),
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 165, 129, 129),
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
    );
  }
}

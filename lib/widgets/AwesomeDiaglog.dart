// ignore: file_names
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: camel_case_types
class customAwesomeDialog extends StatelessWidget {
  final BuildContext context;
  final DialogType dialogType;
  final String title;
  final String description;
  final Color buttonColor;
  final VoidCallback? onOkPressed;

  // ignore: prefer_const_constructors_in_immutables
  customAwesomeDialog({
    super.key,
    required this.context,
    required this.dialogType,
    required this.title,
    required this.description,
    required this.buttonColor,
    this.onOkPressed,
  });

  void show() {
    // ignore: avoid_single_cascade_in_expression_statements
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: dialogType,
      title: title,
      titleTextStyle: const TextStyle(
        fontSize: 29,
        fontWeight: FontWeight.bold,
      ),
      desc: description,
      descTextStyle:
          const TextStyle(fontSize: 20, fontFamily: 'PlayfairDisplay'),
      btnOk: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'OK',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

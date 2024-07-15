
import 'package:flutter/material.dart';

class dataviewcolum extends StatelessWidget {
  const dataviewcolum({
    super.key,
    required this.code,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  final Map<String, dynamic> code;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(title,style:const TextStyle(fontWeight:FontWeight.bold ),),const SizedBox(height: 10,), Text(value)],
    );
  }
}

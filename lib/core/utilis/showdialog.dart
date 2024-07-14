import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

Future<dynamic> showdialogcustom(BuildContext context, String image) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return GiffyDialog.image(
        Image.asset(
          image,
          height: 200,
          fit: BoxFit.cover,
        ),
        title: const Text(
          'Check your Files',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('CANCEL'),
          ),
          const SizedBox(
            width: 100,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showdialogcustomconvert(BuildContext context, String path) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return GiffyDialog.image(
        Image.asset(
          'assets/images/Download-rafiki.png',
          height: 200,
          fit: BoxFit.cover,
        ),
        title:  Text(
          'your file downloaded successfully at $path',
          textAlign: TextAlign.center,
        ),
        actions: [
          const SizedBox(
            width: 100,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:qr_code_app/GoogleSheet/user.dart';

class Qrformwidget extends StatefulWidget {
  final ValueChanged<QR> onSavedCode;

  const Qrformwidget({
    Key? key,
    required this.onSavedCode,
  }) : super(key: key);

  @override
  _QrformwidgetState createState() => _QrformwidgetState();
}

class _QrformwidgetState extends State<Qrformwidget> {
  late TextEditingController controllerCode;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initCode();
  }

  void initCode() {
    controllerCode = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => buildSubmit();

  Widget buildSubmit() => Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: controllerCode,
              decoration: InputDecoration(
                  labelText: 'QR', border: OutlineInputBorder()),
              validator: (value) =>
                  value != null && value.isEmpty ? 'EnterCode' : null,
            ),
            ElevatedButton(
                onPressed: () {
                  final form = formKey.currentState!;
                  final isValid = form.validate();
                  if (isValid) {
                    final String datetime = DateTime.now().toString();
                    final qr = QR(
                      barcode: controllerCode.text,
                      datetime: datetime,
                      company: "YourCompanyName",
                    );
                    widget.onSavedCode(qr);
                  }
                },
                child: Text('Save')),
          ],
        ),
      );
}

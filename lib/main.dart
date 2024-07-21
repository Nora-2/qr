import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/core/utilis/app_routes.dart';
import 'package:qr_code_app/core/utilis/blocobserver.dart';
import 'package:qr_code_app/features/spalsh/welcome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const welcomePage(),
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }

  
}

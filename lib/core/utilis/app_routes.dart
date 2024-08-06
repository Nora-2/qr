import 'package:qr_code_app/features/home/home.dart';
import 'package:qr_code_app/features/excel/presentation/view/excel.dart';
import 'package:qr_code_app/features/scanner/presentation/view/scanner.dart';
import 'package:qr_code_app/features/scanner/presentation/widget/qrview.dart';
import 'package:qr_code_app/features/viewdata/presentation/view/viewdata.dart';
import 'package:qr_code_app/features/spalsh/welcome.dart';

class AppRoutes {
  AppRoutes._();

  static String? get initialRoute {
   
      return welcomePage.id;
    
  }

  static final routes = {
    welcomePage.id: (context) => const welcomePage(),
    QRViewExample.id: (context) => const QRViewExample(),
    Core.id: (context) => const Core(),
    DownloadDataScreen.id: (context) => const DownloadDataScreen(),
    Scanner.id: (context) =>  Scanner(company:''),
    ViewDataScreen.id: (context) => const ViewDataScreen(),
  
  };


}

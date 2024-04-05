import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/back_service.dart';
import 'package:learning/generated/l10n.dart';
import 'package:learning/lol.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Permission.notification.isDenied.then((value) async {
    if(value){
      await Permission.notification.request();
    }
    if(await Permission.notification.isGranted){
      Permission.ignoreBatteryOptimizations.isDenied.then((value) async {
        if(value){
          await Permission.ignoreBatteryOptimizations.request();
        }

      });

    }
  });


  await initializeService();
  if(await Permission.ignoreBatteryOptimizations.isGranted){
    print('backGround');
    FlutterBackgroundService().invoke('setAsBackground');

  }else{
    FlutterBackgroundService().invoke('stopService');

  }
  runApp(MainApp());
  // runApp(MainApp());
}

class MainApp extends StatefulWidget{

  State<MainApp> createState() => _MainAppState();

}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,

    ]);

   // connectToSocket();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
        locale: const Locale('en'),

        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,

      color: const Color(0xFF272A37),
      home: Scaffold(
        backgroundColor: const Color(0xFF272A37),


        body: Login(),
        // Grad(),
    )
    );
  }


}


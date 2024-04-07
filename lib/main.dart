import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/back_service.dart';
import 'package:learning/generated/l10n.dart';
import 'package:learning/lol.dart';
import 'package:permission_handler/permission_handler.dart';

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

  runApp(MainApp());
  // runApp(MainApp());
}

class MainApp extends StatefulWidget{

  State<MainApp> createState() => _MainAppState();

}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,

    ]);

    WidgetsBinding.instance.addObserver(this);
   // connectToSocket();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {

      checkPermission();
      print("Executing code before app exits...");
    }
  }
}

  Future<void> connectToSocket() async {
    await initializeService();


  }

  Future<void> checkPermission() async {

    if(!(await FlutterBackgroundService().isRunning())) {
      if (await Permission.ignoreBatteryOptimizations.isGranted) {
        print('backGround');

        connectToSocket();

        FlutterBackgroundService().invoke('setAsBackground');
        print('backGround Activated ');
      } else {
        FlutterBackgroundService().invoke('stopService');
      }
    }
  }

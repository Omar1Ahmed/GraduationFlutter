import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/generated/l10n.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main (){

  // runApp(DevicePreview(
  //     enabled: false  ,
  //     devices: [
  //       buildGenericPhoneDevice(platform: TargetPlatform.iOS, id: 'ioslol', name: 'ioslol', screenSize: Size(1170 ,2532))
  //     ],
  //     builder: (context) =>MainApp()));
  runApp(MainApp());
}

class MainApp extends StatefulWidget{
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();


   // connectToSocket();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      // builder: DevicePreview.appBuilder,
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


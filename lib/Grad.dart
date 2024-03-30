import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:learning/Widgets/NearestMeetingsWidget.dart';
import 'package:learning/SqlDb.dart';
import 'package:learning/Widgets/NotesWidget.dart';
import 'package:learning/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Widgets/SettingsWidget.dart';

class Grad extends StatefulWidget {
  SharedPreferences accData , loginInfo,Language, Nearest;
   Grad(this.accData, this.loginInfo,this.Language,this.Nearest, {super.key});

  static late TabController lol;




  @override
  State<Grad> createState() => _GradState();




}
int _curntIndx = 0;
// PageController _PageController = PageController(
//   initialPage: 0,
//
// );


SqlDb sqldb = SqlDb();


late List<Map> cardData;







class _GradState extends State<Grad> with TickerProviderStateMixin{


  @override
  void initState() {
    super.initState();

    Grad.lol = TabController(length: 4, vsync: this,);
    // connectToSocket();

    // languageSharedPrefInitialize();
    // nearsetSharedPref();
    //
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //
    // ]);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale('en'),

      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home:  Scaffold(
        bottomNavigationBar:
      SizedBox(
        height: 60,
        child: TabBar(
          controller: Grad.lol,
          tabs: [
              const Tab(icon: Icon(Icons.home),text: "Home",iconMargin: EdgeInsets.all(0)),
              Tab(icon: Icon(_curntIndx == 1 ? Icons.notifications : Icons.notifications_none),text: "Nearest",iconMargin: const EdgeInsets.all(0)),
              const Tab(icon: Icon(Icons.edit_note_sharp),text: "Notes",iconMargin: EdgeInsets.all(0)),
              const Tab(icon: Icon(Icons.settings),text: "Settings",iconMargin: EdgeInsets.all(0)),
            ], onTap: (int index) {
              setState(() {
                _curntIndx = index;
              });
            }, dividerColor: Colors.transparent,indicatorSize: TabBarIndicatorSize.tab  , indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 3.0
                ),
              ),
            ), ),
      ),


        backgroundColor: const Color(0xFF272A37),



        body: Scaffold(
          backgroundColor: const Color(0xFF272A37),

          body: PopScope(

            onPopInvoked: (didPop) {
              print(didPop);
            },
            child: TabBarView(


            controller: Grad.lol,
              children: [
                HomePage(accData: accData, loginInfo: loginInfo,Language: Language,Nearest: Nearest,),

                NearestMeetings(),
                Notes( accData, loginInfo, Language),
                Settings(),
              ],

            ),
          ),
        )

      ),
      );
  }

  void connectToSocket() {
    print('socket Started');  
    IO.Socket socket = IO.io("https://meetingss.onrender.com", IO.OptionBuilder().setTransports(["websocket"]).build());

    socket.connect();

    // socket.on('connect', (_) {
    //   print('Connected');
    // });

    // socket.on('notification', (data) {
    //   print('Received notification: $data');
    //   // Handle the notification as needed
    // });
    //
    // socket.on('disconnect', (_) {
    //   print('Disconnected');
    // });

    socket.onConnect((data) => print('${socket.connected} Socket connected'));
    socket.onError((data) => print('Socket error: $data'));
    socket.onDisconnect((data) => print('Socket disconnected: $data'));
    socket.onConnecting((data) => print('Socket connecting: $data'));
    socket.emit('updateSocketId','${accData.getString('token')}' );

    socket.on('newNotification', (data) => print('$data Socket'));

  }



  void languageSharedPref() async {
    if(Language.getString('language') == 'en'){
      S.load(Locale("en"));
    }else if(Language.getString('language') == 'ar'){
      S.load(Locale("ar"));
    }else{
      S.load(Locale("ar"));
      Language.setString('language', 'ar');
    }
setState(() {

});
  }
  void languageSharedPrefInitialize() async {
    Language = await SharedPreferences.getInstance();

    if(Language.toString().isEmpty){
      print('Empty Shared');
      languageSharedPref();
    }else{
      S.load(Locale(Language.getString('language').toString()));
    setState(() {

    });
    }

  }
  void nearsetSharedPref() async {
    widget.Nearest = await SharedPreferences.getInstance();
    if(widget.Nearest!.getInt('Days') == null){
      widget.Nearest!.setInt('Days', 3);
    }


  }
}


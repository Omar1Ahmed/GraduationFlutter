import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Meetings/Widgets/HomePageWidegt.dart';
import 'package:Meetings/Widgets/LoginWidget.dart';
import 'package:Meetings/Widgets/NearestMeetingsWidget.dart';
import 'package:Meetings/SqlDb.dart';
import 'package:Meetings/Widgets/NotesWidget.dart';
import 'package:Meetings/Widgets/NotificationsWidget.dart';
import 'package:Meetings/generated/l10n.dart';
import 'package:Meetings/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/SettingsWidget.dart';

var ScreenWidth , ScreenHeight ;

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
    if(MediaQuery.of(context).orientation == Orientation.portrait){
      ScreenWidth = MediaQuery.of(context).size.width;
      ScreenHeight = MediaQuery.of(context).size.height;
    }else{
      ScreenWidth = MediaQuery.of(context).size.height;
      ScreenHeight = MediaQuery.of(context).size.width;
      // ScreenWidth = MediaQuery.of(context).size.width;
      // ScreenHeight = MediaQuery.of(context).size.height;
    }

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
        height: ScreenHeight * 0.065,
        child: TabBar(
          controller: Grad.lol,
          labelPadding: EdgeInsets.zero,
          tabs: [
              const Tab(icon: Icon(Icons.home),text: "Home",iconMargin: EdgeInsets.all(0)),
              const Tab(icon: Icon(Icons.access_time_outlined), text: 'Nearest',iconMargin: EdgeInsets.zero,),
              const Tab(icon: Icon(Icons.edit_note_sharp),text: "Notes",iconMargin: EdgeInsets.all(0)),
              // Tab(icon: Icon(_curntIndx == 3 ? Icons.notifications : Icons.notifications_none),text: "Notifications",iconMargin: const EdgeInsets.all(0)),
              const Tab(icon: Icon(Icons.settings),text: "Settings",iconMargin: EdgeInsets.all(0)),
            ], onTap: (int index) {
              setState(() {
                _curntIndx = index;
              });
            }, dividerColor: Colors.transparent,indicatorSize: TabBarIndicatorSize.tab  , indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: ScreenWidth * 0.0065
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
                // Notifications(accData, loginInfo, Language),
                Settings(),
              ],

            ),
          ),
        )

      ),
      );
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


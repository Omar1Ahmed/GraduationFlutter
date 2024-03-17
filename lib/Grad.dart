import 'package:flutter/material.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:learning/Widgets/NearestMeetingsWidget.dart';
import 'package:learning/SqlDb.dart';
import 'package:learning/Widgets/NotesWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/SettingsWidget.dart';

class Grad extends StatefulWidget {
  SharedPreferences accData , loginInfo ;
   Grad(this.accData, this.loginInfo, {super.key});

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



List<DateTime> getDays(){
  List<DateTime> Days =  [];

  for(int loop = 0 ; loop < cardData.length ; loop ++){
    Days.add(DateTime.parse(cardData[loop]['date']));

  }

  return Days;
}



class _GradState extends State<Grad> with TickerProviderStateMixin{


  @override
  void initState() {
    super.initState();

    Grad.lol = TabController(length: 4, vsync: this,);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

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
                HomePage(accData, loginInfo),

                NearestMeetings(),
                Notes(accData, loginInfo),
                Settings(),
              ],

            ),
          ),
        )

      ),
      );
  }



}


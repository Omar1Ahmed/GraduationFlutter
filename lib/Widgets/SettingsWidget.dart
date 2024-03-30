import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/generated/l10n.dart';
import 'package:learning/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    super.initState();

    languageSharedPrefInitialize();
  }
  @override
  Widget build(BuildContext context) {
    late double ScreenWidth ;
    late double ScreenHeight;

    if(MediaQuery.of(context).orientation == Orientation.portrait){
      ScreenWidth = MediaQuery.of(context).size.width;
      ScreenHeight = MediaQuery.of(context).size.height;
    }else{
      ScreenWidth = MediaQuery.of(context).size.height;
      ScreenHeight = MediaQuery.of(context).size.width;
      // ScreenWidth = MediaQuery.of(context).size.width;
      // ScreenHeight = MediaQuery.of(context).size.height;
    }
print('$ScreenWidth $ScreenHeight');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF272A37),
        body: SafeArea(

          child: Stack(

            children: [

              Container(
                  margin: EdgeInsets.only(left: ScreenWidth * 0.04, top: ScreenHeight * 0.015),
                  // child: Container(
                  //
                  //   width: ScreenWidth * 0.15,
                  //   height: ScreenHeight * 0.050,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(100),
                  //   boxShadow:  [
                  //     BoxShadow(
                  //         color: Colors.grey[900]!, spreadRadius: 4, blurRadius: 10
                  //     )
                  //   ],
                  //   color: Color(0xFF272A37),
                  // ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ScreenWidth * 0.04),
                    onTap: (){
                        print(Language.getString('language'));
                        if(Language.getString('language') == 'en'){
                            Language.setString('language', 'ar');
                            S.load(Locale("ar"));
                        }else if(Language.getString('language') == 'ar'){
                          Language.setString('language', 'en');
                            S.load(Locale("en"));
                        }
                      setState(() {

                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ScreenWidth * 0.05),
                        boxShadow:  [
                          BoxShadow(
                              color: Colors.grey[900]!, spreadRadius: ScreenWidth * 0.009, blurRadius: ScreenWidth * 0.019
                          )
                        ],
                        color: Color(0xFF272A37),
                      ),

                      width: ScreenWidth * 0.15,
                      height: ScreenHeight * 0.050,
                      child: Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: ScreenWidth * 0.045,bottom: ScreenHeight * 0.019),
                              child: Text('En',style: TextStyle(fontSize: ScreenWidth * 0.033,color: isEnglish()? Colors.white : Colors.grey[600],fontWeight: FontWeight.bold),)),
                          Container(
                              margin: EdgeInsets.only(left: ScreenWidth * 0.035,top: ScreenHeight * 0.0041),
                              child: Text('/',style: TextStyle(fontSize: ScreenWidth * 0.050 ,color: Colors.white,fontWeight: FontWeight.bold),)),
                          Container(
                              margin: EdgeInsets.only(left: ScreenWidth * 0.055,top: ScreenHeight * 0.0135),
                              child: Text('ع',style: TextStyle(fontSize: ScreenWidth * 0.033,color: isEnglish() ? Colors.grey : Colors.white,fontWeight: FontWeight.bold),)),
                        ]
                      ),
                    ),
                  ),

              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Container(
                      width: ScreenWidth *0.17, // 70
                      height: ScreenHeight * 0.08, // 70
                      margin:  EdgeInsets.only(top: ScreenHeight * 0.056),
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenWidth * 0.13),
                          color: Colors.green[500],
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green, spreadRadius: ScreenWidth * 0.023, blurRadius: ScreenWidth * 0.5)
                          ]),
                      child:  Text(
                  accData.getString('userName')!.toUpperCase().substring(0, 1),
                        style: TextStyle(fontSize: ScreenWidth * 0.08, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Container(
                    margin:  isEnglish() ? EdgeInsets.only(top: ScreenHeight * 0.090, left: ScreenWidth * 0.071):
                    EdgeInsets.only(top: ScreenHeight * 0.090, left: ScreenWidth * 0.85),
                    child:  Text(
                      '${ S.of(context).yourName}',
                      style: TextStyle(color: Colors.white, fontSize: ScreenWidth * 0.033),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: ScreenWidth * 0.83,
                      height: ScreenHeight * 0.045,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenWidth * 0.038),
                          color: const Color(0xff1E2126),
                          border: Border.all(color: Colors.grey)),
                      margin:  EdgeInsets.only(top: ScreenHeight * 0.017),
                      alignment: isEnglish() ? FractionalOffset.centerLeft : FractionalOffset.centerRight,
                      padding: EdgeInsets.only(left: ScreenWidth * 0.024, right: ScreenWidth * 0.024),
                      child: Text(
                        accData.getString('firstName')![0].toUpperCase() +
                            accData.getString('firstName')!.substring(1).toLowerCase(),
                        style: TextStyle(color: Colors.grey, fontSize: ScreenWidth * 0.035),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: ScreenWidth * 0.83,
                      height: ScreenHeight * 0.045,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenWidth * 0.038),
                          color: const Color(0xff1E2126),
                          border: Border.all(color: Colors.grey)),
                      margin: EdgeInsets.only(top: ScreenHeight * 0.045),
                      alignment: isEnglish() ? FractionalOffset.centerLeft : FractionalOffset.centerRight,
                      padding:  EdgeInsets.only(left: ScreenWidth * 0.024, right: ScreenWidth * 0.024),
                      child: Text(
                          accData.getString('lastName')![0].toUpperCase() +
                              accData.getString('lastName')!.substring(1).toLowerCase(),
                        style: TextStyle(color: Colors.grey, fontSize: ScreenWidth * 0.035),
                      ),
                    ),
                  ),

                  Container(
                    margin:  isEnglish() ? EdgeInsets.only(top: ScreenHeight * 0.056, left: ScreenWidth * 0.071):
                    EdgeInsets.only(top: ScreenHeight * 0.056, left: ScreenWidth * 0.75),

                    child:  Text(
                      '${ S.of(context).personalInfo}',
                      style: TextStyle(color: Colors.white, fontSize: ScreenWidth * 0.035),
                    ),
                  ),
                  Container(
                      // margin:  EdgeInsets.symmetric(vertical: ScreenHeight * 0.0111, horizontal: ScreenWidth * 0.071),
                      margin: EdgeInsets.only(top:  ScreenHeight * 0.0111, left: ScreenWidth * 0.071),
                      height: ScreenHeight * 0.17,
                      child: Card(
                        elevation: ScreenWidth * 0.035,
                        color: const Color(0xff1E2126),
                        child: Row(

                            mainAxisSize: MainAxisSize.min,

                            children: isEnglish() ?[
                          Container(
                            // padding:  EdgeInsets.symmetric(
                            //     vertical: ScreenHeight * 0.022, horizontal: ScreenWidth * 0.047 ),
                            padding: EdgeInsets.only(top : ScreenHeight * 0.022, left: ScreenWidth * 0.047 ,right: ScreenWidth * 0.047 ),

                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${ S.of(context).userName}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('${S.of(context).email}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('${S.of(context).password}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                              ],
                            ),
                          ),
                          Container(
                            // padding:  EdgeInsets.symmetric(vertical: ScreenWidth * 0.047 ),
                            padding: EdgeInsets.only(top : ScreenHeight * 0.022),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(accData.getString('userName')!,
                                    style: TextStyle(color: Colors.white,fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                SizedBox(
                                    width: ScreenWidth * 0.58,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          accData.getString('email')!,
                                          style: TextStyle(
                                            color: Colors.white,
                                              fontSize: ScreenWidth * 0.033
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('********', style: TextStyle(color: Colors.white, fontSize: ScreenWidth * 0.033)),
                              ],
                            ),
                          )
                        ] : [
                          Container(
                            // padding:  EdgeInsets.symmetric(vertical: ScreenWidth * 0.047 ),
                            padding: EdgeInsets.only(top : ScreenHeight * 0.022),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(accData.getString('userName')!,
                                    style: TextStyle(color: Colors.white,fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                Container(
                                    alignment: Alignment.centerRight,
                                    width: ScreenWidth * 0.58,

                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,

                                        child: Text(
                                          accData.getString('email')!,
                                          style: TextStyle(
                                            color: Colors.white,
                                              fontSize: ScreenWidth * 0.033
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('*******', style: TextStyle(color: Colors.white, fontSize: ScreenWidth * 0.033)),
                              ],
                            ),
                          ),

                          Container(
                            // padding:  EdgeInsets.symmetric(
                            //     vertical: ScreenHeight * 0.022, horizontal: ScreenWidth * 0.047 ),
                            padding: EdgeInsets.only(top : ScreenHeight * 0.022, left: ScreenWidth * 0.047 ,right: ScreenWidth * 0.022 ),

                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${ S.of(context).userName}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('${S.of(context).email}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                                SizedBox(height: ScreenHeight * 0.020),
                                Text('${S.of(context).password}',
                                    style: TextStyle(color: Color(0xff727272),fontSize: ScreenWidth * 0.033)),
                              ],
                            ),
                          ),

                        ]),
                      )),
                  Center(
                    child: Container(
                      width: ScreenWidth * 0.42,
                      height: ScreenHeight * 0.045,
                      margin:  EdgeInsets.symmetric(vertical: ScreenHeight * 0.060),
                      child: ElevatedButton(
                        onPressed: () {
                          Login.LogOut();

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MainApp()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xff7E7EBE)),
                          overlayColor:
                              MaterialStateProperty.all(const Color(0xff61619D)),
                          splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                          elevation: MaterialStateProperty.all(ScreenWidth * 0.033),
                        ),
                        child:  Text(
                          '${S.of(context).logOut}',
                          style: TextStyle(color: Colors.white,fontSize: ScreenWidth * 0.033),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEnglish() => Intl.getCurrentLocale() == 'en';


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


    if(Language.getString('language').toString() == 'null'){
      print('Empty Shared');
      languageSharedPref();
    }else{
      S.load(Locale(Language.getString('language')!));
      setState(() {

      });
    }

  }

}

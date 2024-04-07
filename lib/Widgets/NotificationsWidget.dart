import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget{
  late SharedPreferences accData, loginInfo, Language;

  Notifications(this.accData, this.loginInfo, this.Language, {super.key});


  @override
  State<Notifications> createState() => _NotificationsState();

}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: isEnglish() ? ScreenWidth * 0.4 :ScreenWidth * 0.25,
              alignment: Alignment.center,
            margin: isEnglish() ?EdgeInsets.only(top: ScreenHeight * 0.027, right: ScreenWidth * 0.55) :
            EdgeInsets.only(top: ScreenHeight * 0.04, left:  ScreenWidth * 0.69),
            child: Text(
              S.of(context).notifications,
                style: TextStyle(
              fontSize: ScreenWidth * 0.06,
              color: Color(0xFF785FC0),fontWeight: FontWeight.bold)
            )
          ),
          Flexible(
              child: RefreshIndicator(
                  onRefresh: (){
                setState(() {});
                return readData1();
              },
                  child: FutureBuilder(
                    future: readData1(),
                    builder: (context, snapshot) {

                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return   Container(
                                height: ScreenHeight * 0.1,
                                child: CardVu(

                                  // sqldb.insertData('insert into Notifications(notification_id, person, receivedAt,  managerId) values(?,?,?,?)', [notification_id,message,DateTime.now().toString(), accData.getString('managerId')!]);

                                Notification: true,
                                    PersonOrEntity_title: snapshot.data![index]['person'].toString(),
                                    Date: snapshot.data![index]['receivedAt'].toString(),),
                              );
                            },
                          );
                        }else{
                          return Center(child: Text(S.of(context).noDataFound, style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenWidth * 0.05)));
                        }

                        }
                      return Center(child: CircularProgressIndicator());
                      }

                  ),
              )),
        ]
      ),
    );
  }

  bool isEnglish() => Intl.getCurrentLocale() == 'en';

  Future<List<Map>> readData1() async {

  print('read Data 1');
  cardData = await sqldb.readData(
      'SELECT * FROM Notifications where managerId = ${widget.accData.getString('managerId')} ');


  cardData = await sqldb.readData(
      'SELECT * FROM Notifications where managerId = ${widget.accData.getString('managerId')} order by receivedAt desc ');

  print(cardData[0]);

  print(' lol haha boom ${cardData.length}');

  return cardData;
}

}
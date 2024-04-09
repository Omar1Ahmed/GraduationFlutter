import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Meetings/CardView.dart';
import 'package:Meetings/Grad.dart';
import 'package:Meetings/Widgets/HomePageWidegt.dart';
import 'package:Meetings/Widgets/LoginWidget.dart';
import 'package:Meetings/Widgets/TestApi.dart';
import 'package:Meetings/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:Meetings/main.dart';


class NearestMeetings extends StatelessWidget{
  late ApiTest api;

  String currentDayDate = DateTime.now().toString().substring(0,10);

  var NearestMeetingDayDate = DateTime.now().add(Duration(days: Nearest.getInt("Days")! )).toString().substring(0,10);

  @override
  Widget build(BuildContext context) {
  api = ApiTest(context);
  print(currentDayDate);
  // print(NearestMeetingDayDate);
    return  SafeArea(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(margin:  isEnglish() ?EdgeInsets.only(top: ScreenHeight * 0.02,bottom: ScreenHeight * 0.02 ,right: ScreenWidth * 0.37) :EdgeInsets.only(top: ScreenHeight * 0.02,bottom: ScreenHeight * 0.02 ,left: ScreenWidth * 0.52),
              child: Column(

                children: [
                  Text(S.current.NearestMeetings, style: TextStyle(
                        color: Color(0xFF785FC0),fontSize: ScreenWidth * 0.06,fontWeight: FontWeight.bold)),
                ],
              )),

            Flexible(
              child: Container(
              alignment: Alignment.center,
                margin: EdgeInsets.only(left: ScreenWidth * 0.04,right: ScreenWidth * 0.04,top: ScreenHeight * 0.01),
                child: FutureBuilder(future: readData1(), builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return   CardVu(
                            MeetingId: snapshot.data![index]['meeting_id'].toString(),
                            PersonOrEntity_title: snapshot.data![index]['person'],
                            Topic_Content: snapshot.data![index]['about'].toString(),
                            Address_NoteId: snapshot.data![index]['address'],
                            PdfLink: snapshot.data![index]['attachmentLink'].toString(),
                            Date: snapshot.data![index]['date'],
                            Time: snapshot.data![index]['time']);
                      },
                    );
                  }if(ConnectionState.done == snapshot.connectionState && !snapshot.hasData){
                    return Center(child: Text(S.of(context).noDataFound));
                  }else {
                    return CircularProgressIndicator();
                  }
                }),),
            )
          ],
        ),
      );
  }

  Future<List<Map>> readData1() async {

    cardData = await sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'$NearestMeetingDayDate\' order by date ');
    // "time" time
    //  , "date" date,
    //  "about" text,
    //  "in_or_Out" text,
    //  "address" text ,
    //  "notes" text ,
    //  "person" text,
    //  "updatedAt" text,
    //  "attachmentLink" longText)
    //  "status" text,
    if(cardData.isEmpty ){
      // var request = await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&date[gte]=' + DateTime.now().toString(), {'token':'${loginInfo.getString('token')}'});
      // print(request);
      cardData = await sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'$NearestMeetingDayDate\' order by date ');
    }
    print('Notes $cardData');


    return cardData;
  }
  bool isEnglish() => Intl.getCurrentLocale() == 'en';

}
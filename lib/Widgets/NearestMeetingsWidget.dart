import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/TestApi.dart';

class NearestMeetings extends StatelessWidget{
  late ApiTest api;
  @override
  Widget build(BuildContext context) {
  api = ApiTest(context);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(

          children: [
            Container(margin: const EdgeInsets.only(top: 60),
                child: const Text('Nearest Meetings', style: TextStyle(
                    color: Colors.deepPurple,fontSize: 30,fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,decorationThickness: 2,decorationColor: Colors.deepPurpleAccent))),
            Container(

              height: 695,
              margin: const EdgeInsets.only(left: 30,right: 30),
              child: FutureBuilder(future: readData1(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return   CardVu(
                          PersonOrEntity_title: snapshot.data![index]['person'],
                          Topic_Content: snapshot.data![index]['about'].toString(),
                          Address_NoteId: snapshot.data![index]['address'],
                          Date: snapshot.data![index]['date'],
                          Time: snapshot.data![index]['time']);
                    },
                  );
                }else {
                  return CircularProgressIndicator();
                }
              }),)
          ],
        ),
      ),
    );
  }

  Future<List<Map>> readData1() async {

    cardData = await sqldb.readData('SELECT * FROM Meetings');
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
      cardData = await sqldb.readData('SELECT * FROM Meetings');
    }


    return cardData;
  }

}
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Notes extends StatefulWidget{

  late SharedPreferences accData, loginInfo;
  Notes(this.accData,this.loginInfo, {super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool insertion = false;
  late ApiTest api;
  String PreviousDayDate = DateTime.now().toString().substring(0,10);

  @override
  Widget build(BuildContext context) {
    api = ApiTest(context);
    return SafeArea(
      child: Stack(

        children: [

          Container(

            margin: const EdgeInsets.only(top: 100),

            child: FutureBuilder(future: readData1(), builder: (context, snapshot) {
              if (snapshot.hasData) {

                return GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(snapshot.data!.length+1, (index) {

                    return index == 0 ? CardVu(Grid: true,first: true) : CardVu(Grid: true,  PersonOrEntity_title: snapshot.data![index-1]['title'],Topic_Content: snapshot.data![index-1]['content'],Address_NoteId: snapshot.data![index-1]['notes_id'].toString(),);
                  }),

                  );
              }else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ],
      ),
    );
  }

  Future<List<Map>> readData1() async {


    cardData = await sqldb.readData('SELECT * FROM notes where manager_id = ${widget.accData.getString('managerId')} ');
    print(widget.accData.getString('managerId'));
    print('lolhahapopcard $cardData ');

    if(await api.hasNetwork()) {

      var Response;

      if (cardData.isEmpty) {
        print('empty');
        Response = await api.getRequest(
            'https://meetingss.onrender.com/notes?sort=createdAt',
            {'token': '${widget.loginInfo.getString('token')}'});

        print('lolhahapop $Response    ');

        await insertDataToLocalDb(Response);
        insertion = true;

    if(insertion ){
      cardData = await sqldb.readData(
          'SELECT * FROM notes where manager_id = ${widget.accData.getString(
              'managerId')} ');
      insertion = false;
    }
      }
    }


    print(cardData.length);
    return cardData;
  }

  Future<void> insertDataToLocalDb(String Response) async {

    if(api.getValue(Response, 'count')[0] != '0'){
      var notesIds = api.getValue(Response, 'notes_id');
      var notesTitles = api.getValue(Response, 'title');
      var notesContents = api.getValue(Response, 'content');
      var meetingIds = api.getValue(Response, 'meeting_id');
      var notesUpdatedAts = api.getValue(Response, 'updatedAt');


//"CREATE TABLE `notes` (\n" +
//       "  `notes_id` int(11) NOT NULL,\n" +
//       "  `title` varchar(255) NOT NULL,\n" +
//       "  `content` longtext DEFAULT NULL,\n" +
//       "  `meeting_id` int(11) DEFAULT NULL,\n" +
//       "  `manager_id` int(11) DEFAULT NULL,\n" +
//       "  `updatedAt` datetime NOT NULL\n" +
      print('length ${notesIds.length}');
      print('${notesContents[18]} ${notesIds[18]}  length');

      for(int i = 0; i < notesIds.length; i++){
        await sqldb.insertData('INSERT INTO notes(notes_id, title, content, meeting_id, updatedAt,manager_id) VALUES (?,?,?,?,?,?)', [
          notesIds[i],
          notesTitles[i],
          jsonEncode(notesContents[i]) ,
          meetingIds[i],
          notesUpdatedAts[i],
          widget.accData.getString('managerId')!,
        ]);

        print('${meetingIds[i]} Inserted');
      }
      // if(meetingIds.isNotEmpty){ meetingIds.clear();
      //  meetingTimes.clear();
      //  meetingDates.clear();
      //  meetingAbouts.clear();
      //  meetingInOrOuts.clear();
      //  meetingAddresses.clear();
      //  meetingComments.clear();
      //  meetingPersonsOrEntities.clear();
      //  meetingUpdatedAts.clear();
      //  meetingAttachLinks.clear();
      //  meetingAttachNames.clear();
      //  meetingStatuses.clear();}
    }
  }

}

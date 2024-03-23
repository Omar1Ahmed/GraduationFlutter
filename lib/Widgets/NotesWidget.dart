import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:learning/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Notes extends StatefulWidget{

  late SharedPreferences accData, loginInfo,Language;
  Notes(this.accData,this.loginInfo,this.Language, {super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool insertion = false;
  late ApiTest api;
  String PreviousDayDate = DateTime.now().toString().substring(0,10);

  @override
  void initState() {
    super.initState();

    languageSharedPrefInitialize();

  }
  @override
  Widget build(BuildContext context) {
    api = ApiTest(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           width: 100,

           child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,

           children: [
             Text('Notes', style: TextStyle(fontSize: 25, color: Color(0xFF785FC0),decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.double,fontWeight: FontWeight.bold,decorationColor: Color(0xFF8C7EBE),decorationThickness: 1),),
           ],
         ),margin: const EdgeInsets.only(top: 10,left: 20),),

          Flexible(
            child: RefreshIndicator(
              onRefresh: () { setState(() {

              });
                return readData1(); },
              child: Container(

                margin: const EdgeInsets.only(top: 30),

                child: FutureBuilder(future: readData1(), builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    return GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(snapshot.data!.length+1, (index) {
                        // print('${!snapshot.data![index-1]['content']} loliu');
                        return index == 0 ? CardVu(Grid: true,first: true) : CardVu(Grid: true,  PersonOrEntity_title: snapshot.data![index-1]['title'],Topic_Content: snapshot.data![index-1]['content'],Address_NoteId: snapshot.data![index-1]['notes_id'].toString(),MeetingId: snapshot.data![index-1]['meeting_id'].toString(),Topic: snapshot.data![index-1]['about'].toString(),Date: snapshot.data![index-1]['date'].toString(),PersonOrEntity : snapshot.data![index-1]['person'].toString());
                      }),

                      );
                  }else if(ConnectionState.done == snapshot.connectionState || snapshot.hasError){
                    return Center(child: Text('${snapshot.error}',style: TextStyle(color: Colors.white),));
                  }else {
                    return Center(child: const CircularProgressIndicator());
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map>> readData1() async {


    cardData = await sqldb.readData('SELECT * FROM notes where manager_id = ${widget.accData.getString('managerId')} ');

    if(await api.hasNetwork()) {

      var Response;

      if (cardData.isEmpty) {
        Response = await api.getRequest(
            'https://meetingss.onrender.com/notes?sort=createdAt',
            {'token': '${widget.loginInfo.getString('token')}'});
       print('Response $Response');
        await insertDataToLocalDb(Response);
        insertion = true;
    cardData = await sqldb.readData('SELECT * FROM notes where manager_id = ${widget.accData.getString('managerId')} ');

    if(insertion ){
      var meetingNoteDetails;

      for (int i = 0; i < cardData.length; i++) {
        if(cardData[i]['meeting_id'] != 'null'){

          meetingNoteDetails = await sqldb.readData('select meeting_id, date, about, person from meetings where meeting_id = ${cardData[i]['meeting_id']} ');


          await sqldb.updateData('update notes set meeting_id = ? ,about =  ? , date = ?, person = ?  where notes_id = ?', [
            cardData[i]['meeting_id'].toString(),
            meetingNoteDetails[0]['about'],
            meetingNoteDetails[0]['date'],
            meetingNoteDetails[0]['person'],
            cardData[i]['notes_id'].toString()
           ]);
        }
      }


      insertion = false;
    }
      }

    }

      cardData = await sqldb.readData(
          'SELECT * FROM notes where manager_id = ${widget.accData.getString(
              'managerId')} order by notes_id desc');

   print(cardData[0]);

    print(cardData.length);
    return cardData;
  }

  Future<void> insertDataToLocalDb(String Response) async {

    if(api.getValue(Response, 'count')[0] != '0'){
      var notesIds = api.getValue(Response, 'notes_id');
      var notesTitles = api.getValue(Response, 'title');
      var notesContents = api.getContent(Response);
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
      // print('${notesContents[18]} ${notesIds[18]}  length');

      for(int i = 0; i < notesIds.length; i++){
            await sqldb.insertData('INSERT INTO notes(notes_id, title, content, meeting_id, updatedAt,manager_id) VALUES (?,?,?,?,?,?)', [
              notesIds[i],
              notesTitles[i],
              notesContents[i],
              meetingIds[i],
              notesUpdatedAts[i],
              widget.accData.getString('managerId')!,
            ]);

        print('${notesContents[i]}');
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

  void languageSharedPref() async {
    if(Language.getString('language') == 'en'){
      S.load(Locale("en"));
    }else if(Language.getString('language') == 'ar'){
      S.load(Locale("ar"));

    }else{
      S.load(Locale("ar"));
      Language.setString('language', 'ar');
    }
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

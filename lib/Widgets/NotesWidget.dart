import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:learning/generated/l10n.dart';
import 'package:learning/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  late SharedPreferences accData, loginInfo, Language;

  Notes(this.accData, this.loginInfo, this.Language, {super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool insertion = false;
  late ApiTest api;
  String PreviousDayDate = DateTime.now().toString().substring(0, 10);

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: ScreenWidth * 0.25,
            alignment: Alignment.center,
            margin: isEnglish() ?EdgeInsets.only(top: ScreenHeight * 0.027, right: ScreenWidth * 0.74) :
        EdgeInsets.only(top: ScreenHeight * 0.04, left:  ScreenWidth * 0.69),
            child: Text(
              S.of(context).notes,
              style: TextStyle(
                fontSize: ScreenWidth * 0.06,
                color: Color(0xFF785FC0),fontWeight: FontWeight.bold),
            ),
            // margin: isEnglish() ?EdgeInsets.only(top: ScreenHeight * 0.02,left: ScreenWidth * 0.07):
            //  EdgeInsets.only(top: ScreenHeight * 0.02,left: ScreenWidth * 0.69),)
          ),
          Flexible(
              child: RefreshIndicator(

                onRefresh: () {
                  setState(() {});
                  return readData1();
                },
                child: Container(
                  margin: EdgeInsets.only(top: ScreenHeight * 0.02),
                  child: FutureBuilder(
                      future: readData1(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            print('has Data');
                            return GridView.count(
                              crossAxisCount: 2,
                              children: List.generate(snapshot.data!.length + 1, (index) {
                                return index == 0
                                    ? CardVu(Grid: true, first: true)
                                    : CardVu(
                                  Grid: true,
                                  PersonOrEntity_title:
                                  snapshot.data![index - 1]['title'],
                                  Topic_Content:
                                  snapshot.data![index - 1]['content'],
                                  Address_NoteId: snapshot.data![index - 1]
                                  ['notes_id']
                                      .toString(),
                                  MeetingId: snapshot.data![index - 1]['meeting_id']
                                      .toString(),
                                  Topic: snapshot.data![index - 1]['about'].toString(),
                                  Date: snapshot.data![index - 1]['date'].toString(),
                                  PersonOrEntity: snapshot.data![index - 1]['person']
                                      .toString(),
                                );
                              }),
                            );
                          } else if (snapshot.hasError) {
                            print('has Error');
                            return Center(
                              child: Text(
                                '${snapshot.error}\n${S.current.noDataFound}',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }
                        print('Loading');
                        return Center(child: const CircularProgressIndicator());
                      },),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Future<List<Map>> readData1() async {

    print('read Data 1');
    cardData = await sqldb.readData(
        'SELECT * FROM notes where manager_id = ${widget.accData.getString('managerId')} ');
    print(cardData.length);
    if (await api.hasNetwork()) {
      print('has Network');
      var Response;

      if (cardData.isEmpty) {
        print('Empty Data');
        Response = await api.getRequest(
            'https://meetingss.onrender.com/notes?sort=createdAt',
            {'token': '${widget.loginInfo.getString('token')}'});
        await insertDataToLocalDb(Response);
        insertion = true;
        cardData = await sqldb.readData(
            'SELECT meeting_id,notes_id FROM notes where manager_id = ${widget.accData.getString('managerId')} and meeting_id is not "0"');
        print('oooooo   ${cardData}');

        if (insertion) {
          var meetingNoteDetails;

          for (int i = 0; i < cardData.length; i++) {
            print('${cardData[i]['meeting_id']} $i ${cardData.length} ${cardData  } ${ cardData[i]['notes_id']}');
            if (cardData[i]['meeting_id'] != 0 ) {
              meetingNoteDetails = await sqldb.readData('select about, person, date from meetings where meeting_id = ${cardData[i]['meeting_id']}');
             if(meetingNoteDetails.isEmpty) {
               meetingNoteDetails = await api.getRequest(
                   'https://meetingss.onrender.com/meetings/${cardData[i]['meeting_id']}',
                   {'token': '${widget.loginInfo.getString('token')}'});
             }
             print('${meetingNoteDetails.runtimeType} ${cardData.runtimeType}');
             print('haha meeting${meetingNoteDetails}  ${cardData[i]['meeting_id']}');

            await sqldb.updateData(
                  'update notes set meeting_id = ? ,about =  ? , date = ?, person = ?  where notes_id = ?',
                  [
                    cardData[i]['meeting_id'].toString(),
                    meetingNoteDetails.runtimeType == String ? api.getValue(meetingNoteDetails, 'about')[0] : meetingNoteDetails['about'],
                    meetingNoteDetails.runtimeType == String ?  api.getValue(meetingNoteDetails, 'date')[0] : meetingNoteDetails['date'],
                    meetingNoteDetails.runtimeType == String ?  api.getValue(meetingNoteDetails, 'person')[0] : meetingNoteDetails['person'],
                    cardData[i]['notes_id'].toString()
                  ]);
            }
          }

          insertion = false;
        }
      }
    }

    cardData = await sqldb.readData(
        'SELECT * FROM notes where manager_id = ${widget.accData.getString('managerId')} order by updatedAt desc');

    print(cardData[0]);

    print(' lol haha boom ${cardData.length}');

    return cardData;
  }

  Future<void> insertDataToLocalDb(String Response) async {
    if (api.getValue(Response, 'count')[0] != '0') {
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
      // print('${notesContents[18]} ${notesIds[18]}  length');

      for (int i = 0; i < notesIds.length; i++) {
        await sqldb.insertData(
            'INSERT INTO notes(notes_id, title, content, meeting_id, updatedAt,manager_id) VALUES (?,?,?,?,?,?)',
            [
              notesIds[i],
              notesTitles[i],
              notesContents[i],
              meetingIds[i].toString().compareTo( 'null') == 0 ? '0': meetingIds[i].toString(),
              notesUpdatedAts[i],
              widget.accData.getString('managerId')!,
            ]);
        print('${meetingIds[i]} ${meetingIds[i].toString().compareTo( 'null')}' );
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
    if (Language.getString('language') == 'en') {
      S.load(Locale("en"));
    } else if (Language.getString('language') == 'ar') {
      S.load(Locale("ar"));
    } else {
      S.load(Locale("ar"));
      Language.setString('language', 'ar');
    }
  }

  void languageSharedPrefInitialize() async {
    Language = await SharedPreferences.getInstance();

    if (Language.getString('language').toString() == 'null') {
      print('Empty Shared');
      languageSharedPref();
    } else {
      S.load(Locale(Language.getString('language')!));
      setState(() {});
    }
  }

  bool isEnglish() => Intl.getCurrentLocale() == 'en';
}

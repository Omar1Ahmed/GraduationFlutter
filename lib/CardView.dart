import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/NoteViewerWidget.dart';
import 'package:learning/generated/l10n.dart';
import 'package:intl/intl.dart';

import 'Widgets/pdfViewer.dart';

class CardVu extends StatefulWidget {
  final bool Grid, first;
  final String PersonOrEntity_title,
      Topic_Content,
      Address_NoteId,
      Date,
      Time,
      PdfLink,
      Comments,
      MeetingId,
      Topic,
      PersonOrEntity;
  late List<Map> note;
  static int counter = 0;

  CardVu(
      {super.key,
      this.Grid = false,
      this.first = false,
      this.PersonOrEntity_title = '',
      this.Topic_Content = '',
      this.Address_NoteId = '',
      this.Date = '',
      this.Time = '',
      this.PdfLink = '',
      this.Comments = '',
      this.MeetingId = '',
      this.Topic = '',
      this.PersonOrEntity =''});
late String DateToShow;
late String TimeToShow;
  State<CardVu> createState() => _CardVuState();
}

class _CardVuState extends State<CardVu> {
  late var MeetingDate_Grid;

  @override
  void initState() {
    _controller = ScrollController(); // Initializing ScrollController
    _controller.addListener(() {
      _scrollListener();
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    widget.DateToShow = widget.Date.toString().compareTo(DateTime.now().toString().substring(0, 10)) == 0 ? S.current.Today : widget.Date.toString().compareTo(DateTime.now().add(const Duration(days: 1)).toString().substring(0, 10))== 0 ? S.of(context).Tomorrow : widget.Date;

   if(!widget.Grid){ widget.TimeToShow = DateFormat('hh:mm a').format(DateFormat('hh:mm:ss','en').parse(widget.Time));}
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      // height: widget.Grid == true ? 150 : null,
      child: InkWell(
        onTap: () async  {
          if (widget.Grid){
              if (widget.first)
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddNote(true)));
                }
              else
                {
                  widget.note = await sqldb.readData(
                      'select * from notes where notes_id = ${widget.Address_NoteId}');
                  // print(' hh' +widget.note[16]['content'].toString()),
                  print(' lol haha pop ${widget.note[0]['content'].runtimeType}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(

                          builder: (context) => AddNote(
                                false,
                                title: widget.note[0]['title'],
                                content: widget.note[0]['content'],
                                noteId: widget.note[0]['notes_id'].toString(),
                                meetingId: widget.MeetingId,
                                meetingTopic: widget.Topic,
                                meetingDate: widget.Date,
                                meetingPersonOrEntity: widget.PersonOrEntity,
                              )));
                }
            }else{
            print('${widget.MeetingId} ${widget.Topic} ${widget.PersonOrEntity_title} shhheeeeeesh');
            var id = await sqldb.readData('select * from notes where meeting_id = ${widget.MeetingId} and manager_id = ${accData.getString('managerId')}');
            ShowModal(id);
          }
        },
        child: Card(

            color: const Color(0xff1E2126),
            elevation: 10,
            child: widget.Grid == true
                ? (widget.first
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[300],
                              size: 40,
                            ),
                          ),
                          Text(
                            S.current.addNote,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 60),
                              child :Column(
                               children :[Text(
                            widget.PersonOrEntity_title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${widget.MeetingId == 'null' ? S.current.noMeetings : widget.Topic} ',
                            style: const TextStyle(color: Colors.white54),
                          ),])),
                         SizedBox(height: ScreenHeight * 0.06,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: ScreenWidth * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  widget.Date == 'null' ? '' : widget.Date ,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(widget.PersonOrEntity == 'null' ? '': widget.PersonOrEntity ,
                                  style: const TextStyle(color: Colors.white),)
                              ]
                            ),
                          )
                        ],
                      ))
                : Column(
                    children: [
                      ListTile(
                        title:  Text(
                          S.current.personOrEntity,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF7E7EBE),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          widget.PersonOrEntity_title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title:  Text(
                          S.current.topic,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF7E7EBE),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          widget.Topic_Content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title:  Text(
                          '${ S.current.address} ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF7E7EBE),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          widget.Address_NoteId,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEnglish() ? widget.DateToShow : widget.TimeToShow,
                              style: const TextStyle(color: Color(0xFF7E7EBE)),
                            ),
                            Text(
                              isEnglish() ? widget.TimeToShow : widget.DateToShow,
                              style:  TextStyle(color: const Color(0xFF7E7EBE),fontSize: isEnglish()? 15 : 16),
                            ),
                          ])
                    ],
                  )),
      ),
    );
  }

  Future<void> ShowModal(dynamic id) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => _showModalBottomSheet(id),
    );
  }

  late ScrollController _controller;

  List<double> positions = [];

  _scrollListener() {}

  Widget _showModalBottomSheet(dynamic id) => DraggableScrollableSheet(
        expand: false,
        key: UniqueKey(),
        initialChildSize: 0.4,
        maxChildSize: 0.7,
        minChildSize: .3,
        builder: (context, controller)

        {
 return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF272A37),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70)),
                      ),
                      padding: const EdgeInsets.only(left: 20),
                      child: ListView(
                        controller: controller,
                        children: [
                          SizedBox(
                            height: 59,
                            child: const Divider(
                              thickness: 3,
                              indent: 150,
                              endIndent: 150,
                            ),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.02,
                          ),
                          Text(
                            S.current.personOrEntity,
                            style: const TextStyle(
                                color: Color(0xFF7E7EBE), fontSize: 19),
                          ),
                          Text(
                            '  ${widget.PersonOrEntity_title}',
                            style:
                                const TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            S.current.topic,
                            style: const TextStyle(
                                color: Color(0xFF7E7EBE), fontSize: 19),
                          ),
                          Text(
                            '  ${widget.Topic_Content}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            '${S.current.address} ',
                            style: const TextStyle(
                                color: Color(0xFF7E7EBE), fontSize: 19),
                          ),
                          Text(
                            '  ${widget.Address_NoteId}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            '${S.current.Time} ',
                            style: const TextStyle(
                                color: Color(0xFF7E7EBE), fontSize: 19),
                          ),
                          Text(
                            '  ${widget.DateToShow} ${widget.TimeToShow}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Text(
                            '${S.current.comments} ',
                            style: const TextStyle(
                                color: Color(0xFF7E7EBE), fontSize: 19),
                          ),
                          Text(
                            '  ${widget.Comments.isEmpty ? '--------' : widget.Comments}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 15),
                          ),
                          Container(
                              alignment: AlignmentDirectional.centerStart,
                              margin: const EdgeInsets.only(top: 10),
                              width: 10,
                              child: widget.PdfLink != 'null'
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    pdfViewer(widget.PdfLink)));
                                      },
                                      child: Text(
                                        S.current.openPdf,
                                      ))
                                  : const Text('No Pdf'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                      width: id.isEmpty? ScreenWidth * 0.25 : ScreenWidth * 0.3,
                      margin: EdgeInsets.only(
                          bottom: ScreenHeight * 0.03,
                          right: ScreenWidth * 0.04),
                      child: FloatingActionButton(
                        onPressed: () async {
                          if (id.isEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNote(
                                          true,
                                          meetingId: widget.MeetingId,
                                          meetingDate: widget.Date,
                                          meetingTopic: widget.Topic_Content,
                                          meetingPersonOrEntity:
                                              widget.PersonOrEntity_title,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNote(
                                          false,
                                          meetingId: widget.MeetingId,
                                          content: id[0]['content'],
                                          title: id[0]['title'],
                                        )));
                          }
                        },
                        child: Row(
                          children: id.isNotEmpty ? [const Icon(Icons.sticky_note_2_outlined), Text(S.current.ShowNote)] :
                          [
                            const Icon(Icons.add),
                            Text(S.current.addNote)
                          ],
                        ),
                      )))
            ],
          );
        },
      );
  bool isEnglish() => Intl.getCurrentLocale() == 'en';
}

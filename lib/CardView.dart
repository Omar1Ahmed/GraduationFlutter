import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/NoteViewerWidget.dart';

import 'Widgets/pdfViewer.dart';

class CardVu extends StatefulWidget {
  final bool Grid, first;
  final String PersonOrEntity_title,
      Topic_Content,
      Address_NoteId,
      Date,
      Time,
      PdfLink;
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
      this.PdfLink = ''});

  State<CardVu> createState() => _CardVuState();
}

class _CardVuState extends State<CardVu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      // height: widget.Grid == true ? 150 : null,
      child: InkWell(
        onTap: () async => {
          if (widget.Grid)
            {
              if (widget.first)
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddNote(true)))
                }
              else
                {
                  widget.note = await sqldb.readData(
                      'select * from notes where notes_id = ${widget.Address_NoteId}'),
                  // print(' hh' +widget.note[16]['content'].toString()),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNote(
                                false,
                                title: widget.note[0]['title'],
                                content: widget.note[0]['content'],
                                noteId: widget.note[0]['notes_id'].toString(),
                              )))
                }
            }
          else
            {ShowModal()}
        },
        child: Card(
            color: const Color(0xff1E2126),
            elevation: 10,
            child: widget.Grid == true
                ? (widget.first
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Add Note',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.PersonOrEntity_title,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ))
                : Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'Person or Entity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                        title: const Text(
                          'Meeting Topic',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                        title: const Text(
                          'Meeting Address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                              widget.Date,
                              style: const TextStyle(color: Color(0xFF7E7EBE)),
                            ),
                            Text(
                              widget.Time,
                              style: const TextStyle(color: Color(0xFF7E7EBE)),
                            ),
                          ])
                    ],
                  )),
      ),
    );
  }

  Future<void> ShowModal() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => _showModalBottomSheet(),
    );
  }

  late ScrollController _controller;

  List<double> positions = [];

  @override
  void initState() {
    _controller = ScrollController(); // Initializing ScrollController
    _controller.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

  _scrollListener() {}

  Widget _showModalBottomSheet() => DraggableScrollableSheet(
        expand: false,
        key: UniqueKey(),
        initialChildSize: 0.4,
        maxChildSize: 0.7,
        minChildSize: .3,
        builder: (context, controller) => Column(
          children: [
            Container(
              height: 59,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Color(0xFF272A37)),
              child: const Divider(
                thickness: 3,
                indent: 150,
                endIndent: 150,
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF272A37),
                padding: const EdgeInsets.only(left: 20),
                child: ListView(
                  controller: controller,
                  children: [
                    const Text(
                      'Person Or Entity',
                      style: TextStyle(color: Color(0xFF7E7EBE), fontSize: 18),
                    ),
                    Text(
                      '  ${widget.PersonOrEntity_title}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const Text(
                      'Meeting Topic',
                      style: TextStyle(color: Color(0xFF7E7EBE), fontSize: 18),
                    ),
                    Text(
                      '  ${widget.Topic_Content}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const Text(
                      'Meeting Address',
                      style: TextStyle(color: Color(0xFF7E7EBE), fontSize: 18),
                    ),
                    Text(
                      '  ${widget.Address_NoteId}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const Text(
                      'Meeting Time',
                      style: TextStyle(color: Color(0xFF7E7EBE), fontSize: 18),
                    ),
                    Text(
                      '  ${widget.Time}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const Text(
                      'Meeting Comments',
                      style: TextStyle(color: Color(0xFF7E7EBE), fontSize: 18),
                    ),
                    Text(
                      '  ${widget.Date}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Container(
                        alignment: AlignmentDirectional.centerStart,
                        margin: const EdgeInsets.only(top: 10),
                        width: 10,
                        child: widget.PdfLink != 'null'
                            ? ElevatedButton(
                                onPressed: () async {
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => pdfViewer(widget.PdfLink)));
                                }, child: const Text('Open Pdf'))
                            : const Text('No Pdf'))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

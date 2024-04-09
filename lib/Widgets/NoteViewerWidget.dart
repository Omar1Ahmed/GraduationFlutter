import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Meetings/Grad.dart';
import 'package:Meetings/Widgets/HomePageWidegt.dart';
import 'package:Meetings/Widgets/LoginWidget.dart';
import 'package:Meetings/Widgets/NotesWidget.dart';
import 'package:Meetings/Widgets/TestApi.dart';
import 'package:Meetings/generated/l10n.dart';
import 'package:Meetings/main.dart';

class AddNote extends StatefulWidget {
  String title,
      noteId,
      meetingId,
      meetingDate,
      meetingTopic,
      meetingPersonOrEntity;
  bool first;
  var content;

  AddNote(this.first,
      {this.title = '',
      this.content = const [],
      this.noteId = '',
      this.meetingId = '',
      this.meetingDate = '',
      this.meetingTopic = '',
      this.meetingPersonOrEntity = ''});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late final quill.QuillController _controller;
  late TextEditingController txtTitle;

  bool newContent = false;

  @override
  void initState() {
    super.initState();

    if (widget.content.length != 0) {
      widget.content = widget.content.toString().replaceAll(r'\"', '"');
      widget.content = widget.content.toString().replaceAll(r'\\n', r'\n');
      txtTitle = TextEditingController(text: '${widget.title}');

      _controller = quill.QuillController(
        // [{'insert': 'sdfgTransitions\n\nYou can animate the opening and closing of the Popup using CSS transitions, CSS animations, or third-party animation libraries. It supports the API described on the Base UI hhjjjjjjjjjjjjhjjjhjhnnnnTransitions page.cvvvvv\nJ\nDisable portal\n'},
        //       {'insert': 'Hgghh', 'attributes': {'bold': true}}, {'insert': 'hjjjjukk', 'attributes': {'bold': true, 'italic': true, 'underline': true, 'color': '#FFF48FB1'}}, {'insert':'\nTo render the Popup where it\'sbb'}, {'insert': 'k', 'attributes': {'bold': true}}, {'insert':'\n'}]

        document: quill.Document.fromJson(jsonDecode(widget.content as String)),
        selection: TextSelection.collapsed(offset: 0),
      );
    } else {
      txtTitle = TextEditingController(text: '${widget.title}');

      _controller = quill.QuillController.basic();
    }

    txtTitle.addListener(() {
      if (newContent == false &&
          '[${widget.title}]' != txtTitle.text &&
          txtTitle.text.isNotEmpty) {
        setState(() {
          newContent = true;
        });
      } else {
        if (newContent && txtTitle.text.isEmpty) {
          setState(() {
            newContent = false;
          });
        }
      }
    });

    _controller.document.changes.listen((event) {
      // print(event.before);
      if (newContent == false &&
          '[${widget.content}]' !=
              jsonEncode(_controller.document.toDelta().toJson())) {
        setState(() {
          newContent = true;
        });
      } else {
        if (newContent &&
            '[${widget.content}]' ==
                jsonEncode(_controller.document.toDelta().toJson())) {
          setState(() {
            newContent = false;
          });
        }
      }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.first} ${widget.content} ${widget.title} ${widget.noteId} ${widget.meetingId} ${widget.meetingDate} ${widget.meetingTopic} ${widget.meetingPersonOrEntity} notes Data ');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF272A37),
        body: Container(
          child: Column(children: [
            Container(
              color: Color(0xFF343C4B),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF252936),
                          )),
                      Container(
                          width: ScreenWidth * 0.65,
                          child: TextField(
                            controller: txtTitle,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'Add Title....',
                                hintStyle: TextStyle(color: Colors.grey[600])),
                          )),
                    ],
                  ),
                  InkWell(
                      onTap: () async {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        var json = jsonEncode(
                            _controller.document.toDelta().toJson() as List);
                        print(_controller.document.toPlainText().isNotEmpty);
                        print(_controller.document.toPlainText().isEmpty);
                        print(_controller.document.toPlainText().length == 1);
                        print('l${_controller.document.toPlainText()}');
                        if (txtTitle.text.isNotEmpty) {
                          if (_controller.document.toPlainText().length != 1) {
                            if (!widget.first) {
                              setState(() {
                                newContent = false;
                              });
                              widget.content = json;

                              ApiTest api = ApiTest(context);
                              if (await api.hasNetwork()) {
                              sqldb.updateData(
                                  'UPDATE notes SET content = ?,title = ? WHERE notes_id = ?',
                                  [json, txtTitle.text, widget.noteId]);
                                await api.patchRequest(
                                    'https://meetingss.onrender.com/notes/${widget.noteId}',
                                    {
                                      'Content-Type': 'application/json',
                                      'token': '${loginInfo.getString('token')}'
                                    },
                                    jsonEncode({
                                      "title": "${txtTitle.text}",
                                      "content": "${json}"
                                    }));
                              }

                              print('insert');
                              Navigator.pop(context);

                            } else {
                              setState(() {
                                newContent = false;
                              });
                              if(widget.meetingId.isEmpty){
                              if (await api.hasNetwork()) {
                                var lol = await api.postRequest(
                                    'https://meetingss.onrender.com/notes/',
                                    {
                                      'token':
                                          '${loginInfo.getString('token')}',
                                      'Content-Type': 'application/json',
                                    },
                                    jsonEncode({
                                      "title": txtTitle.text,
                                      "content": json,
                                    }));

                                  await sqldb.insertData(
                                      'INSERT INTO notes(notes_id, title, content, meeting_id, updatedAt,manager_id) VALUES (?,?,?,?,?,?)',
                                      [
                                        await api.getValue(lol, 'noteId')[0],
                                        txtTitle.text,
                                        json.toString(),
                                        'null',
                                        DateTime.now().toString(),
                                        accData.getString('managerId')!,
                                      ]);


                                }

                              }else{
                                if (await api.hasNetwork()) {
                                  var lol = await api.postRequest(
                                      'https://meetingss.onrender.com/notes/${widget.meetingId}',
                                      {
                                        'token':
                                        '${loginInfo.getString('token')}',
                                        'Content-Type': 'application/json',
                                      },
                                      jsonEncode({
                                        "title": txtTitle.text,
                                        "content": json,
                                      }));

                                  await sqldb.insertData(
                                      'INSERT INTO notes(notes_id, title, content, meeting_id,about,date,person ,updatedAt,manager_id) VALUES (?,?,?,?,?,?,?,?,?)',
                                      [
                                        await api.getValue(lol, 'noteId')[0],
                                        txtTitle.text,
                                        json.toString(),
                                        widget.meetingId,
                                        widget.meetingTopic,
                                        widget.meetingDate,
                                        widget.meetingPersonOrEntity,
                                        DateTime.now().toString(),
                                        accData.getString('managerId')!,
                                      ]);


                                }
                              }
                                print('insert');
                                Navigator.pop(context);

                            }
                          } else {
                            FToast f = FToast();
                            f.init(context);
                            f.showToast(
                                child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(70)),
                              padding: EdgeInsets.all(ScreenWidth * 0.02),
                              child: Text(
                                '${S.current.noContent}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                          }
                        } else {
                          FToast f = FToast();
                          f.init(context);
                          f.showToast(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(70)),
                            padding: EdgeInsets.all(ScreenWidth * 0.02),
                            child: Text(
                              '${S.current.noTitle}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                        }
                      },
                      child: Container(
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: newContent ? Colors.white : Colors.grey),
                        ),
                        padding: EdgeInsets.only(right: ScreenWidth * 0.05),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenHeight * 0.015,
                    horizontal: ScreenWidth * 0.05),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: quill.QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  color: Colors.grey[400],
                  showDividers: false,
                  multiRowsDisplay: false,
                ))),
            Expanded(
              child: quill.QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                controller: _controller,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenWidth * 0.05,
                    vertical: ScreenHeight * 0.035),
                customStyles: const quill.DefaultStyles(
                  color: Colors.white,
                  paragraph: quill.DefaultTextBlockStyle(
                      TextStyle(color: Colors.white, fontSize: 20),
                      quill.VerticalSpacing(0, 0),
                      quill.VerticalSpacing(0, 0),
                      BoxDecoration()),
                ),
              )),
            ),
            InkWell(
              child: Text('data'),
              onTap: () async {
                await sqldb.deleteAllData('delete from notes');
                print((_controller.document.toDelta().toString()));
              },
            )
          ]),
        ),
      ),
    );
  }

// List<Map<String, dynamic>> convertToQuillFormat(String input) {
//
//   List<Map<String, dynamic>> resultList = [];
//
//   // Split input by lines
//   List<String> lines = input.split('\n');
//
//   // Iterate through each line
//   for (String line in lines) {
//     // Trim whitespace from line
//     line = line.trim();
//
//     // Check if line is empty
//     if (line.isEmpty) continue;
//
//     // Split line by ⟨ and ⟩
//     List<String> parts = line.split('⟨');
//     String content = parts[1].split('⟩')[0].trim();
//     content = content.replaceAll('⏎', '\n');
//     // Check for attributes
//     Map<String, dynamic> attributes = {};
//     if (parts.length > 1 && parts[1].contains('+')) {
//       String attrString = parts[1].split('+')[1].trim();
//       List<String> attrPairs = attrString.split(',');
//       for (String pair in attrPairs) {
//         List<String> keyValue = pair.split(':');
//         String key = keyValue[0].trim();
//         // Remove extra braces around attributes
//         String value = keyValue[1].replaceAll(RegExp(r'[{,}]'), '').trim();
//         attributes[key] = value;
//       }
//     }
//
//     // Add content and attributes to result list
//     Map<String, dynamic> segmentMap = {'insert': content};
//     if (attributes.isNotEmpty) {
//       segmentMap['attributes'] = attributes;
//     }
//     resultList.add(segmentMap);
//   }
//   return resultList;
// }
}

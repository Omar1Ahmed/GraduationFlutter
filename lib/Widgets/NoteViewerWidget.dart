import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:learning/Grad.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/TestApi.dart';

class AddNote extends StatefulWidget {
  String title, content,noteId;
  bool first;

  AddNote(this.first, {this.title = '', this.content = '', this.noteId = ''});

  @override
  State<AddNote> createState() => _AddNoteState();
}


class _AddNoteState extends State<AddNote> {
  late final quill.QuillController _controller;
  late TextEditingController txtTitle ;

  bool newContent = false;
  @override
  void initState() {
    super.initState();
    print('${widget.content}');
    // widget.content = widget.content.replaceAll('insert', '\'insert\'');
    print('${widget.title}');

    txtTitle = TextEditingController(text: '${widget.title}');
    widget.content = widget.content.replaceAll('\n', '');
        print(widget.content);print('----------');
        print(widget.content);
    // try{ jsonDecode(widget.content);}catch(e){widget.content = r'{"insert":"lol\n"}';};
        print('----------');
    _controller = quill.QuillController(
      // [{'insert': 'sdfgTransitions\n\nYou can animate the opening and closing of the Popup using CSS transitions, CSS animations, or third-party animation libraries. It supports the API described on the Base UI hhjjjjjjjjjjjjhjjjhjhnnnnTransitions page.cvvvvv\nJ\nDisable portal\n'},
      //       {'insert': 'Hgghh', 'attributes': {'bold': true}}, {'insert': 'hjjjjukk', 'attributes': {'bold': true, 'italic': true, 'underline': true, 'color': '#FFF48FB1'}}, {'insert':'\nTo render the Popup where it\'sbb'}, {'insert': 'k', 'attributes': {'bold': true}}, {'insert':'\n'}]

      document: quill.Document.fromJson(
      // jsonDecode(widget.content)
      //       widget.content == r'{"insert":"lol\n"}' ?
      //       jsonDecode(widget.content) :
            jsonDecode(widget.content)
   // [
   //          {"insert": "widget.content\n"}
   //        ]
      ),
      selection: TextSelection.collapsed(offset: 0),
    );


    _controller.document.changes.listen((event) {
      // print(event.before);
      print('---------------------------');
      print('[${widget.content}]');
      print(jsonEncode(_controller.document.toDelta().toJson()));
      print('[${widget.content}]' != jsonEncode(_controller.document.toDelta().toJson()));
      if(newContent == false && '[${widget.content}]' != jsonEncode(_controller.document.toDelta().toJson())) {
        setState(() {

          newContent = true;
        });
      }else{
        if(newContent && '[${widget.content}]' == jsonEncode(_controller.document.toDelta().toJson())){
          setState(() {
            newContent =false;
          });
        }
      }
     // }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(children: [

                  IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new,color: Color(0xFF252936),)),
                  Container(width: 100 ,child: TextField(controller: txtTitle, style: TextStyle(color: Colors.white),decoration: InputDecoration(hintText: 'Add Title....',hintStyle: TextStyle(color: Colors.grey[600])),)),
                  ],),
                  InkWell(onTap:() async {
                  if(newContent) {
                    newContent =false;
                     var json = jsonEncode(_controller.document.toDelta().toJson());
                    widget.content = json;

                    print('$json   popopop');
                    ApiTest api = ApiTest(context);
                     sqldb.updateData(
                         'UPDATE notes SET content = ?,title = ? WHERE notes_id = ?',[json, txtTitle.text, widget.noteId]);
                   if(await api.hasNetwork()) {


                     var haha = jsonEncode({"title": "${txtTitle.text}", "content": "${jsonEncode(_controller.document.toDelta().toJson())}"});

                     print('https://meetingss.onrender.com/notes/${widget.noteId}  ${jsonEncode({"title": "${txtTitle.text}", "content": "${jsonEncode(_controller.document.toDelta().toJson())}"})}');
                      var s = await api.patchRequest('https://meetingss.onrender.com/notes/61', {'Content-Type':'application/json','token': '${loginInfo.getString('token')}'}, jsonEncode({"title": "${txtTitle.text}", "content": "${jsonEncode(_controller.document.toDelta().toJson())}"}));
                    print('$s lololol');
                   }else{
                    print('no Internt');
                   }
                  }
                  },

                      child: Container(child: Text('Save',style: TextStyle(color: newContent ? Colors.white : Colors.grey),),padding: EdgeInsets.only(right: 20),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  customStyles: const quill.DefaultStyles(color: Colors.white,paragraph: quill.DefaultTextBlockStyle(TextStyle(color: Colors.white,fontSize: 20), quill.VerticalSpacing(0,0), quill.VerticalSpacing(0,0),BoxDecoration()),),
            )),),
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

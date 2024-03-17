import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class ApiTest  {
  ApiTest(this.context);
  BuildContext context;

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {

      FToast f = FToast();
      f.init(context);
      f.showToast(

        child: Container(

          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(70)),
          padding: EdgeInsets.all(10),
          child:Text("No Internet Connection!!", style: TextStyle(color: Colors.white),),),
        gravity: ToastGravity.BOTTOM,

      );
      return false;
    }
  }


  Future<String> postRequest (String link, Map<String,String> header,Object body ) async{
  print(body);
    var response = await post(Uri.parse(link),
        headers:  header,
        body: body);


    return response.body;
  }
  Future<String> getRequest (String link, Map<String,String> header) async{
    var response = await get(Uri.parse(link),
        headers:  header);
    return response.body;
  }

  Future<String> patchRequest (String link, Map<String,String> header,Object body ) async{
    var Response;
    try {
      Response = await patch(Uri.parse(link), headers: header, body: body);
    }catch(e){
      print(e);
    }
    return Response.body;
  }


  List<String> getValue(String jsonData, String key) {
    List<String> values = [];

    if (jsonData.contains('"$key":')) {
      List<String> array = jsonData.split('"$key":');
      values = List<String>.filled(array.length - 1, '');

      for (int loop = 1; loop < array.length; loop++) {
        values[loop - 1] = array[loop].trim();
        if (values[loop - 1].startsWith('"')) {
         if(key == 'message') {
           values[loop - 1] = values[loop - 1].substring(1, values[loop - 1].indexOf('"', 40));
         }else{
           values[loop - 1] = values[loop - 1].substring(1, values[loop - 1].indexOf('"', 2));

         }

        } else if (values[loop - 1].startsWith('[')) {

          values[loop - 1] = values[loop - 1].substring(1, values[loop - 1].indexOf(']', 2));
        }else if (values[loop - 1].startsWith('{')) {

          values[loop - 1] = values[loop - 1].substring(1, values[loop - 1].indexOf('}', 2));
        } else {
          if(key == 'content'){
            values[loop -1 ] = values[loop - 1].substring(values[loop - 1].indexOf('['), values[loop - 1].indexOf(']'));
          }
          if( (values[loop - 1].endsWith('},{') || values[loop - 1].endsWith('},')) && values[loop - 1].length < 20){

            values[loop - 1] = values[loop - 1].substring(0, values[loop - 1].indexOf('}',1));
          }else if(values[loop - 1].endsWith('}]}')&& values[loop - 1].length < 15){

            values[loop - 1] = values[loop - 1].substring(0, values[loop - 1].indexOf('}', 0));
          }else{
            values[loop - 1] = values[loop - 1].substring(0, values[loop - 1].indexOf(',', 1));

          }

        }
      }

    } else if (key.isEmpty) {
      values.add(jsonData);
    } else {
      values.add('There is no value for this key');
    }

    return values;
  }
}


// class testApi extends State<ApiTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: FutureBuilder(future: postRequest('https://meetingss.onrender.com/auth/login', {"Content-Type": "application/json",},jsonEncode({
//           "E_mail": 'omarahmed2012006@gmail.com',
//           "PassWord": '12345678',
//           "role": 'Manager',
//         })  )  , builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if(snapshot.hasData){
//             return ListView.builder(itemBuilder: (context, index) => Text(snapshot.data), itemCount: 1,);
//           }else{
//             return CircularProgressIndicator();
//
//           }
//         },
//
//         ),
//       )
//     );
//
//   }
//   List Data = [];
//
//   // Future<dynamic> fetchLogin () async{
//   //   var response = await post(Uri.parse('https://meetingss.onrender.com/auth/login'),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: );
//   //   return response.body;
//   // }


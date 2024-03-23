import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class haha extends StatefulWidget{
  @override
  State<haha> createState()  =>  _hahaState();
}

class _hahaState extends State<haha>{

  @override
  Widget build(BuildContext context) {
    return Container();

  }
  void connectToSocket() {
    IO.Socket socket = IO.io(Uri.parse('https://meetingss.onrender.com'));

    socket.on('connect', (_) {
      print('Connected');
    });

    // socket.on('notification', (data) {
    //   print('Received notification: $data');
    //   // Handle the notification as needed
    // });
    //
    // socket.on('disconnect', (_) {
    //   print('Disconnected');
    // });
    socket.emit('updateSocketId','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzEsIkVfbWFpbCI6ImFsaWVsc2FhZGFueTk0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoiYWxpMWtoIiwicm9sZSI6IlNlY2VydGFyeSIsImlhdCI6MTcwOTY0NzcyMH0.HnQlxk8cSPTzeGhyCBK-R4EmpwUnf17L-VDQyJFBEtM' );
    socket.on('newNotification', (data) => print(data));
    socket.connect();
  }
}
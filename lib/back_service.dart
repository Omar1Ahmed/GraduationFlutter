import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:learning/lol.dart';
import 'package:socket_io_client/socket_io_client.dart';

Future<void> initializeService() async {
  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      initialNotificationContent: '',
      initialNotificationTitle: '',

    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}


@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {

  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async{
  DartPluginRegistrant.ensureInitialized();

  Socket socket = io('https://meetingss.onrender.com', OptionBuilder()
      .setReconnectionAttempts(double.infinity).setReconnectionDelay(500).enableReconnection().enableForceNewConnection().setTransports(['websocket']).enableForceNewConnection().build());

  socket.connect();

  Map lol = { 'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjMsIkVfbWFpbCI6ImFsaWVsc2FhZGFueTk0QGdtYWlsLmNvbSIsInVzZXJuYW1lIjoiYWxpMWtoIiwicm9sZSI6Ik1hbmFnZXIiLCJpYXQiOjE3MTE2NDA5ODl9.ardRjwWI-rt0c-biKjzVMckOtD9NRk4eYDgLjQFthYc'};
  socket.onConnect((data) {
    print('connected: ${socket.connected}');
  socket.emit('updateSocketId', lol);
    NotificationService().showNotification(title: 'title', body: 'connected');

  });


  socket.on('newNotification', (data){
    print(data);
    NotificationService().showNotification(title: 'title', body: '$data');
  });

socket.onReconnect((data) {
  socket.connect();
});

  if(service is AndroidServiceInstance){ {
  service.on('setAsForeground').listen((event) {
    service.setAsForegroundService();
  });
  service.on('setAsBackground').listen((event) {
    service.setAsBackgroundService();
  });
}


 service.on('stopService').listen((event) {
   service.stopSelf();
 });

 Timer.periodic(Duration(seconds: 1), (timer) async {
   if(service is AndroidServiceInstance) {

     if(await service.isForegroundService()){
       service.setForegroundNotificationInfo(title: '', content: '');

     }

   }
   print('backGround Running');

   service.invoke('update');
 });

}
}

// Future<bool> hasNetwork() async {
//   try {
//     final result = await InternetAddress.lookup('example.com');
//     NotificationService().showNotification(title: 'title', body: 'connected internet');
//     socket.connect();
//     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//
//   } on SocketException catch (_) {
//
//     NotificationService().showNotification(title: 'title', body: 'no internet');
//
//     return false;
//   }
// }



















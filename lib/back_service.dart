import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:Meetings/SqlDb.dart';
import 'package:Meetings/Widgets/LoginWidget.dart';
import 'package:Meetings/lol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

Future<void> initializeService() async {
  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      initialNotificationContent:  Language.getString('language') == 'en' ? 'Listening to The New Meetings' : 'يستقبل الإجتماعات الجديدة',
      initialNotificationTitle: 'Meetings',

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



  loginInfo = await SharedPreferences.getInstance();
  accData = await SharedPreferences.getInstance();
  Language = await SharedPreferences.getInstance();

  Socket socket = io('https://meetingss.onrender.com', OptionBuilder()
      .setReconnectionAttempts(double.infinity).setReconnectionDelay(500).enableReconnection().enableForceNewConnection().setTransports(['websocket']).enableForceNewConnection().build());

  socket.connect();


  socket.onConnect((data) {
    print('connected: ${socket.connected}');
    print('lol pop op o ${loginInfo.getString('token')}');
    socket.emit('updateSocketId', {
      'token': loginInfo.getString('token')});

  });

  // ''CREATE TABLE "Notifications" (
  //     "notification_id" int(3) NOT NULL,
  // "person" varchar NOT NULL,
  // "receivedAt" date
  socket.on('newNotification', (data) async {
    var message = getValue(jsonEncode(data), 'message')[0].toString().substring(38);
    NotificationService().showNotification(title: Language.getString('language') == 'en' ? 'Hey ${accData.getString('firstName')}' : '${accData.getString('firstName')}أهلا ', body: Language.getString('language') == 'en' ? 'You hava a Meeting With $message' : '$message لديك اجتماع مع ');

    var notification_id = getValue(jsonEncode(data), 'notificationId')[0].toString();
    print('$notification_id  $message');

    await sqldb.insertData('insert into Notifications(notification_id, person, receivedAt,  managerId) values(?,?,?,?)', [notification_id,message,DateTime.now().toString(), accData.getString('managerId')!]);

  });

  socket.onReconnect((data) {
    socket.connect();
  });

  if(service is AndroidServiceInstance ){ {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  if(service is IOSServiceInstance){
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


    if(await service.isForegroundService()){
      service.setForegroundNotificationInfo(title: 'Meetings', content: Language.getString('language') == 'en' ? 'Listening to The New Meetings' : 'يستقبل الإجتماعات الجديدة');

    }

    print('backGround Running');

    service.invoke('update');
  });

  }

  return true;
}

SqlDb sqldb = SqlDb();

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async{
  WidgetsFlutterBinding.ensureInitialized();

  DartPluginRegistrant.ensureInitialized();

  loginInfo = await SharedPreferences.getInstance();
  accData = await SharedPreferences.getInstance();
  Language = await SharedPreferences.getInstance();

  Socket socket = io('https://meetingss.onrender.com', OptionBuilder()
      .setReconnectionAttempts(double.infinity).setReconnectionDelay(500).enableReconnection().enableForceNewConnection().setTransports(['websocket']).enableForceNewConnection().build());

  socket.connect();


  socket.onConnect((data) {
    print('connected: ${socket.connected}');
    print('lol pop op o ${loginInfo.getString('token')}');
    socket.emit('updateSocketId', {
      'token': loginInfo.getString('token')});

  });

  // ''CREATE TABLE "Notifications" (
  //     "notification_id" int(3) NOT NULL,
  // "person" varchar NOT NULL,
  // "receivedAt" date
  socket.on('newNotification', (data) async {
    var message = getValue(jsonEncode(data), 'message')[0].toString().substring(38);
    NotificationService().showNotification(title: Language.getString('language') == 'en' ? 'Hey ${accData.getString('firstName')}' : '${accData.getString('firstName')} أهلا ', body: Language.getString('language') == 'en' ? 'You hava a Meeting With $message' : '$message لديك اجتماع مع ');

    var notification_id = getValue(jsonEncode(data), 'notificationId')[0].toString();
    print('$notification_id  $message');

    await sqldb.insertData('insert into Notifications(notification_id, person, receivedAt,  managerId) values(?,?,?,?)', [notification_id,message,DateTime.now().toString(), accData.getString('managerId')!]);

  });

socket.onReconnect((data) {
  socket.connect();
});

  if(service is AndroidServiceInstance ){ {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
  service.on('setAsBackground').listen((event) {
    service.setAsBackgroundService();
  });
}

if(service is IOSServiceInstance){
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


     if(await service.isForegroundService()){
       service.setForegroundNotificationInfo(title: 'Meetings', content:  Language.getString('language') == 'en' ? 'Listening to The New Meetings' : 'يستقبل الإجتماعات الجديدة');

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

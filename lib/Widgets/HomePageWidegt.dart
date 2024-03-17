import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:learning/CalenderView.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/SqlDb.dart';

import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/SearchWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  late ApiTest api ;
  late SharedPreferences accData , loginInfo ;
  SqlDb sqldb = SqlDb();
  HomePage(this.accData, this.loginInfo, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  late int _RadioSelected = 0 ;

}

class _HomePageState extends State<HomePage> {
  late List<Map> cardData;

  late ScrollController listController ;
  bool insertion = false,update = false, deletion = false, isChecked = false;
  late SharedPreferences Nearest ;

  String currentDayDate = DateTime.now().toString().substring(0,10);
  late String NearestMeetingDayDate;

  @override
  void initState() {
    super.initState();
    isChecked = false;
    listController = ScrollController();
    nearsetSharedPref();

  }
  @override
  Widget build(BuildContext context) {
    api = ApiTest(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF272A37),
        body: Stack(
          children: [

            Container(

                alignment: Alignment.center,
               width: 210,
              height: 50,
              margin: EdgeInsets.only(left: 25,top: 135),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    child: InkWell(

                          onTap: () {
                            setState(() {

                            });

                            isChecked = !isChecked;
                          },
                          child:  Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  isChecked ? Icons.check_box :Icons.check_box_outline_blank_rounded,
                                  size: 20,
                                  color: Color(0xFF7E7EBE),
                                ),
                                Text("Nearby Meetings",style: TextStyle(fontSize: 15, color: Color(0xFF7E7EBE)),),
                              ]
                            ),

                        ),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 30, bottom: 20),
                    width: 25,
                    height: 20,

                    child: PopupMenuButton(
                      offset: Offset(5, 35),

                      popUpAnimationStyle: AnimationStyle(curve: Curves.easeInCirc,reverseCurve: Curves.easeInCirc),
                      iconSize: 19,
                      position: PopupMenuPosition.over,
                      color: Colors.black,
                      icon: Icon(Icons.settings_suggest,color: Color(0xFF7E7EBE),),
                     padding: EdgeInsets.zero,

                      itemBuilder: (context) {

                        return [
                        PopupMenuItem(

                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Days",style: TextStyle(fontSize: 13, color: Color(0xFF7E7EBE)),),
                              SizedBox(width: 10,),
                              Container(width: 40,height: 40,child:
                              TextField(
                                onSubmitted: (value) {
                                  if(value.isNotEmpty){
                                    Nearest.setInt('Days', int.parse(value));
                                  NearestMeetingDayDate = DateTime.now().add(Duration(days: int.parse(value))).toString().substring(0,10);
                                  setState(() {

                                  });
                                  }
                                  Navigator.of(context).pop();
                                  },
                                keyboardType: TextInputType.number,

                                style: TextStyle(color: Colors.white),
                                maxLength: 2,

                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 4),
                                  ),
                                  contentPadding: EdgeInsets.only(bottom: 15),
                                  hintText: '${Nearest.getInt('Days')}',
                                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF7E7EBE)),
                                  fillColor: Color(0xff323644),
                                  filled: true,
                                )
                              ))
                            ]
                          ),
                        )
                      ];
                    },),
                  )
                ],
              ),


            ),
            Container(
              margin: const EdgeInsets.only(left: 370, top: 30),
              child:  IconButton(
                  icon: Icon(Icons.search,size: 32,),
                  color: Color.fromRGBO(50, 213, 131, 100),
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                    },
              ),
            ), // Search Icon

            Container(
                margin: const EdgeInsets.only(left: 310, top: 80),

                decoration: BoxDecoration(
                    color: const Color(0xa81a1c25),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _icon(0, icon: Icons.view_headline),
                    _icon(1, icon: Icons.calendar_month_rounded),
                  ],)),

            Container(

                width: 400,
                height: widget._RadioSelected == 0 ? null : 350,
                margin: widget._RadioSelected == 0 ? const EdgeInsets.only(
                    left: 30, right: 30, top: 174) : const EdgeInsets.only(
                    left: 30, right: 30, top: 300),
                child: widget._RadioSelected == 0 ?

                RefreshIndicator(
                  onRefresh: () {print('Refresh'); return readData(); },
                  child: FutureBuilder(future: readData(), builder: (context, snapshot) {

                    print('${snapshot.connectionState == ConnectionState.done} ${snapshot.data == null} ${!snapshot.hasData}');
                    if(snapshot.hasData){

                      return ListView.builder(
                      controller: listController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                         print('${snapshot.data![index]['person']} ${snapshot.data![index]['meeting_id']}');
                          return
                            // Text('${snapshot.data![index] ['name']}',style: TextStyle(color: Colors.white, fontSize: 24),);
                            CardVu(
                                PersonOrEntity_title: snapshot.data![index]['person'],
                                Topic_Content: snapshot.data![index]['about'].toString(),
                                Address_NoteId: snapshot.data![index]['address'],
                                Date: snapshot.data![index]['date'],
                                Time: snapshot.data![index]['time'],
                                PdfLink: snapshot.data![index]['attachmentLink'],);

                        },
                      );

                    }else {
                      if (ConnectionState.done == snapshot.connectionState) {
                        return Center(child: Text("No Data Found",
                          style: TextStyle(
                              color: Colors.white, fontSize: 24),));

                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                  }),
                )
                    : CalenderVu(Dates: getDays(),)),

            Container(

              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 40, top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green[500],
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.green, spreadRadius: 20, blurRadius: 100)
                  ]),
              child: InkWell(
                onTap: (){
                  setState(() {
                    Grad.lol.animateTo(3);
                  });
                },
                child: Text(
                  accData.getString('userName')!.toUpperCase().substring(0, 1),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _icon(int index, { IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkResponse(
        splashColor: Color.fromRGBO(50,213,131,100),
        radius: 15,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            widget._RadioSelected == index ?  Container(

              decoration: BoxDecoration(
                color: const Color(0xf2292d3b),
                borderRadius: BorderRadius.circular(100),

              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child : Icon(
                    icon,
                    color:  const Color.fromRGBO(50,213,131,100),
                  )),) : Icon(
              icon,
              color:  null,
            ),
            // Text('text!', style: TextStyle(color: Radtioselected == index ? Colors.red : null)),


            ],
        ),
        onTap: () => setState(() {

          widget._RadioSelected = index;

          },
        ),
      ),
    );
  }


  Future<List<Map>> readData() async {


    cardData = isChecked ? await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from Meetings where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'${NearestMeetingDayDate}\' order by date ') :
    await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from Meetings where manager_id = ${accData.getString('managerId')}) order by date');
    print(accData.getString('managerId'));
    print(cardData);
     if(await api.hasNetwork()) {

       var Response;

       if (cardData.isEmpty) {
        print('empty');
        Response = isChecked? await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&date[lte]=${NearestMeetingDayDate}&date[gte]=${currentDayDate}&isUpdated=true',{'token': '${loginInfo.getString('token')}'})
            : await api.getRequest(
            'https://meetingss.onrender.com/meetings?sort=date&date[gte]=' +
                currentDayDate,
            {'token': '${loginInfo.getString('token')}'});


        await insertDataToLocalDb(Response);
        insertion = true;

       } else {


        var readData = isChecked? await widget.sqldb.readData('select max(createdAt) as maxCreated, max(updatedAt) as maxUpdated from Meetings where meeting_id in( select meeting_id from Meetings where manager_id = ${accData
            .getString('managerId')} and date >= \'$currentDayDate\' and date <= \'${NearestMeetingDayDate}\')')
            :await widget.sqldb.readData('select max(createdAt) as maxCreated, max(updatedAt) as maxUpdated from Meetings where meeting_id in( select meeting_id from Meetings where manager_id = ${accData.getString('managerId')} )');

        print(DateTime.parse(readData[0]['maxCreated']).toString() + ' ' + currentDayDate);

         Response = isChecked ? await api.getRequest( 'https://meetingss.onrender.com/meetings?sort=date&isUpdated=false&date[lte]=${NearestMeetingDayDate}&date[gte]=${currentDayDate}&createdAt[gte]=${DateTime.parse(readData[0]['maxCreated']).add(const Duration(seconds: 1)).toString()}', {'token': '${loginInfo.getString('token')}'} )
             :await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=false&createdAt[gte]=${DateTime.parse(readData[0]['maxCreated']).add(const Duration(seconds: 1)).toString()}&date[gte]=${currentDayDate}',
            {'token': '${loginInfo.getString('token')}'});

        if(api.getValue(Response, 'count')[0] != '0'){
          print('$Response opopopopo');
          await insertDataToLocalDb(Response);
          insertion = true;
        }else{
          insertion = false;
        }
      print('${DateTime.parse(readData[0]['maxUpdated'])} + ' ' + ${readData[0]['maxUpdated'].toString().substring(0,19)} ${currentDayDate}');
        Response = isChecked? await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=true&date[lte]=${NearestMeetingDayDate}&date[gte]=${currentDayDate}&updatedAt[gte]=${DateTime.parse(readData[0]['maxUpdated']).add(const Duration(seconds: 1)).toString().substring(0,19)}',{'token': '${loginInfo.getString('token')}'} )
            :await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=true&date[gte]=${currentDayDate}&updatedAt[gte]=${DateTime.parse(readData[0]['maxUpdated']).add(const Duration(seconds: 1)).toString().substring(0,19)}' ,
            {'token': '${loginInfo.getString('token')}'});

print(Response +' h3h3h3h3h');
      if(api.getValue(Response, 'count')[0] != '0'){
        await insertOrUpdateDataToLocalDb(Response);
        update = true;
      }else{
        update = false;
      }
       }

      print(currentDayDate);
      Response = await api.getRequest('https://meetingss.onrender.com/meetings/getMeetingManagers?', {'token': '${loginInfo.getString('token')}'});
      print('lollaya');
       List<Map> lol = await widget.sqldb.readData('select meeting_id from meetings where manager_id = ${accData.getString('managerId')} and date >= \'$currentDayDate\' order by meeting_id');
      print('lollaya2');

       var ids =  await api.getValue(Response, 'meeting_id');


   for(int loop = 0 ; loop < ids.length; loop++){

     ids[loop] = ids[loop].replaceAll('}', '');

   }

   ids.sort();


       int Localcount = (await widget.sqldb.readData('select count(meeting_id) as count from meetings where manager_id = ${accData.getString('managerId')} and date >= ${DateTime.now().toString().substring(0,10)} '))[0]['count'];
       int onlineCount = api.getValue(Response, 'meeting_id').length;

  print('$Localcount + ' ' + $onlineCount');
   if( Localcount != onlineCount){


     for(int loop = 0 ; loop < onlineCount; loop++){
       print('${lol[loop]['meeting_id']} ${ids[loop]}');
       if(!ids.contains(lol[loop]['meeting_id'].toString())){
         print('${lol[loop]['meeting_id']} lol1');
         await widget.sqldb.deleteData('delete from meetings where meeting_id = ${lol[loop]['meeting_id']}');
         await widget.sqldb.deleteData('delete from meeting_Manager where meeting_id = ${lol[loop]['meeting_id']}');
         deletion = true;
       }
     }
      Localcount = (await widget.sqldb.readData('select count(meeting_id) as count from meetings where manager_id = ${accData.getString('managerId')} and date >= ${DateTime.now().toString().substring(0,10)} '))[0]['count'];
      onlineCount = api.getValue(Response, 'meeting_id').length;

     if(Localcount > onlineCount){

        for(int loop = 1 ; loop <= Localcount - onlineCount; loop++){
         print('${lol[loop]['meeting_id']} lol2');
         await widget.sqldb.deleteData('delete from meetings where meeting_id = ${lol[lol.length- loop]['meeting_id']}');
         await widget.sqldb.deleteData('delete from meeting_Manager where meeting_id = ${lol[loop]['meeting_id']}');

         deletion = true;
        }


    }


     }else{
        print('nothing to delete');
       deletion = false;
     }


    }

    if(insertion || update || deletion){
      cardData = isChecked? await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from Meetings where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'${NearestMeetingDayDate}\' order by date ')
          :await widget.sqldb.readData(
          'SELECT * FROM Meetings where manager_id = ${accData.getString(
              'managerId')} order by date');
      insertion = false;
      update = false;
      deletion = false;

    }

    print(cardData.length);
        return cardData;
  }

  Future<void> insertDataToLocalDb(String Response) async {

    if(api.getValue(Response, 'count')[0] != '0'){
      var meetingIds = api.getValue(Response, 'meeting_id');
      var meetingTimes = api.getValue(Response, 'time');
      var meetingDates = api.getValue(Response, 'date');
      var meetingAbouts = api.getValue(Response, 'about');
      var meetingInOrOuts = api.getValue(Response, 'in_or_out');
      var meetingAddresses = api.getValue(Response, 'address');
      var meetingComments = api.getValue(Response, 'notes');
      var meetingPersonsOrEntities = api.getValue(Response, 'person');
      var meetingUpdatedAts = api.getValue(Response, 'updatedAt');
      var meetingCreatedAts = api.getValue(Response, 'createdAt');
      var meetingAttachLinks = api.getValue(Response, 'attachmentLink');
      var meetingAttachNames = api.getValue(Response, 'attachmentName');
      var meetingStatuses = api.getValue(Response, 'statues');


      for(int i = 0; i < meetingIds.length; i++){
        await widget.sqldb.insertData('INSERT INTO Meetings(meeting_id, time, date, about, in_or_Out, address, notes, person, updatedAt, createdAt, attachmentLink, attachmentName, status,manager_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)', [
          meetingIds[i],
          meetingTimes[i],
          meetingDates[i],
          meetingAbouts[i],
          meetingInOrOuts[i],
          meetingAddresses[i],
          meetingComments[i],
          meetingPersonsOrEntities[i],
          meetingUpdatedAts[i],
          meetingCreatedAts[i],
          meetingAttachLinks[i],
          meetingAttachNames[i],
          meetingStatuses[i],
          accData.getString('managerId')!,
        ]);
        await widget.sqldb.insertData("insert into meeting_Manager (meeting_id, manager_id) values (?,?)", [
          meetingIds[i],
          accData.getString('managerId')!
        ] );
        print('${meetingIds[i]} Inserted');
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

  Future<void> insertOrUpdateDataToLocalDb(String Response) async {


    if(api.getValue(Response, 'count')[0] != '0'){
      var meetingIds =  api.getValue(Response, 'meeting_id');
      var meetingTimes = api.getValue(Response, 'time');
      var meetingDates = api.getValue(Response, 'date');
      var meetingAbouts = api.getValue(Response, 'about');
      var meetingInOrOuts = api.getValue(Response, 'in_or_out');
      var meetingAddresses = api.getValue(Response, 'address');
      var meetingComments = api.getValue(Response, 'notes');
      var meetingPersonsOrEntities = api.getValue(Response, 'person');
      var meetingUpdatedAts = api.getValue(Response, 'updatedAt');
      var meetingAttachLinks = api.getValue(Response, 'attachmentLink');
      var meetingAttachNames = api.getValue(Response, 'attachmentName');
      var meetingStatuses = api.getValue(Response, 'statues');
      var meetingManagerIds = api.getValue(Response, 'manager_id');


      for(int i = 0; i < meetingIds.length; i++){
        await widget.sqldb.updateData('update Meetings set meeting_id = ?, time = ?, date = ?, about = ?, in_or_Out = ?, address = ?, notes = ?, person = ?, updatedAt = ?, attachmentLink = ?, attachmentName = ?, status = ?,manager_id = ? where meeting_id = ?', [
          meetingIds[i],
          meetingTimes[i],
          meetingDates[i],
          meetingAbouts[i],
          meetingInOrOuts[i],
          meetingAddresses[i],
          meetingComments[i],
          meetingPersonsOrEntities[i],
          meetingUpdatedAts[i],
          meetingAttachLinks[i],
          meetingAttachNames[i],
          meetingStatuses[i],
          meetingManagerIds[i],
          meetingIds[i],

        ]);

          print(' ${meetingIds[i]} Updated');
      }
      // meetingIds.clear();
      // meetingTimes.clear();
      // meetingDates.clear();
      // meetingAbouts.clear();
      // meetingInOrOuts.clear();
      // meetingAddresses.clear();
      // meetingComments.clear();
      // meetingPersonsOrEntities.clear();
      // meetingUpdatedAts.clear();
      // meetingAttachLinks.clear();
      // meetingAttachNames.clear();
      // meetingStatuses.clear();
      print('update Successful');
    }
  }

  void nearsetSharedPref() async {
    Nearest = await SharedPreferences.getInstance();
    if(Nearest.getInt('Days') == null){
      Nearest.setInt('Days', 3);
    }
    NearestMeetingDayDate = DateTime.now().add(Duration(days: Nearest.getInt("Days")! )).toString().substring(0,10);

  }

  List<DateTime> getDays(){
    List<DateTime> Days =  [];

    for(int loop = 0 ; loop < cardData.length ; loop ++){
      Days.add(DateTime.parse(cardData[loop]['date']));

    }

    return Days;
  }
}
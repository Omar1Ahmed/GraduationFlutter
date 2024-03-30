import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/CardView.dart';
import 'package:learning/Grad.dart';
import 'package:learning/SqlDb.dart';

import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/Widgets/SearchWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
import 'package:learning/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  DateTime setDate =   DateTime.now();
  ValueNotifier<int> number = ValueNotifier(0);
  int counter = 0;
  int dateCounter = 1;
  late List<Map<String,dynamic>> DateWithCounter = [
    {'Date' : setDate, 'counter' : -1},
  ];

  late ApiTest api ;
  late SharedPreferences? accData , loginInfo , Language,Nearest;
  SqlDb sqldb = SqlDb();


  HomePage({this.accData, this.loginInfo, this.Language,this.Nearest,super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  bool calenderDataBool = false;
  var calenderData;


}
late double ScreenWidth ;
late double ScreenHeight;

class _HomePageState extends State<HomePage> {
  late List<Map> cardData;
  late int _RadioSelected = 0 ;

  late ScrollController listController ;
  bool insertion = false,update = false, deletion = false, isChecked = false;

  String currentDayDate = DateTime.now().toString().substring(0,10);
  late String NearestMeetingDayDate;

  @override
  void initState() {
    super.initState();
    isChecked = false;
    listController = ScrollController();
    nearsetSharedPref();

    languageSharedPrefInitialize();


  }
  @override

  Widget build(BuildContext context) {



    if(MediaQuery.of(context).orientation == Orientation.portrait){
      ScreenWidth = MediaQuery.of(context).size.width;
      ScreenHeight = MediaQuery.of(context).size.height;
    }else{
      ScreenWidth = MediaQuery.of(context).size.height;
      ScreenHeight = MediaQuery.of(context).size.width;
      // ScreenWidth = MediaQuery.of(context).size.width;
      // ScreenHeight = MediaQuery.of(context).size.height;
    }

    api = ApiTest(context);
    return SafeArea(
      child: Scaffold(

        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF272A37),
        body: Center(
          child: Stack(
            children: [

              _RadioSelected == 0? Container(

                  alignment: Alignment.center,
                 width: ScreenWidth * 0.52,
                height: ScreenHeight * 0.056,

                margin: isEnglish()  ? EdgeInsets.only(left: ScreenWidth * 0.059,top: ScreenHeight * 0.15):
                EdgeInsets.only(left: ScreenWidth * 0.50,top: ScreenHeight * 0.15),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                  children: isEnglish()  ? [
                    InkWell(

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
                                  size: ScreenWidth * 0.04,
                                  color: const Color(0xFF785FC0),
                                ),
                                Text(S.of(context).nearbyMeetings,style:  TextStyle(fontSize: ScreenWidth * 0.035, color: Color(0xFF785FC0)),),
                              ]

                            ),

                        ),

                    Container(
                      margin: EdgeInsets.only(right: ScreenWidth * 0.071, bottom: ScreenHeight * 0.022),
                      width: ScreenWidth * 0.059,
                      height: ScreenHeight * 0.022,

                      child: PopupMenuButton(
                        offset:  Offset(ScreenWidth * 0.01, ScreenHeight * 0.023),

                        popUpAnimationStyle: AnimationStyle(curve: Curves.easeInCirc,reverseCurve: Curves.easeInCirc),
                        iconSize: ScreenWidth * 0.04,
                        position: PopupMenuPosition.over,
                        color: Colors.black,
                        icon: const Icon(Icons.settings_suggest,color: Color( 0xFF8C7EBE),),
                       padding: EdgeInsets.zero,

                        itemBuilder: (context) {

                          return [
                          PopupMenuItem(

                            value: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(S.of(context).days,style: TextStyle(fontSize: ScreenWidth * 0.03, color: Color(0xFF7E7EBE)),),
                                SizedBox(width: ScreenWidth * 0.024,),
                                SizedBox(width: ScreenWidth * 0.09,height: ScreenHeight * 0.045,
                                    child: TextField(
                                  onSubmitted: (value) {
                                    if(value.isNotEmpty){
                                      widget.Nearest!.setInt('Days', int.parse(value));
                                    NearestMeetingDayDate = DateTime.now().add(Duration(days: int.parse(value))).toString().substring(0,10);
                                    setState(() {

                                    });
                                    }
                                    Navigator.of(context).pop();
                                    },
                                  keyboardType: TextInputType.number,

                                  style: const TextStyle(color: Colors.white),
                                  maxLength: 2,

                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(ScreenWidth * 0.01),
                                      borderSide: BorderSide(width: ScreenWidth * 0.009),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: ScreenHeight * 0.017),
                                    hintText: '${widget.Nearest!.getInt('Days')}',
                                    hintStyle: TextStyle(fontSize: ScreenWidth * 0.03, color: Color(0xFF7E7EBE)),
                                    fillColor: const Color(0xff323644),
                                    filled: true,
                                  )
                                ))
                              ]
                            ),
                          )
                        ];
                      },),
                    )
                  ]:

                      //Arabic --------------------------------------------
                  [
                    Container(
                      margin: EdgeInsets.only(right: ScreenWidth * 0.011, bottom: ScreenHeight * 0.022),
                      width: ScreenWidth * 0.059,
                      height: ScreenHeight * 0.022,

                      child: PopupMenuButton(
                        offset: Offset(ScreenWidth * 0.01, ScreenHeight * 0.03),

                        popUpAnimationStyle: AnimationStyle(curve: Curves.easeInCirc,reverseCurve: Curves.easeInCirc),
                        iconSize: ScreenWidth * 0.04,
                        position: PopupMenuPosition.over,
                        color: Colors.black,
                        icon: const Icon(Icons.settings_suggest,color: Color( 0xFF8C7EBE),),
                        padding: EdgeInsets.zero,

                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(

                              value: 0,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(S.of(context).days,style: TextStyle(fontSize: ScreenWidth * 0.04, color: Color(0xFF7E7EBE)),),
                                    SizedBox(width: ScreenWidth * 0.024,),
                                    SizedBox(width: ScreenWidth * 0.09,height: ScreenHeight * 0.045,
                                        child: TextField(
                                            onSubmitted: (value) {
                                              if(value.isNotEmpty){
                                                widget.Nearest!.setInt('Days', int.parse(value));
                                                NearestMeetingDayDate = DateTime.now().add(Duration(days: int.parse(value))).toString().substring(0,10);
                                                setState(() {

                                                });
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            keyboardType: TextInputType.number,

                                            style: const TextStyle(color: Colors.white),
                                            maxLength: 2,

                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(ScreenWidth * 0.03),
                                                borderSide: BorderSide(width: ScreenWidth * 0.009),
                                              ),
                                              contentPadding: EdgeInsets.only(bottom: ScreenHeight * 0.017),
                                              hintText: '${widget.Nearest!.getInt('Days')}',
                                              hintStyle: TextStyle(fontSize: ScreenWidth * 0.03, color: Color(0xFF7E7EBE)),
                                              fillColor: const Color(0xff323644),
                                              filled: true,
                                            )
                                        ))
                                  ]
                              ),
                            )
                          ];
                        },),
                    ),

                    InkWell(

                      onTap: () {
                        setState(() {

                        });

                        isChecked = !isChecked;
                      },
                      child:  Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children:
                          [
                            Text(S.of(context).nearbyMeetings,style: TextStyle(fontSize: ScreenWidth * 0.035, color: Color(0xFF785FC0)),),
                            Icon(
                              isChecked ? Icons.check_box :Icons.check_box_outline_blank_rounded,
                              size: ScreenWidth * 0.04,
                              color: const Color(0xFF785FC0),
                            ),
                          ]
                      ),

                    ),

                  ],
                ),


              ) : Container(),
              Container(
                margin:  EdgeInsets.only(left: ScreenWidth * 0.87, top: ScreenHeight * 0.030),
                child:  IconButton(
                    icon: Icon(Icons.search,size: ScreenWidth * 0.072,),
                    color: const Color.fromRGBO(50, 213, 131, 100),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                      },
                ),
              ), // Search Icon

              Container(
                  margin:  EdgeInsets.only(left: ScreenWidth * 0.73, top: ScreenHeight * 0.09),

                  decoration: BoxDecoration(
                      color: const Color(0xa81a1c25),
                      borderRadius: BorderRadius.circular(ScreenWidth * 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _icon(0, icon: Icons.view_headline,),
                      _icon(1, icon: Icons.calendar_month_rounded),
                    ],)),

              Container(

                  // width: 400,
                  // height: widget._RadioSelected == 0 ? null : 350,
                  margin: _RadioSelected == 0 ?  EdgeInsets.only(
                      left: ScreenWidth * 0.071, right: ScreenWidth * 0.071, top: ScreenHeight * 0.193) :  EdgeInsets.only(
                      left: ScreenWidth * 0.071, right: ScreenWidth * 0.071, top: ScreenHeight * 0.24),
                  child: _RadioSelected == 0 ?

                   RefreshIndicator(
                      onRefresh: () {
                        setState(() {

                      });
                        return readData(); },

                     child: FutureBuilder(future: widget.calenderDataBool ? RadioSelectedSetter(getDays()) :readData(),

                          builder: (context, snapshot) {


                        if(snapshot.hasData){

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                          controller: listController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {

                              if(widget.calenderDataBool == true){

                                if(snapshot.hasData) {
                                  if(index == snapshot.data!.length -1 ) {
                                    widget.calenderDataBool = false;
                                  }
                                  return CardVu(
                                    MeetingId: snapshot.data![index]['meeting_id'].toString(),
                                    PersonOrEntity_title: snapshot
                                        .data![index]['person'],
                                    Topic_Content: snapshot.data![index]['about']
                                        .toString(),
                                    Address_NoteId: snapshot
                                        .data![index]['address'],
                                    Date: snapshot.data![index]['date'],
                                    Time: snapshot.data![index]['time'],
                                    PdfLink: snapshot
                                        .data![index]['attachmentLink'],);
                                }else{
                                  return const CircularProgressIndicator();
                                }
                              }else {

                                return CardVu(
                                  MeetingId: snapshot.data![index]['meeting_id'].toString(),
                                  PersonOrEntity_title: snapshot
                                      .data![index]['person'],
                                  Topic_Content: snapshot.data![index]['about']
                                      .toString(),
                                  Address_NoteId: snapshot
                                      .data![index]['address'],
                                  Date: snapshot.data![index]['date'],
                                  Time: snapshot.data![index]['time'],
                                  PdfLink: snapshot
                                      .data![index]['attachmentLink'],);
                              }
                            },
                          );

                        }else {
                          if (ConnectionState.done == snapshot.connectionState) {
                            return Center(child: Text(S.of(context).noDataFound,
                              style:  TextStyle(
                                  color: Colors.white, fontSize: ScreenWidth * 0.05),));

                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                      }),
                    ) :

                          CalenderVuWidget(getDays(),),

              ),

              Container(

                width: ScreenWidth * 0.12,
                height: ScreenHeight * 0.056,
                margin: EdgeInsets.only(left: ScreenWidth * 0.094, top: ScreenHeight * 0.033  ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ScreenHeight * 0.056  ),//50
                    color: Colors.green[500],
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green, spreadRadius: ScreenWidth * 0.06, blurRadius: ScreenWidth * 0.3)
                    ]),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      Grad.lol.animateTo(3);
                    });
                  },
                  child: Text(
                    accData.getString('userName')!.toUpperCase().substring(0, 1),
                    style:  TextStyle(fontSize: ScreenWidth * 0.06, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _icon(int index, { IconData? icon}) {
    return Padding(
      padding:  EdgeInsets.only(left: ScreenWidth * 0.024, right: ScreenWidth * 0.024, top: ScreenHeight * 0.011, bottom: ScreenHeight * 0.011),
      child: InkResponse(
        splashColor: const Color.fromRGBO(50,213,131,100),
        radius: ScreenWidth * 0.04,
        highlightColor: const Color.fromRGBO(50,213,131,100),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            _RadioSelected == index ?  Container(

              decoration: BoxDecoration(
                color: const Color(0xf2292d3b),
                borderRadius: BorderRadius.circular(ScreenWidth * 0.04),

              ),
              child: Padding(
                  padding:  EdgeInsets.only(left: ScreenWidth * 0.0094, right: ScreenWidth * 0.0094, top: ScreenHeight * 0.0045, bottom: ScreenHeight * 0.0045),
                  child : Icon(
                    icon,
                    color:  const Color.fromRGBO(50,213,131,100),
                    size: ScreenWidth * 0.06,
                  )),) : Icon(
              icon,
              color:  null,
              size: ScreenWidth * 0.06,
            ),
            // Text('text!', style: TextStyle(color: Radtioselected == index ? Colors.red : null)),


            ],
        ),
        onTap: () => setState(() {

          _RadioSelected = index;

          },

        ),
      ),
    );
  }


  Future<List<Map>> readData() async {


    cardData = isChecked ? await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'$NearestMeetingDayDate\' order by date ') :
    await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) order by date');

    print(cardData);

     if(await api.hasNetwork()) {
       var Response;

       if (cardData.isEmpty) {

        Response = isChecked? await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&date[lte]=$NearestMeetingDayDate&date[gte]=$currentDayDate&isUpdated=true',{'token': '${loginInfo.getString('token')}'})
            : await api.getRequest(
            'https://meetingss.onrender.com/meetings?sort=date&date[gte]=' +
                currentDayDate,
            {'token': '${loginInfo.getString('token')}'});


        await insertDataToLocalDb(Response);
        insertion = true;

       } else {


        var readData = isChecked? await widget.sqldb.readData('select max(createdAt) as maxCreated, max(updatedAt) as maxUpdated from Meetings where meeting_id in( select meeting_id from meeting_Manager where manager_id = ${accData
            .getString('managerId')} and date >= \'$currentDayDate\' and date <= \'$NearestMeetingDayDate\')')
            :await widget.sqldb.readData('select max(createdAt) as maxCreated, max(updatedAt) as maxUpdated from Meetings where meeting_id in( select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')} )');



         Response = isChecked ? await api.getRequest( 'https://meetingss.onrender.com/meetings?sort=date&isUpdated=false&date[lte]=$NearestMeetingDayDate&date[gte]=$currentDayDate&createdAt[gte]=${DateTime.parse(readData[0]['maxCreated']).add(const Duration(seconds: 1)).toString()}', {'token': '${loginInfo.getString('token')}'} )
             :await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=false&createdAt[gte]=${DateTime.parse(readData[0]['maxCreated']).add(const Duration(seconds: 1)).toString()}&date[gte]=$currentDayDate',
            {'token': '${loginInfo.getString('token')}'});

        if(api.getValue(Response, 'count')[0] != '0'){


          await insertDataToLocalDb(Response);
          insertion = true;
        }else{
          insertion = false;
        }

        Response = isChecked? await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=true&date[lte]=$NearestMeetingDayDate&date[gte]=$currentDayDate&updatedAt[gte]=${DateTime.parse(readData[0]['maxUpdated']).add(const Duration(seconds: 1)).toString().substring(0,19)}',{'token': '${loginInfo.getString('token')}'} )
            :await api.getRequest('https://meetingss.onrender.com/meetings?sort=date&isUpdated=true&date[gte]=$currentDayDate&updatedAt[gte]=${DateTime.parse(readData[0]['maxUpdated']).add(const Duration(seconds: 1)).toString().substring(0,19)}' ,
            {'token': '${loginInfo.getString('token')}'});

      if(api.getValue(Response, 'count')[0] != '0'){
        await insertOrUpdateDataToLocalDb(Response);
        update = true;
      }else{
        update = false;
      }
       }


      Response = await api.getRequest('https://meetingss.onrender.com/meetings/getMeetingManagers?', {'token': '${loginInfo.getString('token')}'});


       List<Map> lol = await widget.sqldb.readData('select meeting_id from meetings where meeting_id in (select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' order by meeting_id');


       var ids =  await api.getValue(Response, 'meeting_id');


   for(int loop = 0 ; loop < ids.length; loop++){

     ids[loop] = ids[loop].replaceAll('}', '');

   }

   ids.sort();


       int Localcount = (await widget.sqldb.readData('select count(meeting_id) as count from meetings where meeting_id in (select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= ${DateTime.now().toString().substring(0,10)} '))[0]['count'];
       int onlineCount = api.getValue(Response, 'meeting_id').length;

   if( Localcount != onlineCount){


     for(int loop = 0 ; loop < onlineCount; loop++){

       if(!ids.contains(lol[loop]['meeting_id'].toString())){

         await widget.sqldb.deleteData('delete from meetings where meeting_id = ${lol[loop]['meeting_id']}');
         await widget.sqldb.deleteData('delete from meeting_Manager where meeting_id = ${lol[loop]['meeting_id']}');
         deletion = true;
       }
     }
      Localcount = (await widget.sqldb.readData('select count(meeting_id) as count from meetings where meeting_id in (select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= ${DateTime.now().toString().substring(0,10)} '))[0]['count'];
      onlineCount = api.getValue(Response, 'meeting_id').length;

     if(Localcount > onlineCount){

        for(int loop = 1 ; loop <= Localcount - onlineCount; loop++){

         await widget.sqldb.deleteData('delete from meetings where meeting_id = ${lol[lol.length- loop]['meeting_id']}');
         await widget.sqldb.deleteData('delete from meeting_Manager where meeting_id = ${lol[loop]['meeting_id']}');

         deletion = true;
        }


    }


     }else{

     deletion = false;
     }


    }

    if(insertion || update || deletion){
      cardData = isChecked? await widget.sqldb.readData('SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) and date >= \'$currentDayDate\' and date <= \'$NearestMeetingDayDate\' order by date ')
          :await widget.sqldb.readData(
          'SELECT * FROM Meetings where meeting_id in(select meeting_id from meeting_Manager where manager_id = ${accData.getString('managerId')}) order by date');
      insertion = false;
      update = false;
      deletion = false;

    }


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
        await widget.sqldb.insertData('INSERT INTO Meetings(meeting_id, time, date, about, in_or_Out, address, notes, person, updatedAt, createdAt, attachmentLink, attachmentName, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)', [
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
        ]);
        await widget.sqldb.insertData("insert into meeting_Manager (meeting_id, manager_id) values (?,?)", [
          meetingIds[i],
          accData.getString('managerId')!
        ] );

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
        await widget.sqldb.updateData('update Meetings set meeting_id = ?, time = ?, date = ?, about = ?, in_or_Out = ?, address = ?, notes = ?, person = ?, updatedAt = ?, attachmentLink = ?, attachmentName = ?, status = ? where meeting_id = ?', [
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

        ]);


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

    }
  }

  void nearsetSharedPref() async {
    widget.Nearest = await SharedPreferences.getInstance();
    if(widget.Nearest!.getInt('Days') == null){
      widget.Nearest!.setInt('Days', 3);
    }
    NearestMeetingDayDate = DateTime.now().add(Duration(days: widget.Nearest!.getInt("Days")! )).toString().substring(0,10);

  }

  List<DateTime> getDays(){
    List<DateTime> Days =  [];

    for(int loop = 0 ; loop < cardData.length ; loop ++){
      Days.add(DateTime.parse(cardData[loop]['date']));

    }

    return Days;
  }

  bool isEnglish() => Intl.getCurrentLocale() == 'en';


  void languageSharedPref() async {
    if(Language.getString('language') == 'en'){
      S.load(const Locale("en"));
    }else if(Language.getString('language') == 'ar'){
      S.load(const Locale("ar"));

    }else{
      S.load(const Locale("ar"));
      Language.setString('language', 'ar');
    }
  }
  void languageSharedPrefInitialize() async {
    Language = await SharedPreferences.getInstance();


    if(Language.getString('language').toString() == 'null'){

      languageSharedPref();
    }else{
      S.load(Locale(Language.getString('language')!));
      setState(() {

      });

    }

  }

  CalenderVuWidget(List<DateTime> Dates){

    Dates.sort();

    for(int loop = 0 ; loop < Dates.length ; loop ++){
      if(loop == 0){
        widget.DateWithCounter[0]['Date'] = Dates[0];
        widget.DateWithCounter[0]['counter'] = 1;

      }else if(Dates[loop] == Dates[loop-1] && loop != 0 ){

        widget.DateWithCounter[widget.DateWithCounter.length-1]['Date'] = Dates[loop-1];
        widget.DateWithCounter[widget.DateWithCounter.length-1]['counter'] = widget.DateWithCounter[widget.DateWithCounter.length-1]['counter'] + 1;

      }else{
        widget.DateWithCounter.add({'Date' : Dates[loop], 'counter' : 1});
      }

    }
    initStateCalnder();
    return   Column(

      children: [
        Material(
          elevation: ScreenWidth * 0.04,
          borderRadius: BorderRadius.all(Radius.circular(ScreenWidth * 0.06)),
          child: Container(
            padding:  EdgeInsets.only(top: ScreenHeight * 0.01),
            decoration:  BoxDecoration(
              color: Color(0xff1E2126),
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(ScreenWidth * 0.06)),
            ),
            alignment: Alignment.center,

            child: CalendarDatePicker2(

              onValueChanged: (value) {

                widget.calenderData = value;

                if(value.isNotEmpty){
                  for(int loop = 0 ; loop < value.length; loop ++){
                    value[loop] = DateTime.parse(value[loop].toString().substring(0,10)+' 00:00:00.00');

                    if(Dates.contains(value[loop])){
                      widget.counter = (widget.counter + widget.DateWithCounter[widget.DateWithCounter.indexWhere((element) => element['Date'] == value[loop])]['counter'] ) as int;
                    }
                  }
                  widget.number.value = widget.counter;
                  widget.counter = 0;
                }else{

                  widget.number.value = 0;
                  widget.counter = 0;

                }

              },

              config: CalendarDatePicker2Config(
                dayTextStyle: const TextStyle(
                    color: Colors.grey
                ),
                yearTextStyle: const TextStyle(
                    color: Colors.grey
                ),
                controlsTextStyle: const TextStyle(
                    color: Colors.grey
                ),
                weekdayLabelTextStyle: const TextStyle(
                    color: Colors.grey
                ),
                nextMonthIcon: const Icon(Icons.arrow_forward_ios_sharp,color: Color(0xff7E7EBE),),
                lastMonthIcon: const Icon(Icons.arrow_back_ios_sharp,color: Color(0xff7E7EBE),),
                centerAlignModePicker: true,

                calendarType: CalendarDatePicker2Type.multi,

                selectedDayHighlightColor: const Color(0xff7E7EBE),
                dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
                  Widget? dayWidget;

                  for(int loop = 0; loop < widget.DateWithCounter.length; loop ++) {
                    if (date   == widget.DateWithCounter[loop]['Date']) {

                      dayWidget = Container(

                        decoration: decoration,

                        child: Center(

                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Text(
                                MaterialLocalizations.of(context)
                                    .formatDecimal(date.day),
                                style: textStyle,
                              ),
                              Padding(

                                padding:  EdgeInsets.only(
                                    left: ScreenWidth * 0.05, top: ScreenHeight * 0.016),

                                child: Container(
                                  height: ScreenHeight * 0.015,
                                  width: ScreenWidth * 0.025,
                                  margin: EdgeInsets.only(top: ScreenHeight * 0.001),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius
                                        .circular(ScreenWidth * 0.03),
                                    color: isSelected == true
                                        ? Colors.white
                                        : const Color(0xff7E7EBE),
                                  ),
                                  child: Text('${widget.DateWithCounter[loop]['counter']}',
                                      style: TextStyle(
                                          color: isSelected == true
                                              ? const Color(0xff7E7EBE)
                                              : Colors.white,
                                          fontSize: 9),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }else{
                      Container(

                      );
                    }
                  }
                  return dayWidget;
                },

              ), value: [widget.setDate],



            ),

          ),
        ),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: ScreenHeight * 0.02),
            child: ValueListenableBuilder(valueListenable: widget.number, builder: (BuildContext context, value, Widget? child) {

              if(value != 0 ){
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(S.of(context).totalMeetings(value),style: const TextStyle(color: Colors.grey),),
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff7E7EBE))),
                          onPressed: (){
                            setState(() {
                              RadioSelectedSetter(Dates);
                              _RadioSelected = 0;
                            });
                          }, child: Text(S.of(context).showMeeting,style: const TextStyle(color: Colors.white),)),
                    ]
                );
              }else{

                return Text(S.of(context).noMeetings_Calender,style: const TextStyle(color: Colors.grey ),);
              }
            },

            )
        )
      ],

    );
  }

  initStateCalnder(){


    if(widget.DateWithCounter[0]['Date'].toString().contains(DateTime.now().toString().substring(0,10)+' 00:00:00.00')){
      widget.counter = widget.DateWithCounter[0]['counter'] as int ;
      widget.number = ValueNotifier(widget.counter);
      widget.counter = 0;
      widget.calenderData = [widget.DateWithCounter[0]['Date']];
    }else{
      widget.number = ValueNotifier(0);
      widget.counter = 0;
    }

  }

  Future<List> RadioSelectedSetter(List Dates) async {
    // _RadioSelected = value;
    widget.calenderDataBool = true;

    String SearchBy = 'date = "${widget.calenderData[0].toString().substring(0,10)}"';
    for(int loop = 1 ; loop < widget.calenderData.length ; loop ++){
      SearchBy += ' or date = "${widget.calenderData[loop].toString().substring(0,10)}"' ;
    }

    widget.calenderData = await sqldb.readData('select * from Meetings where $SearchBy order by date');
    return widget.calenderData;
    // _HomePageState().RadioSelected(0);
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/generated/l10n.dart';

class CalenderVu extends StatefulWidget{
  DateTime setDate =   DateTime.now();


  int dateCounter = 1;
  late List<DateTime?> Dates ;
  late List<Map<String,dynamic>> DateWithCounter = [
    {'Date' : setDate, 'counter' : -1},
  ];
  CalenderVu({super.key, required this.Dates}){
    Dates.sort();

    for(int loop = 0 ; loop < Dates.length ; loop ++){
      if(loop == 0){
        DateWithCounter[0]['Date'] = Dates[0];
        DateWithCounter[0]['counter'] = 1;

      }else if( Dates[loop] == Dates[loop-1] && loop != 0 ){

        DateWithCounter[DateWithCounter.length-1]['Date'] = Dates[loop-1];
        DateWithCounter[DateWithCounter.length-1]['counter'] = DateWithCounter[DateWithCounter.length-1]['counter'] + 1;

      }else{
        DateWithCounter.add({'Date' : Dates[loop], 'counter' : 1});
      }

    }



  }



  int counter = 4;

  @override
  State<CalenderVu> createState() => _CalenderVuState();
}

class _CalenderVuState extends State<CalenderVu> {
  late ValueNotifier<int> number;

  late List Days;
  @override
  void initState() {
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return   Column(
        children: [
          Material(
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xff1E2126),
                          // color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
                              alignment: Alignment.center,

                              child: CalendarDatePicker2(

                                onValueChanged: (value) {
                                    print(value);
                                    print(widget.Dates.length);
                                   if(value.isNotEmpty){
                                     for(int loop = 0 ; loop < value.length; loop ++){
                                      value[loop] = DateTime.parse(value[loop].toString().substring(0,10)+' 00:00:00.00');
                                       print(value[loop]);
                                      if(widget.Dates.contains(value[loop])){
                                       widget.counter = (widget.counter + widget.DateWithCounter[widget.DateWithCounter.indexWhere((element) => element['Date'] == value[loop])]['counter'] ) as int;
                                    }
                                    }
                                    number.value = widget.counter;
                                    widget.counter = 0;
                                   }else{
                                     print('zero');
                                     number.value = 0;
                                     widget.counter = 0;

                                   }

                                  },

                                config: CalendarDatePicker2Config(
                                dayTextStyle: TextStyle(
                                  color: Colors.grey
                                ),
                                  yearTextStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                 controlsTextStyle: TextStyle(
                                   color: Colors.grey
                                 ),
                                  weekdayLabelTextStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                  nextMonthIcon: Icon(Icons.arrow_forward_ios_sharp,color: Color(0xff7E7EBE),),
                                  lastMonthIcon: Icon(Icons.arrow_back_ios_sharp,color: Color(0xff7E7EBE),),
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

                                                  padding: const EdgeInsets.only(
                                                      left: 15.0, top: 20.5),

                                                  child: Container(
                                                    height: ScreenHeight * 0.015,
                                                    width: ScreenWidth * 0.03,
                                                    margin: EdgeInsets.only(top: ScreenHeight * 0.005),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(25),
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
            child: ValueListenableBuilder(valueListenable: number, builder: (BuildContext context, value, Widget? child) {
              print('$value value');
              if(value != 0 ){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${S.of(context).totalMeetings(value)}',style: TextStyle(color: Colors.grey),),
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff7E7EBE))),
                        onPressed: (){
                          // setState(() {
                          //
                          // });
                        }, child: Text('${S.of(context).showMeeting}',style: TextStyle(color: Colors.white),)),
                  ]
                );
              }else{

                return Text('${S.of(context).noMeetings_Calender}',style: TextStyle(color: Colors.grey ),);
              }
            },

            )
          )
        ],

    );
  }
}
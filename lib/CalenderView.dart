
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CalenderVu extends StatelessWidget{

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
  Widget build(BuildContext context) {
    return  Container(
                padding: EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
                      alignment: Alignment.center,

                      child: CalendarDatePicker2(


                        config: CalendarDatePicker2Config(
                          centerAlignModePicker: true,

                          calendarType: CalendarDatePicker2Type.multi,

                          selectedDayHighlightColor: const Color.fromRGBO(50,213,131,100),
                          dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
                            Widget? dayWidget;

                            for(int loop = 0; loop < DateWithCounter.length; loop ++) {
                              if (date   == DateWithCounter[loop]['Date']) {

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
                                            height: 12,
                                            width: 12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(5),
                                              color: isSelected == true
                                                  ? Colors.white
                                                  : const Color.fromRGBO(
                                                  50, 213, 131, 100),
                                            ),
                                            child: Text('${DateWithCounter[loop]['counter']}',
                                                style: TextStyle(
                                                    color: isSelected == true
                                                        ? const Color.fromRGBO(
                                                        50, 213, 131, 100)
                                                        : Colors.white,
                                                    fontSize: 9),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return dayWidget;
                          },

                        ), value: [setDate],



                      ),

            );
  }

}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget{

  DateTime setDate =   DateTime.now().add(Duration(days: 5));

  Test({super.key});

  int counter = 4;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xff1E2126),
          body:  Center(
          child: Card(

              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.multi,

              dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
               Widget? dayWidget;

               if (date.day % 3 == 0 && date.day % 9 != 0) {
                 dayWidget = Container(

                   decoration: decoration,

                   child: Center(

                     child: Stack(
                       alignment: AlignmentDirectional.center,
                       children: [
                         Text(
                           MaterialLocalizations.of(context).formatDecimal(date.day),
                           style: textStyle,
                         ),
                         Padding(

                           padding: const EdgeInsets.only(left : 15.0,top: 20.5),

                           child: Container(
                             height: 12,
                             width: 12,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: isSelected == true
                                   ? Colors.white
                                   : Colors.grey[500],
                             ),
                             child: Text('$counter',style: TextStyle(color: isSelected == true
                                 ? Colors.grey[500]
                                 : Colors.white,fontSize: 9),textAlign: TextAlign.center),
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               }
                    return dayWidget;
              },

                ), value: [setDate],
        
          )),
        )
      )
    );
  }

}
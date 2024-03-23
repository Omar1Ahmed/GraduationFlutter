import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:learning/CardView.dart';
import 'package:learning/SqlDb.dart';
import 'package:learning/Widgets/HomePageWidegt.dart';
import 'package:learning/generated/l10n.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  late TabController Tc;

  TextEditingController txtField = TextEditingController();
  late String searchTxt;
  TextEditingController toTxtController = TextEditingController();
  TextEditingController fromTxtController = TextEditingController();
  late ScrollPhysics scroll;
  bool SearchByDatebool = false;

  List<int> Years = [];
  List<String> Months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  late FixedExtentScrollController yearController,
      monthController,
      dayController;
  late FocusNode toTxtFocus, fromTxtFocus;

  @override
  void initState() {
    super.initState();
    fromTxtFocus = FocusNode();
    fromTxtFocus.requestFocus();
    toTxtFocus = FocusNode();
    yearController = FixedExtentScrollController(
      initialItem: 5,
    );
    fromTxtController.text = '--/--/----';
    toTxtController.text = '--/--/----';
    monthController =
        FixedExtentScrollController(initialItem: DateTime.now().month - 1);
    dayController =
        FixedExtentScrollController(initialItem: DateTime.now().day - 1);
    for (int loop = 0; loop < 100; loop++) {
      Years.add(DateTime.now()
          .subtract(Duration(days: 5 * 365))
          .add(Duration(days: loop * 365))
          .year);
    }
    scroll = const BouncingScrollPhysics();
    Tc = TabController(length: 2, vsync: this);
  }

  SqlDb sqldb = SqlDb();

  Future searchDb() async {
    late var data;
    if (SearchByDatebool) {
      DateFormat d = Intl.withLocale('en', () => DateFormat('yyyy-MM-dd'));
      print(fromTxtController.text);
      print(
          "${d.format(Intl.withLocale('en', () => DateFormat('dd/MMM/yyyy').parse(fromTxtController.value.text)))} lolololol ${Intl.withLocale('en', () => d.format(DateFormat('dd/MMM/yyyy').parse(toTxtController.text)))}");
      data = await sqldb.readData(
          'select * from meetings where date >= \'${d.format(Intl.withLocale('en', () => DateFormat('dd/MMM/yyyy').parse(fromTxtController.text)))}\' and date <= \'${d.format(Intl.withLocale('en', () => DateFormat('dd/MMM/yyyy').parse(toTxtController.text)))}\'');
      print('data12345');
      print('$data popopo');
      SearchByDatebool = false;
      data.length == 0 ? data = 'no' : null;
    } else {
      if (selectedItems.isNotEmpty) {
        if (searchTxt.length == 0) {
          data = 'no';
        } else {
          print(selectedItems);
          print(              'select * from meetings where ${selectedItems.contains('Topic') || selectedItems.contains('الموضوع') ? ' about like "%' + searchTxt + '%" ${selectedItems.length > 1 ? ' or ' : ''}' : ''} ${selectedItems.contains('Person or Entity') || selectedItems.contains('الشخص أو العنوان') ? ' person like "%$searchTxt%" ${selectedItems.contains('Address') || selectedItems.contains('العنوان') ? ' or ' : ''}' : ''}  ${selectedItems.contains('Address') || selectedItems.contains('العنوان')? ' address like "%' + searchTxt + '%"' : ''}');
          data = await sqldb.readData(
              'select * from meetings where ${selectedItems.contains('Topic') || selectedItems.contains('الموضوع') ? ' about like "%' + searchTxt + '%" ${selectedItems.length > 1 ? ' or ' : ''}' : ''} ${selectedItems.contains('Person or Entity') || selectedItems.contains('الشخص أو الجهة') ? ' person like "%$searchTxt%" ${selectedItems.contains('Address') || selectedItems.contains('العنوان') ? ' or ' : ''}' : ''}  ${selectedItems.contains('Address') || selectedItems.contains('العنوان')? ' address like "%' + searchTxt + '%"' : ''}');

          if (data.length == 0) {
            data = 'no';
          }
        }
      } else {
        data = 'Filter';
      }
    }

    return data;
  }

  final List<String> items = [
    '${S.current.topic}',
    '${S.current.address}',
    '${S.current.personOrEntity}',
  ];
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF272A37),
        body: TabBarView(controller: Tc, physics: scroll, children: [
          SearchByTxt(),
          SearchByDate(),
        ]),
      ),
    );
  }

  SearchByTxt() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(children: [
          Row(children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF7E7EBE),
              ),
            ),
            Container(
              width: 300,
              height: 45,
              child: Focus(
                onFocusChange: (value) {
                  if (value) {
                    setState(() {
                      scroll = const NeverScrollableScrollPhysics();
                    });
                  } else {
                    if (scroll != const BouncingScrollPhysics()) {
                      setState(() {
                        scroll = const BouncingScrollPhysics();
                      });
                    }
                  }
                },
                child: TextField(
                  controller: txtField,
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      searchTxt = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: '${S.current.searchHint}',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF7E7EBE),
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    fillColor: Color(0xff323644),
                    filled: true,

                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ),
            ),
            //   ])

            Container(
              margin: EdgeInsets.only(top: 10, left: 1),

              child: Stack(
                  alignment: Alignment.center,
                  children: [
                Container(
                  margin: EdgeInsets.only(bottom: ScreenWidth * 0.06),
                  child: Text(
                    '${S.current.searchBy}',
                    style: TextStyle(color: Colors.grey[300]),

                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: false,

                    dropdownStyleData: DropdownStyleData(
                        width: 140,
                        decoration: BoxDecoration(
                          color: Color(0xff323644),
                        )),
                    items: items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        //disable default onTap to avoid closing menu when selecting an item
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, menuSetState) {
                            final isSelected = selectedItems.contains(item);
                            return InkWell(
                              onTap: () {
                                isSelected
                                    ? selectedItems.remove(item)
                                    : selectedItems.add(item);
                                //This rebuilds the StatefulWidget to update the button's text
                                setState(() {});
                                //This rebuilds the dropdownMenu Widget to update the check mark
                                menuSetState(() {});
                              },
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_box_outlined,
                                        color: Color(0xFF7E7EBE),
                                      )
                                    else
                                      const Icon(
                                        Icons.check_box_outline_blank,
                                        color: Color(0xFF7E7EBE),
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                    value: selectedItems.isEmpty ? null : selectedItems.last,
                    onChanged: (value) {},
                    selectedItemBuilder: (context) {
                      return items.map(
                        (item) {
                          return Container();
                        },
                      ).toList();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      width: 70,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ]),
            )
          ]),
          Flexible(
              child: Container(
            margin: EdgeInsets.only(top: 10),
            child: FutureBuilder(
                future: searchDb(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.toString());
                    if (snapshot.data!.toString() != 'Filter') {
                      if (snapshot.data!.toString() != 'no') {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${snapshot.data!.length} ${S.current.resultsTxt}',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return
                                      // Text('${snapshot.data![index] ['name']}',style: TextStyle(color: Colors.white, fontSize: 24),);
                                      CardVu(
                                    PersonOrEntity_title: snapshot.data![index]
                                        ['person'],
                                    Topic_Content: snapshot.data![index]
                                            ['about']
                                        .toString(),
                                    Address_NoteId: snapshot.data![index]
                                        ['address'],
                                    Date: snapshot.data![index]['date'],
                                    Time: snapshot.data![index]['time'],
                                    PdfLink: snapshot.data![index]
                                        ['attachmentLink'],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: Text(
                          '${S.current.noResultsTxt}',
                          style: TextStyle(color: Colors.grey[300]),
                        ));
                      }
                    } else {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${S.current.selectFilterTxt}',
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${S.current.swipeTxt}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Icon(
                            Icons.swipe_left_outlined,
                            color: Color(0xFF7E7EBE),
                          ),
                        ],
                      ));
                    }
                  }
                  return CircularProgressIndicator();
                }),
          )),
        ]),
      );

  SearchByDate() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                width: 140,
                child: TextField(
                  controller: fromTxtController,
                  focusNode: fromTxtFocus,
                  readOnly: true,
                  showCursor: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    hintText: '--/--/----',
                    hintStyle: TextStyle(color: Colors.grey),
                    label: Text(
                      '${S.current.fromTxt}',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Color(0xff1E2126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              ),
              Container(
                width: 140,
                child: TextField(
                  focusNode: toTxtFocus,
                  controller: toTxtController,
                  readOnly: true,
                  showCursor: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    hintText: '--/--/----',
                    hintStyle: TextStyle(color: Colors.grey),
                    label: Text(
                      '${S.current.toTxt}',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Color(0xff1E2126),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              ),
            ]),
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(70),
                child: Container(
                  width: 260,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: Color(0xff1E2126),
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    DatePickerSpinner(),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              SizedBox(
                                width: 28,
                              ),
                              Container(
                                width: 30,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 45,
                              ),
                              Container(
                                width: 50,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Container(
                                width: 55,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 25,
                            ),
                            Row(children: [
                              // Expanded  (child: Divider(thickness: 1,color: Colors.green,indent: 50,endIndent: 50,)),
                              // Expanded(child: Divider(thickness: 1,color: Colors.green,indent: 50,endIndent: 50,)),
                              // Expanded(child: Divider(thickness: 1,color: Colors.green,indent: 50,endIndent: 50,)),

                              SizedBox(
                                width: 28,
                              ),
                              Container(
                                width: 30,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 45,
                              ),

                              Container(
                                width: 50,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Container(
                                width: 55,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                  ),
                                ),
                              ),
                            ]),
                          ]),
                    )
                  ]),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 220, bottom: 50),
                child: ElevatedButton(
                    onPressed: () {
                      FToast f = FToast();
                      f.init(context);

                      if (toTxtController.text == '--/--/----' &&
                          fromTxtController.text == '--/--/----') {
                        f.showToast(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(70)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${S.current.selectDatesTxt}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      } else if (toTxtController.text == '--/--/----') {
                        f.showToast(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(70)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${S.current.selectToDateTxt}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      } else if (fromTxtController.text == '--/--/----') {
                        f.showToast(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(70)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${S.current.selectFromDateTxt}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      } else {
                        SearchByDatebool = true;
                        setState(() {});
                        Tc.animateTo(0);
                      }
                    },
                    child: Text('${S.current.searchBtn}')))
          ],
        ),
      );

  Widget DatePickerSpinner() => Row(
        children: [
          Flexible(
            child: ListWheelScrollView.useDelegate(
              //  magnification: 1,
              // useMagnifier: true,
              squeeze: 1.5,
              controller: dayController,
              diameterRatio: 1.2,
              perspective: 0.006,
              itemExtent: 50,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) => setState(() {
                if (toTxtFocus.hasFocus) {
                  toTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                } else if (fromTxtFocus.hasFocus) {
                  fromTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                  print('From');
                } else {
                  print('search');
                }
              }),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: yearController.positions.isNotEmpty
                    ? DateUtils.getDaysInMonth(
                        Years[yearController.selectedItem],
                        monthController.selectedItem + 1)
                    : DateUtils.getDaysInMonth(Years[0], 1),
                builder: (context, index) {
                  return Text(
                    '${index < 9 ? '0' : ''}${index + 1}',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  );
                },
              ),
            ),
          ),
          Flexible(
            child: ListWheelScrollView.useDelegate(
              //  magnification: 1,
              // useMagnifier: true,
              controller: monthController,
              squeeze: 1.5,
              diameterRatio: 1.2,
              perspective: 0.006,
              itemExtent: 50,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) => setState(() {
                if (toTxtFocus.hasFocus) {
                  toTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                } else if (fromTxtFocus.hasFocus) {
                  fromTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                  print('From');
                } else {
                  print('search');
                }
              }),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 12,
                builder: (context, index) {
                  return Text(
                    '${Months[index]}',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  );
                },
              ),
            ),
          ),
          Flexible(
            child: ListWheelScrollView.useDelegate(
              //  magnification: 1,
              // useMagnifier: true,
              controller: yearController,
              squeeze: 1.5,
              diameterRatio: 1.2,
              perspective: 0.006,
              itemExtent: 50,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (value) => setState(() {
                if (toTxtFocus.hasFocus) {
                  toTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                } else if (fromTxtFocus.hasFocus) {
                  fromTxtController.text =
                      '${dayController.selectedItem < 9 ? '0' : ''}${dayController.selectedItem + 1}/${Months[monthController.selectedItem]}/${Years[yearController.selectedItem]}';
                  print('From');
                } else {
                  print('search');
                }
              }),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 10,
                builder: (context, index) {
                  return Text(
                    '${Years[index]}',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  );
                },
              ),
            ),
          ),
        ],
      );


}

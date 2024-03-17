import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

void main (){
  runApp(app());
}

  class app extends StatefulWidget{
  State<app> createState() => _appState();
}

  TextEditingController txtController = TextEditingController();
class _appState extends State<app> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(

          appBar: AppBar(
            title: Text("Learning"),

          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12),
                width: 400,
                child: TextFormField(

                  controller: txtController,
                  decoration: InputDecoration(hintText: "Search......",

                                              prefixIcon: Icon(Icons.search_outlined),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                                                                         borderSide: BorderSide(color: Colors.black),)),
                  onTap: () {
                 showSearch(context: context, delegate: searchDel(),query: txtController.text);
                },onFieldSubmitted: (value) {

                    showSearch(context: context, delegate: searchDel(),query: txtController.text);
                    },),
              )
            ]
          ),

        )

    );
  }
}

class searchDel extends SearchDelegate{

  int Resindex =0 ;
   late List Data = [];
  List FilteredData = [];


  Future<List> gettingData () async{
    var response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    Data.addAll(jsonDecode(response.body ));

    return Data;
  }


  @override
  List<Widget>? buildActions(BuildContext context) {

    return [
      IconButton(onPressed: (){
        query = "";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    return
      IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    ;
    return
        Center(
          child: Container(width: 300,height: 220,
              child: Card(child:  ListTile(isThreeLine: true,leadingAndTrailingTextStyle: TextStyle(color: Colors.black),onTap: (){}, title: Text(Data[Resindex]["title"],style: TextStyle(fontWeight: FontWeight.bold),),leading: Text(Data[Resindex]["id"].toString()),trailing: Text(Data[Resindex]["userId"].toString()),subtitle: Text(Data[Resindex]["body"], style: TextStyle(fontWeight: FontWeight.w300),),)
          ))
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query == ""){
    return
      PopScope(
        onPopInvoked: (didPop) {
          if(didPop && query.isNotEmpty){
            txtController.text = query;
          }
        },
        child: FutureBuilder(future: gettingData(), builder: (context, snapshot) {
          if(snapshot.hasData){
            Data = snapshot.data!;
            return ListView.builder(
                itemCount: Data.length,
                itemBuilder: (context, index) {
                 return InkWell(
                   onTap: (){
                     Resindex = index ;
                     showResults(context);
                   },
                   child: Card(shadowColor: Color(0xff8c00ff),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),


                      ),

                      child: Text(Data[index]["title"]),
                    ),
                 );
                }
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },),
      );
    }else{
      return
        PopScope(
          onPopInvoked: (didPop) {
            if(didPop && query.isNotEmpty){
              txtController.text = query;
            }
          },
          child: FutureBuilder(future: gettingData(), builder: (context, snapshot) {
            if(snapshot.hasData){
              Data = snapshot.data!;

              for(int index = 0; index < Data.length; index++){

                if(Data[index]['title'].toString().contains(query)){

                  FilteredData.add(Data[index]["title"]);
                }
              }
              return ListView.builder(
                  itemCount: FilteredData.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Resindex = index ;
                        print(Resindex);
                        showResults(context);
                      },
                      child: Card(shadowColor: Color(0xff8c00ff),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),


                        ),


                        child: Text(FilteredData[index]),
                      ),
                    );
                  }
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },),
        );
    }
  }

}
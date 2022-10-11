import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'for_second_screen/list_compo.dart';
import 'for_second_screen/list_compo_defi.dart';

final databaseReference = FirebaseDatabase.instance.ref();

class ResponseDataScreen{
  final bool resp;
  final List<ListCompoDefi> listAllData;

  ResponseDataScreen({
    required this.resp,
    required this.listAllData,
  });

  factory ResponseDataScreen.fromJson(Map<String,dynamic> json){
    List<dynamic> o = json['listData'] as List;
    return ResponseDataScreen(
      resp: json['respRec'],
      listAllData: o.map((e) => ListCompoDefi.toJson(e)).toList()
    );
  }
}

class ScreenSteps extends StatelessWidget {
  final String idForLoad;
  final String nameOnScreen;
  const ScreenSteps({
    Key? key,
    required this.idForLoad,
    required this.nameOnScreen
  }) : super(key: key);


  // Future<ResponseDataScreen> getAllDataPrev() async {
  //   Map<String, String> bodyData = {
  //     'name': 'doodle',
  //     'color': 'blue',
  //     'homeTeam': json.encode(
  //       {'team': 'Team A'},
  //     ),
  //     'awayTeam': json.encode(
  //       {'team': 'Team B'},
  //     ),
  //   };
  //   print("sent");
  //   Map<String, String> postHeaders = {"Content-Type": "application/json"};
  //   String encodedBody = json.encode({'id': 'one','token': 'two'});
  //   final http.Response response = await http.post(
  //       Uri.parse('http://192.168.18.150:3000/screen'),
  //       headers: postHeaders,
  //       body: encodedBody
  //   );
  //   print("sent");
  //   log(response.body.toString());
  //   Map<String,dynamic> recData = jsonDecode(response.body);
  //   return ResponseDataScreen.fromJson(recData);
  // }


  Future<ResponseDataScreen> getAllData() async{
  log(idForLoad);
    final snapshot = await databaseReference.child('/topLevel/secondLevel/screenData/listData/${idForLoad}').get();
    if (snapshot.exists) {
      String at = jsonEncode(snapshot.value);
      log(at);
      Map<String,dynamic> recData = jsonDecode(at);


      return(ResponseDataScreen.fromJson(recData));
    }else{
      String response = '{respRec:false,listData:[]}';
      Map<String,dynamic> recData = jsonDecode(response);
      return(ResponseDataScreen.fromJson(recData));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 4, 34,1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            alignment: Alignment.topLeft,
            width: double.infinity,
            color: const Color.fromRGBO(34,167,255, 1),
            child: SafeArea(
              child: Container(
                width: 80,
                height: 40,
                margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(4, 4, 34, 1),
                  borderRadius: BorderRadius.circular(50)
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context,this);
                  },
                  child: Text("BACK",style: TextStyle(
                      color: Color.fromRGBO(34, 167, 255, 1),
                      fontSize: 10
                  ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(nameOnScreen.toUpperCase(),textAlign: TextAlign.start,style: const TextStyle(
                        color: Color.fromRGBO(34,167, 255, 0.9),
                        letterSpacing: 4,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(color: Color.fromRGBO(5, 5, 5, 1),offset: Offset(2,2),blurRadius: 20)
                        ]
                    ),),
                  ),

                ),
                FutureBuilder<ResponseDataScreen>(
                  builder: (context , snapshot){
                    log("aa");
                    log(snapshot.data.toString());
                    if(snapshot.hasData){
                      if(snapshot.data!.resp){
                        print(snapshot.data);
                        print("HEre");
                        if(snapshot.data!.listAllData.isEmpty){
                          return Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text("There was an ERROR!",style: TextStyle(
                                color: Color.fromRGBO(4, 4, 34, 1),
                                fontSize: 19,
                                letterSpacing: 1.5,
                              ),),
                            ),
                          );
                        }
                        return Expanded(
                          child: Container(

                            color: const Color.fromRGBO(4, 4, 34, 1),
                            child: ListView.builder(
                                padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                itemCount: snapshot.data!.listAllData.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ListCompo(
                                        compoDefi: ListCompoDefi(
                                            nameContain: snapshot.data!.listAllData[index].nameContain,
                                            addressContain: snapshot.data!.listAllData[index].addressContain
                                        ),
                                        pos: index,
                                      ),
                                      const Divider(
                                        color: Color.fromRGBO(34, 167, 255, 0.3),
                                      ),
                                      // const Dash(
                                      //
                                      //
                                      //   dashLength: 6,
                                      //
                                      //   dashColor: Color.fromRGBO(34, 167, 255, 0.4),
                                      //   dashThickness: 6,
                                      //   dashBorderRadius: 50,
                                      //   dashGap: 6,
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ]
                                  );
                                }
                            ),
                          ),
                        );
                      }else{
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text("There was an ERROR!",style: TextStyle(
                              color: Color.fromRGBO(4, 4, 34, 1),
                              fontSize: 19,
                              letterSpacing: 1.5,
                            ),),
                          ),
                        );
                      }
                    }else if(snapshot.hasError){
                      return Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child:  const Text("There was an Error!",style: TextStyle(
                            color: Color.fromRGBO(4, 4, 34, 1),
                            fontSize: 19,
                            letterSpacing: 1.5,
                          ),),
                        ),
                      );
                    }
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:  const CircularProgressIndicator(
                          color: Color.fromRGBO(34, 167, 255, 1),
                        ),
                      ),
                    );
                  },
                  future: getAllData(),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
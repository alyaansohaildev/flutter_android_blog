import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:webdeveloper/application_info.dart';
import 'package:webdeveloper/widgets_in/post_compo.dart';

/*
* 0: Text Simple
* 1: Head Text
* 2: Head Secondary Text
* 3: Image
* 4: Code */
final databaseReference = FirebaseDatabase.instance.ref();


class RespData{
  bool respRec = false;

  final List<PostCompo> postList;

  RespData({
    required this.respRec,
    required this.postList
  });

  factory RespData.fromJson(Map<String,dynamic> json){
    List<dynamic> postListA = json['listData'] as List;
    List<PostCompo> postListCh = postListA.map((e) => PostCompo.fromJson(e)).toList();
    return RespData(
      respRec: json['respRec'],
      postList: postListCh
    );
  }

}

class DetailScreen extends StatelessWidget {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String nameScreen;
  String addressScreen;
  int screenType;
  DetailScreen({
    Key? key,
    required this.nameScreen,
    required this.addressScreen,
    required this.screenType,
  }) : super(key: key);



  // Future<RespData> fetchAlbuma() async {
  //     final http.Response response = await http.get(Uri.parse('http://programmingcrate.com/webdeveloper/test_flutter.php'));
  //     Map<String,dynamic> recData = jsonDecode(response.body);
  //     return RespData.fromJson(recData);
  // }
  Future<RespData> fetchAlbum() async{
    log("/topLevel/secondLevel/detailData/$addressScreen");
    late final snapshot;
    if(screenType == 0){
      snapshot = await databaseReference.child('/topLevel/secondLevel/detailData/${addressScreen}').get();
    }else if(screenType == 1){
      snapshot = await databaseReference.child('/topLevel/secondLevel/topicData/${addressScreen}').get();
    }


    log(snapshot.value.toString() + "was n");
    if (snapshot.exists) {

      String at = jsonEncode(snapshot.value);
      Map<String,dynamic> recData = jsonDecode(at);
      return RespData.fromJson(recData);
    }else{
      String responseOnFailed = '{"respRec":"Failed"}';
      return RespData.fromJson(jsonDecode(responseOnFailed));
    }
  }

  Future<String> getDownloadUrl(imgName) async{
    final ref = FirebaseStorage.instance.ref().child("/imageContainer/"+imgName);
    var url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color.fromRGBO(235,235,235,1),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 80,
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(10, 40, 0, 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(4,4,34, 1),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  padding: EdgeInsets.all(0),

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
              FutureBuilder<RespData>(
                  future: fetchAlbum(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if(snapshot.data!.respRec){
                        return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(10),
                                  itemCount: snapshot.data!.postList.length,
                                  itemBuilder: (BuildContext context,int index){

                                    if(snapshot.data!.postList[index].pType == 0){
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          // color: Color.fromRGBO(235, 235, 235, 1),
                                          borderRadius: BorderRadius.circular(4)
                                        ),
                                        child:Text(snapshot.data!.postList[index].title,style: const TextStyle(color: Color.fromRGBO(30, 30, 30, 1),fontSize: 18),)
                                      );
                                    }else if(snapshot.data!.postList[index].pType == 1){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
                                        child: Text(
                                          snapshot.data!.postList[index].title.toUpperCase(),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(4, 4, 34, 1),
                                            fontSize: 34,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w600,
                                            shadows: <Shadow>[
                                              Shadow(
                                                color: Color.fromRGBO(0,0, 0, 0.2),
                                                blurRadius: 6,
                                                offset: Offset(2,2)
                                              )
                                            ]
                                          ),
                                        ),
                                      );
                                    }else if(snapshot.data!.postList[index].pType == 2){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                                        child: Text(
                                          snapshot.data!.postList[index].title.toUpperCase(),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0,0, 0, 1),
                                              fontSize: 22,
                                              letterSpacing: 1.4
                                          ),
                                        ),
                                      );
                                    }else if(snapshot.data!.postList[index].pType == 3){

                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(alignment:Alignment.center, child: Text("Pinch to Zoom",style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3)),)),
                                            InteractiveViewer(
                                              panEnabled: false, // Set it to false
                                              boundaryMargin: const EdgeInsets.all(0),
                                              minScale: 1,
                                              maxScale: 2,
                                              child: FutureBuilder<String>(
                                                future: getDownloadUrl(snapshot.data!.postList[index].title,),
                                                builder: (context,snapshot){
                                                  if(snapshot.hasData){
                                                    return(
                                                        Image.network(snapshot.data.toString())
                                                    );
                                                  }else{
                                                    return Container(alignment:Alignment.center,width:100,height: 100,child:CircularProgressIndicator(color: ApplicationInfo.mainBlueDark,));
                                                  }

                                                },
                                              )
                                            ),
                                          ],
                                        )
                                      );
                                    }
                                    return Text("AD");
                                  }
                              )


                        );
                      }else{
                        return Expanded(child: Container(decoration: const BoxDecoration(),alignment: Alignment.center,child: const Text("ERROR SORRY!",style: TextStyle(color: Color.fromRGBO(255, 100, 100, 1),fontSize: 25,fontWeight: FontWeight.bold),)));
                      }

                    } else if (snapshot.hasError) {
                      return Expanded(child: Container(decoration: const BoxDecoration(),alignment: Alignment.center,child: const Text("A problem occured!",style: TextStyle(color: Color.fromRGBO(255, 100, 100, 1),fontSize: 25,fontWeight: FontWeight.bold),)));
                    }

                    // By default, show a loading spinner.
                    return Expanded(child: Center(child: Container(width: 150,height: 150,alignment: Alignment.center,child: const CircularProgressIndicator(color: Color.fromRGBO(4, 4, 34,1),))));
                  },
                )

            ],
        ),

    );
  }
}
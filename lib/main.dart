import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webdeveloper/detail_screen.dart';
import 'package:webdeveloper/fonts/list_icon_icons.dart';
import 'package:webdeveloper/fonts/road_map_icons.dart';
import 'package:webdeveloper/topic_screen.dart';
import 'package:webdeveloper/widgets_in/list_part_topic.dart';
import 'package:webdeveloper/widgets_in/post_compo.dart';
import 'application_info.dart';
import 'firebase_options.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:webdeveloper/widgets_in/stepper_connected.dart';


import 'card_widget.dart';
GlobalKey<_AppBarState> _myKey = GlobalKey();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(34, 167, 255, 0),
      statusBarIconBrightness: Brightness
          .dark, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebDeveloper',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: AppBar(
            backgroundColor: ApplicationInfo.mainBlueDark,
            title: Container(
              height: 20,

              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child:Text("WEB DEVELOPER",style: TextStyle(letterSpacing: 2,fontSize: 16,color: ApplicationInfo.mainBlueLight),),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: AppBarBottom( key:_myKey),
            ),
          ),
        ),
        body: MainBody(),
      ),
    );
  }
}


class AppBarBottom extends StatefulWidget{
  const AppBarBottom({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppBarState();
  }



}
class _AppBarState extends State<StatefulWidget>{
  int pageNumber = 0;

  pageChanged(int changedIndex) => {
    callChanged(changedIndex)
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ApplicationInfo.mainBlueLight,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              RoadMap.road_map,
              color:pageNumber == 0 ? ApplicationInfo.mainWhite:ApplicationInfo.mainBlueDark,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(

              // Icons.format_list_bulleted,
              ListIcon.post_list,
              color:pageNumber == 1 ? ApplicationInfo.mainWhite:ApplicationInfo.mainBlueDark,
              size: 30,
            ),
          )

        ],
      ),
    );
  }

  callChanged(int changedIndex){
    setState(() {
      pageNumber = changedIndex;
    });
  }

}

class InnerListPropertyContainer{

  String name;
  int address;
  List<String> topicInclusions;
  InnerListPropertyContainer({
    required this.name,
    required this.address,
    required this.topicInclusions
  });

  factory InnerListPropertyContainer.fromJson(Map<String,dynamic> dataInner){
    List<dynamic> o = dataInner['topicInclusions'];
    return InnerListPropertyContainer(
        name: dataInner['name'] as String,
        address: dataInner['address'] as int,
        topicInclusions: o.map((e) => e.toString()).toList(),

    );
  }
}

class ListContainer{
  InnerListPropertyContainer listContained;
  String keyName;
  int typeList = 1;

  ListContainer({
    required this.listContained,
    required this.keyName
  });

  factory ListContainer.fromJson(String keyRec,dynamic value){

    return ListContainer(
      listContained: InnerListPropertyContainer.fromJson(Map<String, dynamic>.from(value)),
      keyName: keyRec

    );
  }
}

//
// typedef G = List<ListContainer> Function();
// typedef ReturnInt = int Function();
// typedef InsertObject = void Function(ListContainer b);

class ListViewTopic extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    return ListViewTopicState();
  }


}

class ListViewTopicState extends State<ListViewTopic> with AutomaticKeepAliveClientMixin<ListViewTopic>{

  ScrollController _scrollController = ScrollController();

  ListViewTopicState();

  final databaseReference = FirebaseDatabase.instance.ref();

  List<ListContainer> topicContainerList = [];

  int lastIndex = 0;
  bool floatingButton = false;

  bool updateLock = false;

  String lastKey = "not";
  int lastAddress = -1;

  int incrementValue = 2;

  int startValue = 0;
  int endValue = 2;

  Future<void> getAllTopicData() async {
    final snapshot;
    if(!updateLock) {
      // if (lastKey != "not") {
        log("last key exist ");
        snapshot = await databaseReference.child(
            '/topLevel/secondLevel/topicList').orderByChild("address")
            .startAt(startValue)
            .endAt(endValue)
            .get();
      // } else {
      //   log("last key exist NO!");
      //   snapshot = await databaseReference.child(
      //       '/topLevel/secondLevel/topicList').orderByChild("address").limitToFirst(2).get();
      //
      // }

      if (snapshot.exists) {
        String at = jsonEncode(snapshot.value);
        log(at);
        Map<String, dynamic> o = jsonDecode(at);
        // Map<String, dynamic> o = Map<String, dynamic>.from(snapshot.value as Map);

        List<ListContainer> listContained = [];

        o.map((key, value) {
          listContained.add(ListContainer.fromJson(key, value));
          return MapEntry(key, value);
        });
        // lastKey = listContained[0].keyName;
        // lastAddress = listContained[0].listContained.address;
        // print("${lastAddress} was last key");

        setState(() {
          for (int i = 0; i < listContained.length; i++) {
            topicContainerList.add(listContained.elementAt(i));
          }
        });
        startValue +=incrementValue+1;//0 3 6
        endValue +=incrementValue+1;//2 5 7
      } else {
        updateLock = true;
        ListContainer a = ListContainer(keyName: "No More To Show",
            listContained: InnerListPropertyContainer(
                address: 2, name: "a", topicInclusions: []));
        a.typeList = -1;
        setState(() {
          topicContainerList.add(a);
        });
      }
    }
  }



  void setFloatingButton(bool valueBool){
    setState(() {
      floatingButton = valueBool;
    });
  }

  void scrollListener(){
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll-50)) {
      if(!floatingButton){
        setFloatingButton(true);
      }
    }else{
      if(floatingButton){
        setFloatingButton(false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAllTopicData();
    _scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
        children: <Widget>[
          Container(

            child: ListView.builder(
              controller: _scrollController,
              itemCount: topicContainerList.length,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              itemBuilder: (BuildContext context, int index) {
                if(topicContainerList[index].typeList == -1){
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    child: Text("NO MORE TO SHOW",style: TextStyle(letterSpacing: 2,color: ApplicationInfo.mainWhite),),
                  );
                }else{
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context){
                              return DetailScreen(
                                screenType: 1,
                                nameScreen: topicContainerList[index].listContained.name,
                                addressScreen: topicContainerList[index].listContained.address.toString() as String,
                              );
                            }

                        )
                      );
                    },
                    child: ListPartTopic(
                      topicInclusions: topicContainerList[index].listContained.topicInclusions,
                      topicName: topicContainerList[index].listContained.name,
                      topicAddress: topicContainerList[index].listContained.address,
                    ),
                  );
                }

              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            // add your floating action button
            child: Opacity(
              opacity: floatingButton ? 1:0,
              child: Container(
                margin: const EdgeInsets.all(20),

                width: 80,
                height: 30,

                child: FloatingActionButton(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2)
                  ),
                  onPressed: () {
                    getAllTopicData();
                  },
                  child:const Padding(
                    padding:  EdgeInsets.all(0),
                    child: Text("LOAD MORE",style: TextStyle(fontSize: 10),),
                  ),
                ),
              ),
            )
          ),

        ],

    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}






class MainBody extends StatelessWidget{
  MainBody({Key? key}) : super(key: key);

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void loadList(int startIndex){
    
  }

  @override
  Widget build(BuildContext context) {
    return  Container(

            width: double.infinity,
            decoration: BoxDecoration(
                color: ApplicationInfo.mainBlueDark
            ),
            child: PageView(
             controller: _pageController,
              onPageChanged: (index){
                _myKey.currentState?.pageChanged(index);
              },
              children:  [
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(4, 4, 34, 1),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              blurRadius: 10.0,
                              offset: Offset(0,0),
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:const EdgeInsets.all(20),
                          child: const Text("ARE YOU A BEGINNER?",
                            style: TextStyle(
                              color: Color.fromRGBO(245,245,245,1),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 2,

                            ),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FittedBox(
                              child: Text("THE\n ROADMAP",
                                style: TextStyle(
                                    color: Color.fromRGBO(34,167,255,1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3,
                                    height: 2

                                ),),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/web_dev_step_by_step.png',
                                    ),
                                    fit: BoxFit.cover,

                                  )
                              ),
                            ),

                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              StepperConnected(
                                stepperPos: "1",
                                titleM: "The Basics Of Web",
                                titleSec: "What is Webpage? How a Website is built.",
                              ),
                              Dash(
                                direction: Axis.vertical,
                                length: 60,
                                dashLength: 6,
                                dashColor: Color.fromRGBO(34, 167, 255, 0.6),
                                dashThickness: 6,
                                dashBorderRadius: 50,
                                dashGap: 6,
                              ),
                              StepperConnected(
                                stepperPos: "2",
                                titleM: "Designing of a WebPage",
                                titleSec: "How a Webpage is Designed. Using Website Builders to build webpages.",
                              ),
                              Dash(
                                direction: Axis.vertical,
                                length: 60,
                                dashLength: 6,

                                dashColor: Color.fromRGBO(34, 167, 255, 0.6),
                                dashThickness: 6,
                                dashBorderRadius: 50,
                                dashGap: 6,
                              ),
                              StepperConnected(
                                stepperPos: "3",
                                titleM: "Using JavaScript",
                                titleSec: "What is JavaScript? How can we use JavaScript in web page to build more interactive web pages!",
                              ),
                              Dash(
                                direction: Axis.vertical,
                                length: 60,
                                dashLength: 6,

                                dashColor: Color.fromRGBO(34, 167, 255, 0.6),
                                dashThickness: 6,
                                dashBorderRadius: 50,
                                dashGap: 6,
                              ),
                              StepperConnected(
                                stepperPos: "4",
                                titleM: "Server Side Using Php",
                                titleSec: "What is Webpage? How a Website is built.",
                              ),
                              Dash(
                                direction: Axis.vertical,
                                length: 60,
                                dashLength: 6,

                                dashColor: Color.fromRGBO(34, 167, 255, 0.6),
                                dashThickness: 6,
                                dashBorderRadius: 50,
                                dashGap: 6,
                              ),
                              StepperConnected(
                                stepperPos: "5",
                                titleM: "Database",
                                titleSec: "What is the use of database? Learn about SQL and NoSql Databases.",
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                ListViewTopic()
              ],
            ),
    );
  }

}

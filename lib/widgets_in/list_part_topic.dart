import 'package:flutter/cupertino.dart';

import '../application_info.dart';

class ListPartTopic extends StatelessWidget{

  String topicName = "Problem";
  int topicAddress = -1;
  List<String> topicInclusions;


  ListPartTopic({
    Key? key,
    required this.topicInclusions,
    required this.topicAddress,
    required this.topicName
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,30,30,0),
      decoration: BoxDecoration(

          border: Border.all(color: ApplicationInfo.mainBlueLight,width: 1),
          borderRadius: BorderRadius.circular(2)
      ),
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(topicName,style: TextStyle(color: ApplicationInfo.mainWhite),),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.start,
              children: List.generate(topicInclusions.length, (index) {
                return buttonBottomTopicInclusions(topicInclusions[index]);
              })
            ),
          ),

        ],
      ),
    );
  }

}

Widget buttonBottomTopicInclusions(String textDisplay){
  return Container(
    margin:EdgeInsets.fromLTRB(5, 5, 5, 0),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: ApplicationInfo.mainBlueLight.withOpacity(0),
        border: Border.all(color: ApplicationInfo.mainWhite)
    ),
    child: Text(textDisplay,style: TextStyle(letterSpacing: 1,fontSize: 8,color: ApplicationInfo.mainWhite),),
  );
}
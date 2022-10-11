import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4,4,34, 1.0),
        title: Text("WEB DEVELOPER",style: TextStyle(letterSpacing: 2,fontSize: 16,color: Color.fromRGBO(34, 167, 255, 1)),),
      ),
      body: SafeArea(
        child: Container(
          child: Text("aa"),
        ),
      ),
    );
  }

}
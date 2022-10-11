import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget{
  const CardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(
              'assets/html_webdeveloper.png'),
          fit: BoxFit.fill,
        ),
        // color: const Color.fromRGBO(4,4,34,1),
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(color: Color.fromRGBO(4, 4, 64, 1),width: 1,style: BorderStyle.solid),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ]
      ),
      padding: const EdgeInsets.all(14),
      child: const Text("JAVASCRIPT",style: TextStyle(
          color: Color.fromRGBO(245,245,245,1),
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          shadows:<Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 10.0,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ] ),),
    );
  }

}
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../detail_screen.dart';
import 'list_compo_defi.dart';

class ListCompo extends StatelessWidget{
  final ListCompoDefi compoDefi;
  final int pos;
  const ListCompo({
    Key? key,
    required this.compoDefi,
    required this.pos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: Text(compoDefi.nameContain,style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: Color.fromRGBO(245, 245, 245, 0.8)
                    ),),
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(34, 167, 245, 0.2)),
                        foregroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(34, 167, 245, 1)),
                      ),

                      onPressed: (){

                        Navigator.push(context,MaterialPageRoute(

                            builder: (context) =>DetailScreen(screenType: 0,nameScreen: compoDefi.nameContain,addressScreen: compoDefi.addressContain,)
                          ),
                        );
                      },
                      child: const Text("VIEW",style: TextStyle(letterSpacing: 2),)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
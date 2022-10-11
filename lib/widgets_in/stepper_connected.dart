import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen_steps.dart';

class StepperConnected extends StatelessWidget{
  final String titleM;
  final String titleSec;
  final String stepperPos;
  const StepperConnected({
    Key? key,
    required this.titleM,
    required this.titleSec,
    required this.stepperPos,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0), child:Row(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(34, 165, 255, 1)),
              borderRadius: BorderRadius.circular(50)
          ),
          child: Text(stepperPos,style: const TextStyle(color: Color.fromRGBO(245, 245, 245, 1),fontSize: 14),),
        ),
        Expanded(
            child:Padding(
              padding:const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleM,style: const TextStyle(color: Color.fromRGBO(245, 245, 245, 1),fontSize: 17,letterSpacing: 2),),
                  Container( padding:const EdgeInsets.all(10),child:Text(titleSec,style: const TextStyle(color: Color.fromRGBO(245, 245, 245, 1),fontSize: 14,letterSpacing: 2))),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(34, 167, 245, 1)),
                      backgroundColor:  MaterialStateProperty.all<Color>(const Color.fromRGBO(34, 167, 245, 0.2)),
                    ),
                    onPressed: () {
                      String idForLoad = "basic_"+stepperPos;
                        Navigator.push(context,MaterialPageRoute(
                          builder: (context) => ScreenSteps(idForLoad: idForLoad,nameOnScreen: titleM,)
                        ),
                      );
                    },
                    child: Padding(padding: EdgeInsets.all(5), child: Text('Go Now',style: TextStyle(letterSpacing: 2,fontSize: 17),),),
                  )
                ],
              ),
            )
        )
      ],
    ));
  }

}
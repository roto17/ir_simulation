import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../misc/lib_colors.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin : EdgeInsets.only(left: 10,top: 20,right: 10),
      //color: Colors.red,

      child: Column(
        children: [
            Container(
            width: double.maxFinite,
            color: LibColors.lighGrey,
            child: Container(
              height: 250,
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1
                )
              ),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    child: const Text( "Instructions :",style: TextStyle(fontSize: 25),),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: const Text( "1) - Salaire de base est > à 0."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: const Text( "2) - Si vous constatez que vous avez pas un attribut sur votre Bultein de paie,merci de renseigner 0 comme valeur."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: const Text( "3) - Les Frais professionnels sont caluclés selon votre salaire de base."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: const Text( "4) - Si vous avez des questions merci de contacter zerouali.khalid2@gmail.com"),
                  )
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}


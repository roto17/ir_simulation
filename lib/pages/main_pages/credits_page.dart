import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../misc/lib_colors.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

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
                  height: 120,
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
                        child: const Text( "Crédits :",style: TextStyle(fontSize: 25),),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: const Text( "- Logique et Formule : Zakariae Bouhaji"),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: const Text( "- Dev et Design : Khalid Zerouali"),
                      ),
                    ],
                  ),
                )
            )
          ]
      ),
    );
  }
}

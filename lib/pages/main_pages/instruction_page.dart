import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    child: Text( "${AppLocalizations.of(context)!.instructionsPageTitle} :",style: TextStyle(fontSize: 25),),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: Text( "1) - ${AppLocalizations.of(context)!.instructionsPageRule1}."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: Text( "2) - ${AppLocalizations.of(context)!.instructionsPageRule2}."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: Text( "3) - ${AppLocalizations.of(context)!.instructionsPageRule3}."),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: Text( "4) - ${AppLocalizations.of(context)!.instructionsPageRule4}"),
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


import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';
import 'package:ir_simulation/cubit/app_cubits.dart';
import 'package:ir_simulation/misc/lib_colors.dart';
import 'package:flutter/material.dart';
import 'package:ir_simulation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
  }

  var mapImagesTitles = {
    "img1.jpg":"welcometitle1",
    "img2.jpg":"welcometitle2"
  };

  var mapImagesBGColors = {
    "img1.jpg":LibColors.lightSkin,
    "img2.jpg":LibColors.lightRed
  };

  var mapImagesColors = {
    "img1.jpg":Colors.white,
    "img2.jpg":Colors.white
  };

  Future<String> getStringFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mapImagesTitles.length,
          itemBuilder: (_,index){
            //print(mapImagesTitles.keys.elementAt(index));
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/welcome/${mapImagesTitles.keys.elementAt(index)}"),
                    fit: BoxFit.fitWidth
                ),
                color: Colors.white,
              ),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 4),
                        decoration: BoxDecoration(
                          color: mapImagesBGColors.values.elementAt(index),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                        ),
                        child: Text(
                          index==0?AppLocalizations.of(context)!.welcometitle1:AppLocalizations.of(context)!.welcometitle2,
                          style:TextStyle(
                              backgroundColor: mapImagesBGColors.values.elementAt(index),
                              color: mapImagesColors.values.elementAt(index),
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 80),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                //border: Border.all(color: LibColors.darkRed,width: 2),
                                color: LibColors.lightRed,
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                highlightColor: LibColors.darkRed,
                                icon: const Icon(Icons.navigate_next_rounded,size: 30,),
                                color: Colors.white,
                                tooltip: 'Enter The APP',
                                onPressed: () {
                                  globals.sharedPreferences!.setBool('visitedWelcomePage', true);
                                  BlocProvider.of<AppCubits>(context).goToLogin();
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(mapImagesTitles.length, (indexDots) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 2,right: 1),
                                  height: 14,
                                  width: index == indexDots? 25:14,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: index == indexDots?LibColors.lightRed:LibColors.lightRed.withOpacity(0.4),
                                   //   border: Border.all(color: Colors.grey.withOpacity(0.8)),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ]

                ),

            );
          })
      );
  }
}

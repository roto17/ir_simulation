import 'package:ir_simulation/misc/lib_colors.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  var mapImagesTitles = {
    "img1.jpg":"Simulate Your IR",
    "img2.jpg":"It's for FREE"
  };

  var mapImagesColors = {
    "img1.jpg":LibColors.lightSkin,
    "img2.jpg":LibColors.lightRed
  };

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
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                          color: mapImagesColors.values.elementAt(index),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                        ),
                        child: Text(
                          mapImagesTitles.values.elementAt(index),
                          style:TextStyle(
                              backgroundColor: mapImagesColors.values.elementAt(index),
                              color: Colors.white,
                              fontSize: 28,
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
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                highlightColor: LibColors.darkRed,
                                icon: const Icon(Icons.navigate_next_rounded,size: 30,),
                                color: Colors.white,
                                tooltip: 'Enter The APP',
                                onPressed: () {
                                  //print("ok");
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

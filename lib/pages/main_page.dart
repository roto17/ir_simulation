import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ir_simulation/misc/lib_colors.dart';
import 'package:ir_simulation/models/simulation_ir.dart';
import 'package:ir_simulation/models/indemnite.dart';
import 'package:ir_simulation/pages/components/bottom_sheet_switch.dart';
import 'globals.dart' as globals;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  bool _switchIsTaxed = true;
  bool _switchIsPercentage = true;

  var indemniteList = [
    Indemnite(name: "Indemnité de transport", value: 500),
    Indemnite(name: "Indemnité de panier", value: 700),
    Indemnite(name: "Indemnité de fonction", value: 0),
  ];

  var listtest  = <Indemnite>{
    Indemnite(name: "Indemnité de transport", value: 500),
    Indemnite(name: "Indemnité de panier", value: 700),
    Indemnite(name: "Indemnité de fonction", value: 0),
    Indemnite(name: "Indemnité de fonction", value: 0),
  };


 /* var detentionList = [
    Detention(name: "Indemnité de transport",value: 500, isPercentage: true, isTaxed: false),
    Detention(name: "Indemnité de panier",value: 700, isPercentage: true, isTaxed: false),
    Detention(name: "Indemnité de fonction",value: 0, isPercentage: true, isTaxed: false),
  ];*/


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              print("Log out");
            },
          )
        ],
        title: const Text('IR Simulation',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: LibColors.lighGrey,
        child: ListView(
          padding: const EdgeInsets.only(top: 20,right: 10,left: 10,bottom: 80),
          children: List.generate(indemniteList.length, (index){
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: Colors.white,
                    border: Border.all(color: LibColors.darkGrey)
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Row(
                        children: [
                          Text("${indemniteList[index].name} : "),
                          Text("${indemniteList[index].value.toStringAsFixed(2)} DH")
                          /*Text("${indemniteList[index].name} : ",style: const TextStyle(color: Colors.black54,fontSize: 13)),
                          Text("${indemniteList[index].value.toStringAsFixed(2)} DH",style: const TextStyle(color: Colors.black54,fontSize: 13,fontWeight: FontWeight.bold))
                          Icon( FontAwesomeIcons.circleDollarToSlot,color: detentionList[index].isTaxed==true?LibColors.lightGoldDollar:Colors.grey, ),
                          */
                        ],
                      ),
                    Row(
                     children: [
                       Container(
                       width: 25,
                       height: 25,
                       margin: const EdgeInsets.only(left: 3,bottom: 3),
                       decoration: BoxDecoration(
                           color: Colors.blue,
                           borderRadius: BorderRadius.circular(30)
                       ),
                       child: IconButton(
                         padding: EdgeInsets.zero,
                         iconSize: 20,
                         onPressed: (){
                           print("edit action $index");
                         }, icon: const Icon( Icons.edit,color: Colors.white,size: 15, ),
                       ),
                     )],
                    ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0,),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  color: LibColors.lighGrey,
                  child: Container(
                    //height:double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top:80),
                    child:  Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 300,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide( color: Colors.blue )
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue),
                                        ),
                                        labelText: 'Detention Description',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                      ),
                                    ),
                                  ),
                                  BottomSheetSwitch(
                                    switchValue: _switchIsTaxed,
                                    valueChanged: (value) {
                                      _switchIsTaxed = value;
                                    },
                                  )
                                ],
                              ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 300,
                                child: TextFormField(
                                decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide( color: Colors.blue )
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelText: 'Value',
                                labelStyle: TextStyle(color: Colors.grey),
                                floatingLabelBehavior: FloatingLabelBehavior.never
                                ),
                                ),
                              ),
                              BottomSheetSwitch(
                                switchValue: _switchIsPercentage,
                                valueChanged: (value) {
                                  _switchIsPercentage = value;
                                },
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  child: const Text('Add Detention'),
                                  onPressed: () {
                                    setState(() {
                                      //detentionList.add( Detention(name: "Indemnité de représentation",value: 20, isPercentage: true, isTaxed: true,isLockedDeleting: false));
                                    });
                                    Navigator.pop(context);
                                    //print("is tex $_switchIsTaxed");
                                    //print("is tex $_switchIsPercentage");
                                  },
                                ),const SizedBox(width: 20,),
                                ElevatedButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                );
              },
            isScrollControlled: true
            );
          }
          /*setState(() {
            detentionList.add( Detention(name: "Indemnité de représentation",value: 20, isPercentage: true, isTaxed: true));
          });*/
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add,color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



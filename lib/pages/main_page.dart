import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ir_simulation/cubit/app_cubits.dart';
import 'package:ir_simulation/misc/lib_colors.dart';
import 'package:ir_simulation/models/attribute.dart';
import 'package:ir_simulation/models/simulation_ir.dart';
import 'package:ir_simulation/pages/components/ir_form.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  var   _switchIsPercentage ;
  final detentionDescTextBox = TextEditingController();
  final detentionValueTextBox = TextEditingController();

  var attributeListKeys = SimulationIr.attributeList.keys.toList();

  final _form = GlobalKey<FormState>();

  Future<void> logout() async{

    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();

  }

  void _updateAttribute(Attribute attr,String keyMap){
    setState(() {
      SimulationIr.attributeList[keyMap]!.value = attr.value;
      SimulationIr.attributeList[keyMap]!.name = attr.name;
    });
  }

  void _loadDetentionForUpdate(String keyMap){

    setState(() {
      if(keyMap == 'nbrKids'){
        detentionValueTextBox.text = SimulationIr.attributeList[keyMap]!.value.toStringAsFixed(0);
      }else{
        detentionValueTextBox.text = SimulationIr.attributeList[keyMap]!.value.toStringAsFixed(2);
      }
      detentionDescTextBox.text = SimulationIr.attributeList[keyMap]!.name;
      _switchIsPercentage = SimulationIr.attributeList[keyMap]!.isPercentage;
    });

  }

  void _updateSimulation(){

    setState(() {

      SimulationIr.imposables = SimulationIr.attributeList['baseSalary']!.value + SimulationIr.attributeList['indemFonction']!.value;
      SimulationIr.brute = SimulationIr.imposables + SimulationIr.attributeList['indemTransport']!.value + SimulationIr.attributeList['indemPanier']!.value;

      if( SimulationIr.imposables * 12 > 78000 ){
        SimulationIr.attributeList['fraisProfessionnels']!.value = 25;
      }else{
        SimulationIr.attributeList['fraisProfessionnels']!.value = 35;
      }

      double amountvProFees = 0;

      if( SimulationIr.attributeList['fraisProfessionnels']!.value == 25 ){

        if( (SimulationIr.attributeList['fraisProfessionnels']!.value/100)*SimulationIr.imposables >= 35000/12 ){
          amountvProFees = 35000/12;
        }else{
          amountvProFees = (SimulationIr.attributeList['fraisProfessionnels']!.value/100)*SimulationIr.imposables;
        }

      }else{

        if( (SimulationIr.attributeList['fraisProfessionnels']!.value/100)*SimulationIr.imposables >= 30000/12 ){
          amountvProFees = 30000/12;
        }else{
          amountvProFees = (SimulationIr.attributeList['fraisProfessionnels']!.value/100)*SimulationIr.imposables;
        }

      }

      double adjustedAmountForCnss = 0;
      if( SimulationIr.imposables >= 6000 ){
        adjustedAmountForCnss = 6000;
      }else{
        adjustedAmountForCnss = SimulationIr.imposables;
      }

      SimulationIr.sNI = SimulationIr.imposables - ( adjustedAmountForCnss * (SimulationIr.attributeList['retenuesCNSS']!.value/100) + (SimulationIr.imposables * (SimulationIr.attributeList['retenuesAMO']!.value/100)) + (SimulationIr.imposables * (SimulationIr.attributeList['retenuesMutuelle']!.value/100)) + SimulationIr.imposables * (SimulationIr.attributeList['cimr']!.value/100) + amountvProFees);

      double TauxImpot = 0;
      double Deduction = 0;

      if( SimulationIr.sNI >= 0 && SimulationIr.sNI < 2501 )
      {
        TauxImpot = 0;
        Deduction = 0;
      }else if( SimulationIr.sNI >= 2501 && SimulationIr.sNI < 4167 ){
        TauxImpot = 10;
        Deduction = 250;
      }else if( SimulationIr.sNI >= 4167 && SimulationIr.sNI < 5001 ){
        TauxImpot = 20;
        Deduction = 666.67;
      }else if( SimulationIr.sNI >= 5001 && SimulationIr.sNI < 6667 ){
        TauxImpot = 30;
        Deduction = 1166.67;
      }
      else if( SimulationIr.sNI >= 6667 && SimulationIr.sNI < 15001 ){
        TauxImpot = 34;
        Deduction = 1433.33;
      }
      else if( SimulationIr.sNI >= 15001 ){
        TauxImpot = 38;
        Deduction = 2033.33;
      }

      SimulationIr.IRBrute =  SimulationIr.sNI * (TauxImpot/100) - Deduction;
      SimulationIr.IRNet = 0;
      if( SimulationIr.IRBrute > 0 ) {
        SimulationIr.IRNet =  SimulationIr.IRBrute-(30*SimulationIr.attributeList['nbrKids']!.value);
      }

      SimulationIr.netSalary = SimulationIr.brute - ( ( adjustedAmountForCnss * (SimulationIr.attributeList['retenuesCNSS']!.value/100) + (SimulationIr.imposables * (SimulationIr.attributeList['retenuesAMO']!.value/100)) + (SimulationIr.imposables * (SimulationIr.attributeList['retenuesMutuelle']!.value/100))) + SimulationIr.IRNet);

    });

  }

   showModel({required String method,String? keyMap}){
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  color: LibColors.lighGrey,
                  child: Container(
                    margin: const EdgeInsets.only(top:80),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:  IrForm(form: _form,detentionDescTextBox:detentionDescTextBox,detentionValueTextBox: detentionValueTextBox,switchIsPercentage: _switchIsPercentage,updateSimulation: _updateSimulation,keyMap: keyMap,loadDetentionForUpdate: _loadDetentionForUpdate,showDialog: _showMyDialog,updateAttribute: _updateAttribute,),
                  ),
                );

              });
        },
        isScrollControlled: true
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Results'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Eléments imposables ${SimulationIr.imposables.toStringAsFixed(2)}"),
                Text("Salaire Brut ${SimulationIr.brute.toStringAsFixed(2)}"),
                Text("Salaire net imposable (SNI) ${SimulationIr.sNI.toStringAsFixed(2)}"),
                Text("IR Brute ${SimulationIr.IRBrute.toStringAsFixed(2)}"),
                Text("IR net ${SimulationIr.IRNet.toStringAsFixed(2)}"),
                Text("Net Salary ${SimulationIr.netSalary.toStringAsFixed(2)}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okey'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
              logout();
              globals.sharedPreferences!.setString('email', '');
              BlocProvider.of<AppCubits>(context).goToLogin();
              //print("Log out");
            },
          )
        ],
        title:  Text("Bonjour ${globals.sharedPreferences!.getString('email')}",style: TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: LibColors.lighGrey,
        child: Column(
          children: [
            Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20,right: 10,left: 10,bottom: 80),
                  children:
                  List.generate((SimulationIr.attributeList.length), (index){
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
                                  Text("${SimulationIr.attributeList[attributeListKeys[index]]?.name} : "),
                                  index == 0? Text("${SimulationIr.attributeList[attributeListKeys[index]]?.value.toStringAsFixed(0)}"):
                                  SimulationIr.attributeList[attributeListKeys[index]]?.isPercentage == false?
                                  Text("${SimulationIr.attributeList[attributeListKeys[index]]?.value.toStringAsFixed(2)} DH"):
                                  Text("${SimulationIr.attributeList[attributeListKeys[index]]?.value.toStringAsFixed(2)} %"),
                                ],
                              ),
                              Row(
                                children: [
                                  SimulationIr.attributeList[attributeListKeys[index]]?.isLockedEditing == false? Container(
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
                                        showModel(method: 'update',keyMap: attributeListKeys[index]);
                                        print("edit action $index");
                                      }, icon: const Icon( Icons.edit,color: Colors.white,size: 15, ),
                                    ),
                                  ):Container()],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
            ),
            /*Container(
              margin: EdgeInsets.only(bottom: 80),
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 25),
                width: double.maxFinite,
                child: Column(
                  children: [
                    Text("Eléments imposables ${SimulationIr.imposables.toStringAsFixed(2)}"),
                    Text("Salaire Brut ${SimulationIr.brute.toStringAsFixed(2)}"),
                    Text("Salaire net imposable (SNI) ${SimulationIr.sNI.toStringAsFixed(2)}"),
                    Text("IR Brute ${SimulationIr.IRBrute.toStringAsFixed(2)}"),
                    Text("IR net ${SimulationIr.IRNet.toStringAsFixed(2)}"),
                    Text("Net Salary ${SimulationIr.netSalary.toStringAsFixed(2)}"),
                  ],
                )),*/
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


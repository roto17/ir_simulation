import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';
import 'package:ir_simulation/cubit/app_cubits.dart';

import '../../misc/lib_colors.dart';
import '../../models/attribute.dart';
import '../../models/simulation_ir.dart';
import '../components/ir_form.dart';

class MainPageSub extends StatefulWidget {
  const MainPageSub({super.key});

  @override
  State<MainPageSub> createState() => _MainPageSubState();
}

class _MainPageSubState extends State<MainPageSub> {


  var   _switchIsPercentage ;
  final detentionDescTextBox = TextEditingController();
  final detentionValueTextBox = TextEditingController();
  var listAttribute;
  var attributeListKeys;

  final _form = GlobalKey<FormState>();

  void _updateAttribute(Attribute attr,String keyMap){
    setState(() {
      listAttribute[keyMap]!.value = attr.value;
      listAttribute[keyMap]!.name = attr.name;
    });
  }

  void _loadDetentionForUpdate(String keyMap){

    setState(() {
      if(keyMap == 'nbrKids'){
        detentionValueTextBox.text = listAttribute[keyMap]!.value.toStringAsFixed(0);
      }else{
        detentionValueTextBox.text = listAttribute[keyMap]!.value.toStringAsFixed(2);
      }
      detentionDescTextBox.text = listAttribute[keyMap]!.name;
      _switchIsPercentage = listAttribute[keyMap]!.isPercentage;
    });

  }

  void _updateSimulation(){

    setState(() {

      SimulationIr.imposables = listAttribute['baseSalary']!.value + listAttribute['indemFonction']!.value;
      SimulationIr.brute = SimulationIr.imposables + listAttribute['indemTransport']!.value + listAttribute['indemPanier']!.value;

      if( SimulationIr.imposables * 12 > 78000 ){
        listAttribute['fraisProfessionnels']!.value = 25;
      }else{
        listAttribute['fraisProfessionnels']!.value = 35;
      }

      double amountvProFees = 0;

      if( listAttribute['fraisProfessionnels']!.value == 25 ){

        if( (listAttribute['fraisProfessionnels']!.value/100)*SimulationIr.imposables >= 35000/12 ){
          amountvProFees = 35000/12;
        }else{
          amountvProFees = (listAttribute['fraisProfessionnels']!.value/100)*SimulationIr.imposables;
        }

      }else{

        if( (listAttribute['fraisProfessionnels']!.value/100)*SimulationIr.imposables >= 30000/12 ){
          amountvProFees = 30000/12;
        }else{
          amountvProFees = (listAttribute['fraisProfessionnels']!.value/100)*SimulationIr.imposables;
        }

      }

      double adjustedAmountForCnss = 0;
      if( SimulationIr.imposables >= 6000 ){
        adjustedAmountForCnss = 6000;
      }else{
        adjustedAmountForCnss = SimulationIr.imposables;
      }

      SimulationIr.sNI = SimulationIr.imposables - ( adjustedAmountForCnss * (listAttribute['retenuesCNSS']!.value/100) + (SimulationIr.imposables * (listAttribute['retenuesAMO']!.value/100)) + (SimulationIr.imposables * (listAttribute['retenuesMutuelle']!.value/100)) + SimulationIr.imposables * (listAttribute['cimr']!.value/100) + amountvProFees);

      double tauxImpot = 0;
      double deduction = 0;

      if( SimulationIr.sNI >= 0 && SimulationIr.sNI < 2501 )
      {
        tauxImpot = 0;
        deduction = 0;
      }else if( SimulationIr.sNI >= 2501 && SimulationIr.sNI < 4167 ){
        tauxImpot = 10;
        deduction = 250;
      }else if( SimulationIr.sNI >= 4167 && SimulationIr.sNI < 5001 ){
        tauxImpot = 20;
        deduction = 666.67;
      }else if( SimulationIr.sNI >= 5001 && SimulationIr.sNI < 6667 ){
        tauxImpot = 30;
        deduction = 1166.67;
      }
      else if( SimulationIr.sNI >= 6667 && SimulationIr.sNI < 15001 ){
        tauxImpot = 34;
        deduction = 1433.33;
      }
      else if( SimulationIr.sNI >= 15001 ){
        tauxImpot = 38;
        deduction = 2033.33;
      }

      SimulationIr.IRBrute =  SimulationIr.sNI * (tauxImpot/100) - deduction;
      SimulationIr.IRNet = 0;
      if( SimulationIr.IRBrute > 0 ) {
        SimulationIr.IRNet =  SimulationIr.IRBrute-(30*listAttribute['nbrKids']!.value);
      }

      SimulationIr.netSalary = SimulationIr.brute - ( ( adjustedAmountForCnss * (listAttribute['retenuesCNSS']!.value/100) + (SimulationIr.imposables * (listAttribute['retenuesAMO']!.value/100)) + (SimulationIr.imposables * (listAttribute['retenuesMutuelle']!.value/100))) + SimulationIr.IRNet);

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
                    height: 550,
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
          title: const Text('Résultat'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Eléments imposables : ${SimulationIr.imposables.toStringAsFixed(2)}"),
                Text("Salaire Brut : ${SimulationIr.brute.toStringAsFixed(2)}"),
                Text("Salaire net imposable (SNI) : ${SimulationIr.sNI.toStringAsFixed(2)}"),
                Text("IR Brute : ${SimulationIr.IRBrute.toStringAsFixed(2)}"),
                Text("IR net : ${SimulationIr.IRNet.toStringAsFixed(2)}"),
                Text("Salaire Net : ${SimulationIr.netSalary.toStringAsFixed(2)}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
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
    String myLocale = Localizations.localeOf(context).toString();
    return BlocBuilder<AppCubits,CubitStates>(
      builder: (context,state){
        if (state is MainState){
          listAttribute = state.attributeList;
          attributeListKeys = listAttribute.keys.toList();
          return Container(
            color: LibColors.lighGrey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20,right: 10,left: 10,bottom: 80),
                    children:
                    List.generate((listAttribute.length), (index){
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

                                    Text("${ myLocale == 'fr' ? listAttribute[attributeListKeys[index]]?.name:listAttribute[attributeListKeys[index]]?.nameEN} : "),
                                    index == 0? Text("${listAttribute[attributeListKeys[index]]?.value.toStringAsFixed(0)}"):
                                    listAttribute[attributeListKeys[index]]?.isPercentage == false?
                                    Text("${listAttribute[attributeListKeys[index]]?.value.toStringAsFixed(2)} DH"):
                                    Text("${listAttribute[attributeListKeys[index]]?.value.toStringAsFixed(2)} %"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    listAttribute[attributeListKeys[index]]?.isLockedEditing == false? Container(
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
                                        }, icon: const Icon( Icons.edit,color: Colors.white,size: 15, ),
                                      ),
                                    ):
                                    Container(
                                      width: 25,
                                      height: 25,
                                      margin: const EdgeInsets.only(left: 3,bottom: 3),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: const IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                        onPressed: null, icon:  Icon( Icons.edit,color: Colors.white,size: 15, ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }else{
          return Container();
        }

      },
    );
  }
}

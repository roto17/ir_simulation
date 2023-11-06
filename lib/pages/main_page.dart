
import 'package:flutter/material.dart';
import 'package:ir_simulation/misc/lib_colors.dart';
import 'package:ir_simulation/models/detention.dart';
import 'package:ir_simulation/models/simulation_ir.dart';
import 'package:ir_simulation/pages/components/ir_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  final bool _switchIsPercentage = true;
  final detentionDescTextBox = TextEditingController();
  final detentionValueTextBox = TextEditingController();

  final _form = GlobalKey<FormState>();

  void _addDetention(Detention dt){
    setState(() {
      SimulationIr.detentionList.add(dt);
    });
  }

  void _loadDetentionForUpdate(int pos){

    setState(() {
      detentionDescTextBox.text = SimulationIr.indemniteLit.elementAt(pos).name;
      detentionValueTextBox.text = SimulationIr.indemniteLit.elementAt(pos).value.toStringAsFixed(0);
    });

  }

  void _updateSimulation(){

    setState(() {
      SimulationIr.nbrKids = SimulationIr.indemniteLit.elementAt(0).value;
      SimulationIr.Taxable = SimulationIr.indemniteLit.elementAt(1).value + SimulationIr.indemniteLit.elementAt(4).value;
      SimulationIr.grossSalary = SimulationIr.Taxable + SimulationIr.indemniteLit.elementAt(2).value + SimulationIr.indemniteLit.elementAt(3).value;

      if( SimulationIr.Taxable * 12 > 78000 ){
        SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value = 25;
      }else{
        SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value = 35;
      }

      var amountv;
      if( SimulationIr.Taxable >= 6000 ){
        amountv = 6000;
      }else{
        amountv = SimulationIr.Taxable;
      }

      var amountvProFees;

      if( SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value == 25 ){

        if( (SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value/100)*SimulationIr.Taxable >= 35000/12 ){
          amountvProFees = 35000/12;
        }else{
          amountvProFees = (SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value/100)*SimulationIr.Taxable;
        }

      }else{

        if( (SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value/100)*SimulationIr.Taxable >= 30000/12 ){
          amountvProFees = 30000/12;
        }else{
          amountvProFees = (SimulationIr.detentionList.elementAt(SimulationIr.detentionList.length-1).value/100)*SimulationIr.Taxable;
        }

      }


      SimulationIr.sNI = SimulationIr.Taxable - ( amountv * (SimulationIr.detentionList.elementAt(0).value/100) + (SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(1).value/100)) + (SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(2).value/100)) + amountvProFees);


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
        SimulationIr.IRNet =  SimulationIr.IRBrute-(30*SimulationIr.nbrKids);
      }


      double totalCalc = 0;
      for (var i = 1; i < SimulationIr.detentionList.length-1; i++) {
        // TO DO
        totalCalc = totalCalc + (SimulationIr.detentionList.elementAt(i).value/100)*SimulationIr.Taxable;
      }
      print(totalCalc);
      print((SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(1).value/100)) + (SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(2).value/100)));


      SimulationIr.netSalary = SimulationIr.grossSalary - ( ( amountv * (SimulationIr.detentionList.elementAt(0).value/100) + (SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(1).value/100)) + (SimulationIr.Taxable * (SimulationIr.detentionList.elementAt(2).value/100))) + SimulationIr.IRNet);

    });

  }


   showModel({required String method,int? pos}){
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  color: LibColors.lighGrey,
                  child: Container(
                    //height:double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top:80),
                    child:  IrForm(form: _form,detentionDescTextBox:detentionDescTextBox,detentionValueTextBox: detentionValueTextBox,switchIsPercentage: _switchIsPercentage,addDetention: _addDetention,updateSimulation: _updateSimulation,pos: pos,loadDetentionForUpdate: _loadDetentionForUpdate,),
                  ),
                );

              });
        },
        isScrollControlled: true
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
              print("Log out");
            },
          )
        ],
        title: const Text('IR Simulation',style: TextStyle(color: Colors.white),),
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
                  List.generate((SimulationIr.indemniteLit.length+SimulationIr.detentionList.length), (index){
                    return Column(
                      children: [
                        index<SimulationIr.indemniteLit.length?Container(
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
                                  Text("${SimulationIr.indemniteLit.elementAt(index).name} : "),
                                  index > 0?
                                  Text("${SimulationIr.indemniteLit.elementAt(index).value.toStringAsFixed(2)} DH"):
                                  Text(SimulationIr.indemniteLit.elementAt(index).value.toStringAsFixed(0)),
                                  /*Text("${indemniteList[index].name} : ",style: const TextStyle(color: Colors.black54,fontSize: 13)),
                                      Text("${indemniteList[index].value.toStringAsFixed(2)} DH",style: const TextStyle(color: Colors.black54,fontSize: 13,fontWeight: FontWeight.bold))
                                      Icon( FontAwesomeIcons.circleDollarToSlot,color: detentionList[index].isTaxed==true?LibColors.lightGoldDollar:Colors.grey, ),
                                      */
                                ],
                              ),
                              Row(
                                children: [
                                  index > 0?
                                  Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 3,bottom: 3),
                                    child:  Icon( FontAwesomeIcons.circleDollarToSlot,color: SimulationIr.indemniteLit.elementAt(index).isTaxed==true?LibColors.lightGoldDollar:Colors.grey, ),
                                  ):Container(),
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
                                        showModel(method: 'update',pos: index);
                                        print("edit action $index");
                                      }, icon: const Icon( Icons.edit,color: Colors.white,size: 15, ),
                                    ),
                                  )],
                              ),
                            ],
                          ),
                        )
                        :
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
                                  Text("${SimulationIr.detentionList.elementAt(index-SimulationIr.indemniteLit.length).name} : "),
                                  Text("${SimulationIr.detentionList.elementAt(index-SimulationIr.indemniteLit.length).value.toStringAsFixed(2)} ${SimulationIr.detentionList.elementAt(index-SimulationIr.indemniteLit.length).isPercentage==true?'%':'DH'}"),
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
                                        print("edit actions $index");
                                      }, icon: const Icon( Icons.edit,color: Colors.white,size: 15, ),
                                    ),
                                  ),
                                  SimulationIr.detentionList.elementAt(index-SimulationIr.indemniteLit.length).isLockedDeleting==false?Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    margin: const EdgeInsets.only(left: 3,bottom: 3),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                      onPressed: (){

                                        setState(() {
                                          SimulationIr.detentionList.removeAt(index-SimulationIr.indemniteLit.length);
                                        });

                                        print("delete action $index");

                                      }, icon: const Icon( Icons.delete,color: Colors.white,size: 15, ),
                                    ),
                                  ):Container(),
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
            Container(
              margin: EdgeInsets.only(bottom: 80),
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 25),
                width: double.maxFinite,
                child: Column(
                  children: [
                    Text("Eléments imposables ${SimulationIr.Taxable.toStringAsFixed(2)}"),
                    Text("Salaire Brut ${SimulationIr.grossSalary.toStringAsFixed(2)}"),
                    Text("Salaire net imposable (SNI) ${SimulationIr.sNI.toStringAsFixed(2)}"),
                    Text("IR Brute ${SimulationIr.IRBrute.toStringAsFixed(2)}"),
                    Text("IR net ${SimulationIr.IRNet.toStringAsFixed(2)}"),
                    Text("Net Salary ${SimulationIr.netSalary.toStringAsFixed(2)}"),
                  ],
                )),
          ],
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
            showModel(method: 'add');
          }
          /*setState(()
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


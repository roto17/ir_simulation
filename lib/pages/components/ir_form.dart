import 'package:flutter/material.dart';
import 'package:ir_simulation/models/simulation_ir.dart';

//ignore: must_be_immutable
class IrForm extends StatefulWidget {

  final form;
  final showDialog;
  final updateAttribute;
  final TextEditingController detentionDescTextBox ;
  final TextEditingController detentionValueTextBox ;
  late bool? switchIsPercentage;
  final updateSimulation;
  final loadDetentionForUpdate;
  late int? pos;
  late String? keyMap;

  IrForm({required this.form,required this.detentionDescTextBox,required this.detentionValueTextBox,required this.switchIsPercentage,required this.updateSimulation,required this.keyMap,this.loadDetentionForUpdate,this.showDialog,this.updateAttribute});

  @override
  State<IrForm> createState() => _IrFormState();
}

class _IrFormState extends State<IrForm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.loadDetentionForUpdate(widget.keyMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.form,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 85,
                width: 300,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (_)  {
                    setState(() {});
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Une valeur requise';
                    }
                    return null;
                  },
                  controller: widget.detentionDescTextBox,
                  decoration:  const InputDecoration(
                    border:   UnderlineInputBorder(
                        borderSide: BorderSide( color: Colors.blue )
                    ),
                    focusedBorder:   UnderlineInputBorder(
                      borderSide: BorderSide( color: Colors.blue ),
                    ),
                    labelText: 'Detention Description',
                    labelStyle:   TextStyle( color: Colors.grey ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 85,
                width: 300,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value){

                    var textUpdatedComma = value!.replaceAll(',', '.');

                    if(value.contains('.') && widget.keyMap == 'nbrKids'){
                      return 'Invalide comme nombre des enfants';
                    }



                    if (value.isEmpty){
                      return 'Can\'t be empty';
                    }

                    if ( RegExp(r'^(\d*\.)?\d+$').hasMatch(textUpdatedComma) == false ){
                      return 'Entrer un nombre valide';
                    }

                    if(widget.keyMap == 'baseSalary' && double.parse(textUpdatedComma) <= 0 ){
                      return 'Salaire doit être plus que 0 dh';
                    }

                    if (widget.switchIsPercentage == true && double.parse(textUpdatedComma)/100 > 1) {
                      return 'Pourcentage est entre 0 et 100';
                    }

                    return null;

                  },
                  onChanged: (_) => setState(() {}),
                  controller: widget.detentionValueTextBox,
                  decoration:  InputDecoration(
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide( color: Colors.blue )
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: widget.keyMap =='nbrKids'?'Nombre':widget.switchIsPercentage==true?'Value in %':'Value in MAD',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10,left: 30),
            child: Row(

              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text Color (Foreground color)
                  ),
                  child: const Text('Enregistrer'),
                  onPressed: () {
                    if( widget.form.currentState!.validate() ){

                      var attributeToUpdate = SimulationIr.attributeList[ widget.keyMap ];
                      attributeToUpdate!.name = widget.detentionDescTextBox.text;
                      attributeToUpdate.value = double.parse(widget.detentionValueTextBox.text);
                      widget.updateAttribute(attributeToUpdate,widget.keyMap);
                      widget.updateSimulation();
                      Navigator.pop(context);
                      widget.showDialog();

                    }
                  },
                ),const SizedBox(width: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                  ),
                  child: const Text('X'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

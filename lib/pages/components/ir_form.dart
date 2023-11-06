import 'package:ir_simulation/models/simulation_ir.dart';

import 'bottom_sheet_switch.dart';
import '../../models/detention.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class IrForm extends StatefulWidget {

  final form;
  final addDetention;
  final detentionDescTextBox ;
  final detentionValueTextBox ;
  late bool? switchIsPercentage;
  final updateSimulation;
  final loadDetentionForUpdate;
  late int? pos;

  IrForm({required this.form,required this.detentionDescTextBox,required this.detentionValueTextBox,required this.switchIsPercentage,required this.addDetention,required this.updateSimulation,this.pos,required this.loadDetentionForUpdate});

  @override
  State<IrForm> createState() => _IrFormState();
}

class _IrFormState extends State<IrForm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.loadDetentionForUpdate(widget.pos);
    });
  }

  @override
  Widget build(BuildContext context) {





    return Form(
      key: widget.form,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 85,
                width: 300,
                child: TextFormField(
                  onChanged: (_)  {
                    setState(() {});
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Can\'t be empty';
                    }
                    return null;
                  },
                  controller: widget.detentionDescTextBox,
                  decoration:  const InputDecoration(
                    //errorText: _errorText(txtEditingController: detentionDescTextBox,isNumber: false),
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
              /*BottomSheetSwitch(
                                        switchValue: _switchIsTaxed,
                                        valueChanged: (value) {

                                          setState(() {
                                            _switchIsTaxed = value;
                                          });

                                        },
                                      )*/
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 85,
                width: 300,
                child: TextFormField(
                  validator: (value){

                    var textUpdatedComma = value!.replaceAll(',', '.');

                    if (value.isEmpty){
                      return 'Can\'t be empty';
                    }

                    if ( RegExp(r'^(\d*\.)?\d+$').hasMatch(textUpdatedComma) == false ){
                      return 'Enter a Valid number';
                    }

                    if (widget.switchIsPercentage == true && double.parse(textUpdatedComma)/100 > 1) {
                      return 'Error Percentage should be between 0 and 100';
                    }

                    return null;

                  },
                  onChanged: (_) => setState(() {}),
                  controller: widget.detentionValueTextBox,
                  decoration:  InputDecoration(
                    //errorText: _errorText(txtEditingController: detentionValueTextBox,isPercentage: widget.switchIsPercentage,isNumber: true),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide( color: Colors.blue )
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: widget.switchIsPercentage==true?'Value in %':'Value in MAD',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never
                  ),
                ),
              ),
              BottomSheetSwitch(
                switchValue: widget.switchIsPercentage!,
                valueChanged: (value) {
                  setState(() {
                    widget.switchIsPercentage = value;
                  });
                },
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                ElevatedButton(
                  child: const Text('Add Detentions'),
                  onPressed: () {
                    if( widget.form.currentState!.validate() ){

                      //widget.addDetention(Detention(name: widget.detentionDescTextBox.text, value: double.parse(widget.detentionValueTextBox.text.replaceAll(',', '.')), isPercentage: widget.switchIsPercentage!, isTaxed: false,isLockedDeleting: false));
                      widget.updateSimulation();
                      Navigator.pop(context);

                    }
                  },
                ),const SizedBox(width: 20,),
                ElevatedButton(
                  child: const Text('Close'),
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

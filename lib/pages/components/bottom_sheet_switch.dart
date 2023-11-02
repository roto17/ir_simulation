import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetSwitch extends StatefulWidget {
  final bool switchValue;
  final ValueChanged valueChanged;

  BottomSheetSwitch({super.key, required this.switchValue, required this.valueChanged});

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  late bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
        scale: 0.6,
        child: CupertinoSwitch(
            value: _switchValue,
            onChanged: (bool value) {
              setState(() {
                _switchValue = value;
                widget.valueChanged(value);
              });
            }),
      ),
    );
  }
}
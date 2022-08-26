import 'package:flutter/material.dart';
import 'package:kryptonia/utils/pass_code_utils.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class SetPassCode extends StatefulWidget {
  const SetPassCode({Key? key}) : super(key: key);

  @override
  _SetPassCodeState createState() => _SetPassCodeState();
}

class _SetPassCodeState extends State<SetPassCode> {
  int index = 0;
  String currentVal = "";
  TextEditingController _rePassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrnsText(title: "Enter New Passcode"),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: PassCodeUtils(
                    obscure: true,
                    onChanged: (String value) {
                      setState(() {
                        currentVal = value;
                      });
                    },
                    onCompleted: (String v) {
                      setState(() {
                        index++;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: 400,
            child: PassCodeUtils(
              obscure: true,
              textEditingController: _rePassCtrl,
              onCompleted: (String v) {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

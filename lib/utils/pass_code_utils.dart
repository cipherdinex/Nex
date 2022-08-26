import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PassCodeUtils extends StatefulWidget {
  final bool? obscure;
  final TextEditingController? textEditingController;
  final Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool isLockScreen;
  PassCodeUtils({
    required this.obscure,
    this.textEditingController,
    required this.onCompleted,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.isLockScreen = false,
  });

  @override
  _PassCodeUtilsState createState() => _PassCodeUtilsState();
}

class _PassCodeUtilsState extends State<PassCodeUtils> {
  var onTapRecognizer;

  final _errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    super.initState();
  }

  @override
  void dispose() {
    _errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    return ListView(
      children: <Widget>[
        Form(
          key: formKey,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: PinCodeTextField(
                autoDismissKeyboard: false,
                focusNode: widget.focusNode,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: widget.obscure ?? false,
                obscuringCharacter: '•',
                animationType: AnimationType.fade,
                validator: widget.validator,
                pinTheme: PinTheme(
                  selectedFillColor: transparent,
                  inactiveFillColor: transparent,
                  inactiveColor: widget.isLockScreen
                      ? white
                      : Theme.of(context).textTheme.bodyText1!.color,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: hasError ? amber : transparent,
                ),
                cursorColor: Theme.of(context).textTheme.bodyText1!.color,
                animationDuration: Duration(milliseconds: 300),
                textStyle: TextStyle(
                  fontSize: 20,
                  height: 1.6,
                  color: widget.isLockScreen
                      ? white
                      : Theme.of(context).textTheme.bodyText1!.color,
                ),
                backgroundColor: transparent,
                enableActiveFill: true,
                errorAnimationController: _errorController,
                controller: widget.textEditingController,
                keyboardType: TextInputType.number,
                onCompleted: widget.onCompleted,
                onChanged: widget.onChanged!,
                beforeTextPaste: (text) {
                  return true;
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            hasError
                ? _allBackEnds.translation(
                    context, "Please fill up all the cells properly")
                : "",
            style: TextStyle(
                color: red, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

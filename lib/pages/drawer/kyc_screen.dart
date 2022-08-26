import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  _KYCScreenState createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();
  String _selectedDate = "1-1-1980";
  String _idType = TYPE_ID[0];
  int _index = 0;
  final ImagePicker _picker = ImagePicker();
  XFile? _finisedImageFile;
  File? _imageFile;

  GlobalKey<FormState> _verifyKey1 = GlobalKey();
  GlobalKey<FormState> _verifyKey2 = GlobalKey();
  String? _fullName, _address, _city, _state, _idNo;

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return KHeader(
      isLoading: _loading,
      hasWillPop: true,
      title: ['Identity Verification'],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IndexedStack(
          index: _index,
          children: [
            stackOne(),
            stackTwo(med),
          ],
        ),
      ),
    );
  }

  Widget stackOne() {
    return Form(
      key: _verifyKey1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrnsText(title: 'Full Name'),
          CustTextField(
            hintText: 'John Doe',
            validator: emptyValidate,
            onChanged: (String? val) {
              setState(() {
                _fullName = val;
              });
            },
          ),
          SizedBox(height: 20),
          TrnsText(
            title: '{Arg} Address',
            args: {'Arg': ''},
            extra2: ' ',
          ),
          CustTextField(
            hintText: '123 Silicon Valley',
            validator: emptyValidate,
            onChanged: (String? val) {
              setState(() {
                _address = val;
              });
            },
          ),
          SizedBox(height: 20),
          TrnsText(title: 'City'),
          CustTextField(
            hintText: 'San Francisco',
            validator: emptyValidate,
            onChanged: (String? val) {
              setState(() {
                _city = val;
              });
            },
          ),
          SizedBox(height: 20),
          TrnsText(title: 'State'),
          CustTextField(
            hintText: 'California',
            validator: emptyValidate,
            onChanged: (String? val) {
              setState(() {
                _state = val;
              });
            },
          ),
          SizedBox(height: 20),
          TrnsText(title: "Date Of Birth"),
          InkWell(
            onTap: () async => datePicker(context),
            child: CustTextField(
              enabled: false,
              hintText: _selectedDate,
            ),
          ),
          SizedBox(height: 20),
          CustButton(
            onTap: () {
              if (_verifyKey1.currentState!.validate()) {
                _verifyKey1.currentState!.save();
                setState(() {
                  _index++;
                });
              }
            },
            title: 'Next',
          )
        ],
      ),
    );
  }

  String? emptyValidate(String? value) {
    return _allBackEnds.validateEmpty(value, "Field", context);
  }

  Widget stackTwo(med) {
    return Form(
      key: _verifyKey2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TrnsText(title: "Document Type:"),
              InkWell(
                child: Text(
                  _idType.capitalize()!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => _allBackEnds.showPicker(
                  context,
                  children: TYPE_ID,
                  onChanged: (String? val) {
                    setState(() {
                      _idType = val!;
                    });
                    Navigator.pop(context);
                  },
                  onSelectedItemChanged: (int? val) {
                    setState(() {
                      _idType = TYPE_ID[val!];
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TrnsText(title: 'Document No.'),
          CustTextField(
            hintText: '1234567890',
            validator: emptyValidate,
            onChanged: (String? val) {
              setState(() {
                _idNo = val;
              });
            },
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: _takePicture,
            child: CustContainer(
              child: _finisedImageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/id.png'),
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustButton(
                width: med.width * 0.4,
                onTap: () {
                  setState(() {
                    _index--;
                  });
                },
                title: 'Back',
              ),
              CustButton(
                width: med.width * 0.4,
                onTap: () async {
                  if (_verifyKey2.currentState!.validate()) {
                    if (_finisedImageFile != null) {
                      _verifyKey2.currentState!.save();
                      //... code

                      await verifyFxn();
                    } else {
                      _allBackEnds.showSnacky(
                          "Scan a Document", false, context);
                    }
                  }
                },
                color: green,
                title: 'Verify',
              ),
            ],
          )
        ],
      ),
    );
  }

  datePicker(context) async {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (dt) {
                  String date = "${dt.day}-${dt.month}-${dt.year}";
                  setState(() {
                    _selectedDate = date;
                  });
                },
                initialDateTime: DateTime(1980),
                minimumYear: 1930,
                maximumYear: 2003,
              ),
            );
          });
    } else {
      DateTime? dt = await showDatePicker(
        context: context,
        initialDate: DateTime(1980),
        firstDate: DateTime(1930),
        lastDate: DateTime(2003),
        initialDatePickerMode: DatePickerMode.year,
      );

      String date = "${dt!.day}-${dt.month}-${dt.year}";
      setState(() {
        _selectedDate = date;
      });
    }
  }

//? Pick Image
  Future<XFile?> _takePicture() async {
    _finisedImageFile = await _picker.pickImage(source: ImageSource.camera);
    _imageFile =
        _finisedImageFile != null ? File(_finisedImageFile!.path) : null;

    setState(() {});

    return _finisedImageFile;
  }

  //? Upload

  verifyFxn() async {
    setState(() {
      _loading = true;
    });
    try {
      Map<String, String?> data = {
        NAME: _fullName,
        ADDRESS: _address,
        CITY: _city,
        STATE: _state,
        DOB: _selectedDate,
        ID_TYPE: _idType,
        ID_NO: _idNo,
        IMAGE: _finisedImageFile!.path,
      };
      await _allBackEnds.kycVerification(data, context).then((value) {
        if (value) {
          _allBackEnds.showPopUp(
            context,
            Text(
              "You informations have been successfully sent, and is being reviewed.",
            ),
            [
              CupertinoButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/bottom-nav/');
                },
              ),
            ],
            [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/bottom-nav/');
                },
              ),
            ],
          );
        }
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
    });
  }
}

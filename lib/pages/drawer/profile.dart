import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';

import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_country.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/trns_m_text.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static AllBackEnds _allBackEnds = AllBackEnds();

  final ImagePicker _picker = ImagePicker();
  File? _finisedImageFile;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  String uid = _allBackEnds.getUser(UID);

  String? _fName, _lName, _phone;
  String? _accName, _accNum, _bankName, _bankSortCode, _bankCountry;
  String? _paypalEmail;
  String? _payoneerBenficiaryName,
      _payoneerAccNum,
      _payoneerBankName,
      _payoneerRoutingBankSortCode,
      _payoneerAccType,
      _payoneerBankCountry;

//!Initals

//? PROFILE

  String fName = _allBackEnds.getUser(FIRST_NAME);
  String lName = _allBackEnds.getUser(LAST_NAME);
  String? profilePic = _allBackEnds.getUser(PROFILEPIC);
  String email = _allBackEnds.getUser(EMAIL);
  String phone = _allBackEnds.getUser(PHONE);
  String country = _allBackEnds.getUser(COUNTRY);

//?BANK
  String? initAccName = _allBackEnds.getFinancials(ACCOUNTNAME) ?? "";
  String? initAccNum = _allBackEnds.getFinancials(ACCOUNTNUMBER) ?? "";
  String? initBankName = _allBackEnds.getFinancials(BANKNAME) ?? "";
  String? initBankSort = _allBackEnds.getFinancials(BANKSORTCODE) ?? "";
  String? initBankCountry = _allBackEnds.getFinancials(BANKCOUNTRY) ?? "";

//? PAYPAL
  String? initPaypalEmail = _allBackEnds.getFinancials(PAYPALEMAIL) ?? "";

//?PAYONEER
  String? initPayoneerBeneficiaryName =
      _allBackEnds.getFinancials(PAYONEERBENEFICIARYNAME) ?? "";
  String? initPayoneerAccNum =
      _allBackEnds.getFinancials(PAYONEERACCOUNTNUMBER) ?? "";
  String? initPayoneerBankName =
      _allBackEnds.getFinancials(PAYONEERBANKNAME) ?? "";
  String? initPayoneerRoutingBankSort =
      _allBackEnds.getFinancials(PAYONEERROUTINGBANKSORTCODE) ?? "";
  String? initPayoneerBankCountry =
      _allBackEnds.getFinancials(PAYONEERBANKCOUNTRY) ?? "";
  String? initPayoneerAccType =
      _allBackEnds.getFinancials(PAYONEERACCOUNTTYPE) ?? "";

  //
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;

    return KHeader(
      title: ["Profile"],
      body: Container(
        height: med.height,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).textTheme.bodyText1!.color,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyText1!.color,
              tabs: [
                Tab(text: _allBackEnds.translation(context, 'Personal')),
                Tab(text: _allBackEnds.translation(context, 'Financials')),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        splashColor: transparent,
                        child: _finisedImageFile != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage(_finisedImageFile!.path))
                            : profilePic != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        CachedNetworkImageProvider(profilePic!),
                                    child: _finisedImageFile == null &&
                                            profilePic == null
                                        ? Icon(
                                            Icons.add_a_photo,
                                            size: 35,
                                          )
                                        : null,
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 35,
                                    )),
                      ),
                      SizedBox(height: 40),
                      CustTextField(
                        hintTrns: true,
                        hintText: "First Name",
                        initialValue: fName.capitalize(),
                        onChanged: (String? val) {
                          setState(() {
                            _fName = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      CustTextField(
                        hintTrns: true,
                        hintText: "Last Name",
                        initialValue: lName.capitalize(),
                        onChanged: (String? val) {
                          setState(() {
                            _lName = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      CustTextField(
                        hintTrns: true,
                        hintText: "Email",
                        enabled: false,
                        initialValue: email,
                      ),
                      SizedBox(height: 10),
                      CustTextField(
                        hintTrns: true,
                        hintText: "Phone",
                        initialValue: phone,
                        onChanged: (String? val) {
                          setState(() {
                            _phone = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrnsText(title: "Country"),
                            CustCountryPicker(
                              enabled: false,
                              initialSelection: country,
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CustButton(
                        onTap: () => checkOTPUpdate(1),
                        title: "Update",
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/coins.svg",
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        ExpansionTile(
                          title: TrnsText(title: "Bank"),
                          children: [
                            CustTextField(
                              hintTrns: true,
                              hintText: "Account Name",
                              initialValue: initAccName,
                              onChanged: (String? val) {
                                setState(() {
                                  _accName = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Bank Name",
                              initialValue: initBankName,
                              onChanged: (String? val) {
                                setState(() {
                                  _bankName = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Account Number",
                              initialValue: initAccNum,
                              onChanged: (String? val) {
                                setState(() {
                                  _accNum = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Bank Sort Code",
                              initialValue: initBankSort,
                              onChanged: (String? val) {
                                setState(() {
                                  _bankSortCode = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MultiTrnsText(title: ["Bank", "Country"]),
                                  CustCountryPicker(
                                    initialSelection:
                                        initBankCountry ?? DEFAULT_COUNTRY,
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: true,
                                    onChanged: (val) {
                                      setState(() {
                                        _bankCountry = val.name;
                                      });
                                    },
                                    onInit: (code) {
                                      _bankCountry = code!.name;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            CustButton(
                              onTap: () => checkOTPUpdate(2),
                              title: "Update",
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        ExpansionTile(
                          title: TrnsText(title: "Paypal"),
                          children: [
                            CustTextField(
                                hintTrns: true,
                                mHintText: ["Paypal", "Email"],
                                initialValue: initPaypalEmail,
                                onChanged: (String? val) {
                                  setState(() {
                                    _paypalEmail = val;
                                  });
                                }),
                            SizedBox(height: 10),
                            CustButton(
                              onTap: () => checkOTPUpdate(3),
                              title: "Update",
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        ExpansionTile(
                          title: TrnsText(title: "Payoneer"),
                          children: [
                            CustTextField(
                              hintTrns: true,
                              hintText: "Beneficiary Name",
                              initialValue: initPayoneerBeneficiaryName,
                              onChanged: (String? val) {
                                setState(() {
                                  _payoneerBenficiaryName = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Bank Name",
                              initialValue: initPayoneerBankName,
                              onChanged: (String? val) {
                                setState(() {
                                  _payoneerBankName = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Account Number",
                              initialValue: initPayoneerAccNum,
                              onChanged: (String? val) {
                                setState(() {
                                  _payoneerAccNum = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Routing/Bank/Sort Code",
                              initialValue: initPayoneerRoutingBankSort,
                              onChanged: (String? val) {
                                setState(() {
                                  _payoneerRoutingBankSortCode = val;
                                });
                              },
                            ),
                            CustTextField(
                              hintTrns: true,
                              hintText: "Account Type",
                              initialValue: initPayoneerAccType,
                              onChanged: (String? val) {
                                setState(() {
                                  _payoneerAccType = val;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MultiTrnsText(title: ["Bank", "Country"]),
                                  CustCountryPicker(
                                    initialSelection: initPayoneerBankCountry ??
                                        DEFAULT_COUNTRY,
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: true,
                                    onChanged: (val) {
                                      setState(() {
                                        _payoneerBankCountry = val.name;
                                      });
                                    },
                                    onInit: (code) {
                                      _payoneerBankCountry = code!.name;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            CustButton(
                              onTap: () => checkOTPUpdate(4),
                              title: "Update",
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

//? Pick Image
  Future<File?> _pickImage() async {
    File? _imageFile;
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    _finisedImageFile = await _allBackEnds.cropImage(_imageFile);
    setState(() {});

    return _finisedImageFile;
  }

  checkOTPUpdate(int type) {
    _allBackEnds.otpCheckFxn(() {
      updateSwitch(type);
    }, context);
  }

  updateSwitch(int type) {
    switch (type) {
      case 1:
        return updateProfile();
      case 2:
        return updateBank();
      case 3:
        return updatePaypal();
      case 4:
        return updatePayoneer();
      default:
    }
  }

//? Update Profile
  updateProfile() async {
    Map<String, dynamic> data = {
      FIRST_NAME: _fName ?? fName,
      LAST_NAME: _lName ?? lName,
      PHONE: _phone ?? phone,
    };

    try {
      if (_finisedImageFile == null) {
        await _allBackEnds.sqlupdateProfile(data, 'update-user.php', context);
      } else {
        await _allBackEnds.updateProfilePic(_finisedImageFile!.path);
        await _allBackEnds.sqlupdateProfile(data, 'update-user.php', context);
      }
    } catch (e) {
      print(e);
      await _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);
    }
  }

//? Update Bank
  updateBank() async {
    Map<String, dynamic> data = {
      ACCOUNTNAME: _accName ?? initAccName,
      ACCOUNTNUMBER: _accNum ?? initAccNum,
      BANKNAME: _bankName ?? initBankName,
      BANKSORTCODE: _bankSortCode ?? initBankSort,
      BANKCOUNTRY: _bankCountry ?? initBankCountry
    };
//'update-user.php'
    try {
      await _allBackEnds.sqlupdateProfile(data, 'update-bank.php', context);
    } catch (e) {
      print(e);
      await _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);
    }
  }

  //? Update Bank

  updatePaypal() async {
    Map<String, dynamic> data = {
      PAYPALEMAIL: _paypalEmail ?? initPaypalEmail,
    };

    try {
      await _allBackEnds.sqlupdateProfile(data, 'update-paypal.php', context);
    } catch (e) {
      print(e);
      await _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);
    }
  }

  //? Update Bank

  updatePayoneer() async {
    Map<String, dynamic> data = {
      PAYONEERBENEFICIARYNAME:
          _payoneerBenficiaryName ?? initPayoneerBeneficiaryName,
      PAYONEERACCOUNTNUMBER: _payoneerAccNum ?? initPayoneerAccNum,
      PAYONEERBANKNAME: _payoneerBankName ?? initPayoneerBankName,
      PAYONEERROUTINGBANKSORTCODE:
          _payoneerRoutingBankSortCode ?? initPayoneerRoutingBankSort,
      PAYONEERBANKCOUNTRY: _payoneerBankCountry ?? initPayoneerBankCountry,
      PAYONEERACCOUNTTYPE: _payoneerAccType ?? initPayoneerAccType,
    };

    try {
      await _allBackEnds.sqlupdateProfile(data, 'update-payoneer.php', context);
    } catch (e) {
      print(e);
      await _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/pref_wid.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ['Account Security'],
      body: Column(
        children: [
          PreferenceWid(
            icon: Icons.password,
            title: "Passsword",
            subtitle: ["Change Password"],
            trailing: Icon(CupertinoIcons.forward, size: 15),
            onTap: () => showPassField(context),
          ),
        ],
      ),
    );
  }

  showPassField(context) {
    AllBackEnds _allBackends = AllBackEnds();
    TextEditingController _currentCtrl = TextEditingController();
    TextEditingController _newPassCtrl = TextEditingController();

    String _uid = _allBackends.getUser(UID);

    _allBackends.showModalBar(
        context,
        Container(
          height: 700,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustTextField(
                  hintTrns: true,
                  hintText: "Current Password",
                  controller: _currentCtrl,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                CustTextField(
                  hintTrns: true,
                  hintText: "New Password",
                  controller: _newPassCtrl,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                CustButton(
                  onTap: () async {
                    try {
                      await _allBackends.sqlchangePassword(
                          _uid, _currentCtrl.text, _newPassCtrl.text, context);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  title: "Change Password",
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/colors.dart';

import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/empty.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class LimitsVerification extends StatelessWidget {
  const LimitsVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();
    return KHeader(
      title: ["Account Verification"],
      body: FutureBuilder<int>(
          future: _allBackEnds.getUserKycStatusSql(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustProgIndicator();
            } else {
              int status = snapshot.data ?? 0;
              return body(status, context);
            }
          }),
    );
  }

  Widget body(int type, context) {
    switch (type) {
      case 0:
        return notApplied(context);

      case 1:
        return waitingWidget();

      case 2:
        return completedWidget();

      default:
        return notApplied(context);
    }
  }

  Widget notApplied(context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/svg/id_card.svg',
          height: 400,
        ),
        TrnsText(
          title:
              "It is mandatory that financial institutions know their customers, hence a KYC is necessary to verify that you are who you say you are. ",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        TrnsText(
          title:
              "Be rest assured that the information provided by you will be stored securely and only used for ID verification and nothing more.",
          textAlign: TextAlign.center,
          style: TextStyle(color: red),
        ),
        SizedBox(height: 10),
        TextLinkWid(
          url: KYC_AML_URL,
          title: "KYC & AML Compliance",
        ),
        SizedBox(height: 30),
        CustButton(
          onTap: () => Navigator.pushNamed(context, '/kyc-screen/'),
          title: "Start Verification",
        )
      ],
    );
  }

  Widget waitingWidget() {
    return Column(
      children: [
        EmptyWid(
          svg: 'waiting',
          title: "Under Review",
          subtitle: "Please wait while your documents are being reviewed",
        )
      ],
    );
  }

  Widget completedWidget() {
    return Column(
      children: [
        EmptyWid(
          svg: 'complete',
          title: "Congratulations",
          subtitle: "Your documents have been approved.",
        )
      ],
    );
  }
}

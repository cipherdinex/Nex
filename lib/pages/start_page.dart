import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/text_link.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
        ),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 200, 10, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                APP_NAME,
                style: TextStyle(
                  color: white,
                  fontSize: 35,
                  fontFamily: GoogleFonts.crimsonText().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    CustButton(
                        color: white,
                        textColor: black,
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/sign-up/'),
                        title: "Get Started"),
                    SizedBox(height: 20),
                    TextLinkWid(
                      title: "Sign In",
                      color: white,
                      size: 20,
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/sign-in/'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

var settingsBx = Hive.box(SETTINGS);

AllBackEnds _allBackEnds = AllBackEnds();

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    settingsBx.put('intro_seen', true);
    Navigator.of(context).pushReplacementNamed('/start-page/');
    _allBackEnds.requestNotification();
  }

  Widget _buildImage(String assetName, [double width = 400]) {
    return SvgPicture.asset(
      'assets/svg/$assetName.svg',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: scaffoldBackgroundColor,
      imagePadding: EdgeInsets.zero,
      bodyFlex: 2,
      imageFlex: 5,
      bodyAlignment: Alignment.bottomCenter,
      imageAlignment: Alignment.center,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: scaffoldBackgroundColor,
      pages: [
        PageViewModel(
          title: "Do More with Crypto",
          body: "Create an account, in one easy, straightforward step.",
          image: _buildImage('p_pic'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Your Wallet, Your Funds",
          body:
              "Instantly own a secure wallet, to manage or store your favourite assets.",
          image: _buildImage('wallet'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Let it Flow",
          body: "Seamlessly send, or receive Cryptocurrencies.",
          image: _buildImage('mailbox'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Go Shopping",
          body:
              "Confidently, Buy or Sell your Coins, via variety of payment methods.",
          image: _buildImage('s_buy'),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Safety First",
          body:
              "You data is secure by  NASA level encryption, plus SMS, Google, and Email OTP extra layer.",
          image: _buildImage('security'),
          decoration: pageDecoration,
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      next: const Icon(
        CupertinoIcons.forward,
      ),
      done: const Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

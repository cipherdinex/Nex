import 'dart:io';

import 'package:fluro/fluro.dart' as route;
import 'package:flutter/material.dart';
import 'package:kryptonia/pages/bottom_nav_home.dart';
import 'package:kryptonia/pages/buy_sell_screen.dart';
import 'package:kryptonia/pages/coin_history_screen.dart';
import 'package:kryptonia/pages/coins_list.dart';
import 'package:kryptonia/pages/activities_screen.dart';
import 'package:kryptonia/pages/drawer/2fa_screen.dart';
import 'package:kryptonia/pages/drawer/about.dart';
import 'package:kryptonia/pages/drawer/account_screen.dart';
import 'package:kryptonia/pages/drawer/community.dart';

import 'package:kryptonia/pages/drawer/kyc_screen.dart';
import 'package:kryptonia/pages/drawer/limits_verification.dart';
import 'package:kryptonia/pages/drawer/phone_2fa.dart';
import 'package:kryptonia/pages/drawer/preferences.dart';
import 'package:kryptonia/pages/drawer/profile.dart';
import 'package:kryptonia/pages/drawer/security.dart';
import 'package:kryptonia/pages/drawer/transactions.dart';
import 'package:kryptonia/pages/home_screen.dart';
import 'package:kryptonia/pages/lock_screen.dart';
import 'package:kryptonia/pages/news_detail.dart';
import 'package:kryptonia/pages/news_list.dart';
import 'package:kryptonia/pages/otp_lock.dart';
import 'package:kryptonia/pages/portfolio_screen.dart';
import 'package:kryptonia/pages/receive_crypto_screen.dart';
import 'package:kryptonia/pages/rewards_screen.dart';
import 'package:kryptonia/pages/scan_address.dart';
import 'package:kryptonia/pages/send_coin_detail.dart';
import 'package:kryptonia/pages/send_crypto_screen.dart';
import 'package:kryptonia/pages/sign_in.dart';
import 'package:kryptonia/pages/sign_up_screen.dart';
import 'package:kryptonia/pages/start_page.dart';
import 'package:kryptonia/pages/swap_coin.dart';
import 'package:kryptonia/pages/notifications_screen.dart';

class FluroRouter {
  static final router = route.FluroRouter();

  //! Home
  static route.Handler _homeHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomeScreen();
  });

  //! Sign Up
  static route.Handler _signInHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return SignInScreen();
  });

  //! Sign In
  static route.Handler _signUpHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return SignUpScreen();
  });

  //! Start Page
  static route.Handler _startHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return StartPage();
  });

  //! Lock Screen
  static route.Handler _lockHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LockScreen();
  });

  //! OTP Lock Screen
  static route.Handler _otpLockHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return OTPLockScreen();
  });

  //! Bottom Nav
  static route.Handler _bottomNavHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return BottomNavHome();
  });

  //! Portfolio
  static route.Handler _portfolioHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return PortfolioScreen();
  });

  //! Coin Hustory
  static route.Handler _coinHistoryHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String data = params['data']?.first;
    return CoinHistoryScreen(
      data: data,
    );
  });

  //! Account Activities
  static route.Handler _notificationsHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Notifications();
  });

  //! Device History
  static route.Handler _activitiesHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ActivitiesScreen();
  });

  //! All Coins
  static route.Handler _allCoinsHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return CoinsListScreen();
  });

  //! Rewards
  static route.Handler _rewardsHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String data = params['data']?.first;
    return RewardsScreen(
      data: data,
    );
  });

  //! News Latest
  static route.Handler _allNewsHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return NewsListScreen();
  });

  //! News Detail
  static route.Handler _newsDetailHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String data = params['data']?.first;
    return NewsDetailScreen(
      data: data,
    );
  });

  //! Send Coin
  static route.Handler _sendHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return SendCryptoScreen();
  });

  //! Address Scanner
  static route.Handler _addScannerHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return AddressScanner();
  });

  //! Send Detail
  static route.Handler _sendDetailHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String data = params['data']?.first;
    return SendCoinDetail(
      data: data,
    );
  });

  //! Receive COin
  static route.Handler _receiveHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ReceiveCryptoScreen();
  });

  //! Swap
  static route.Handler _swapHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return SwapScreen();
  });

  //! Buy Sell
  static route.Handler _buySellHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return BuySellCryptoScreen();
  });

  //! Profile
  static route.Handler _profileHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ProfileScreen();
  });

  //! Limits & Verification
  static route.Handler _limitsVerificationHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LimitsVerification();
  });

  //! KYC
  static route.Handler _kycHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return KYCScreen();
  });

  //! Transactions
  static route.Handler _transactionsHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return TransactionsScreen();
  });

  //! Preferences
  static route.Handler _preferencesHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return PreferenceScreen();
  });

  //! Security
  static route.Handler _securityHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return SecurityScreen();
  });

  //! 2 Factor Auth
  static route.Handler _twoFaHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return TwoFAScreen();
  });

  //! Phone
  static route.Handler _phoneHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Phone2FA();
  });

  //! Account Security
  static route.Handler _accSecurityHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return AccountScreen();
  });

  //! Join Community
  static route.Handler _joinComHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return JoinCommunity();
  });

  //! About
  static route.Handler _aboutHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return AboutScreen();
  });

  static void setupRouter() {
    //! Home
    router.define(
      '/',
      handler: _homeHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Sign Up
    router.define(
      '/sign-up/',
      handler: _signUpHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Sign In
    router.define(
      '/sign-in/',
      handler: _signInHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Start Page
    router.define(
      '/start-page/',
      handler: _startHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Lock Screen
    router.define(
      '/lock-screen/',
      handler: _lockHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! OTP Lock Screen
    router.define(
      '/otp-lock/',
      handler: _otpLockHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Bottom Nav
    router.define(
      '/bottom-nav/',
      handler: _bottomNavHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Portfolio
    router.define(
      '/portfolio/',
      handler: _portfolioHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Coin History
    router.define(
      '/coin-history/:data/',
      handler: _coinHistoryHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Account Activities
    router.define(
      '/notifications/',
      handler: _notificationsHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Device History
    router.define(
      '/activities-history/',
      handler: _activitiesHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! All Coins
    router.define(
      '/all-coins/',
      handler: _allCoinsHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Rewards
    router.define(
      '/rewards/:data/',
      handler: _rewardsHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! News Latest
    router.define(
      '/news-latest/',
      handler: _allNewsHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! News Detail
    router.define(
      '/news-detail/:data/',
      handler: _newsDetailHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Send Coin
    router.define(
      '/send-coin/',
      handler: _sendHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Address Scanner
    router.define(
      '/address-scanner/',
      handler: _addScannerHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Send Detail
    router.define(
      '/send-detail/:data/',
      handler: _sendDetailHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Receive Coin
    router.define(
      '/receive-coin/',
      handler: _receiveHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Swap
    router.define(
      '/swap-coin/',
      handler: _swapHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Buy Sell
    router.define(
      '/buy-sell-coin/',
      handler: _buySellHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Profile
    router.define(
      '/profile/',
      handler: _profileHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Limits & Verification
    router.define(
      '/limits-verification/',
      handler: _limitsVerificationHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! KYC
    router.define(
      '/kyc-screen/',
      handler: _kycHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Transactions
    router.define(
      '/transactions/',
      handler: _transactionsHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Preferences
    router.define(
      '/preferences/',
      handler: _preferencesHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Security
    router.define(
      '/security/',
      handler: _securityHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! 2 Factor Auth
    router.define(
      '/two-fa/',
      handler: _twoFaHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Phone
    router.define(
      '/phone-2fa/',
      handler: _phoneHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Account Security
    router.define(
      '/account-security/',
      handler: _accSecurityHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! Join Community
    router.define(
      '/join-community/',
      handler: _joinComHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! About
    router.define(
      '/about/',
      handler: _aboutHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    router.notFoundHandler = route.Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return BottomNavHome();
    });
  }
}

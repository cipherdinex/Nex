import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kryptonia/backends/localization.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/routes.dart';
import 'package:kryptonia/pages/home_screen.dart';
import 'package:kryptonia/pages/middleware.dart';
import 'package:kryptonia/utils/provider_controllers.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProviderControllers provideCtrl = ProviderControllers();
    final ThemeData theme = ThemeData();

    return ChangeNotifierProvider<ProviderControllers>(
      create: (context) => ProviderControllers(),
      child: Consumer<ProviderControllers>(builder: (context, appState, child) {
        return MaterialApp(
          locale: Locale(provideCtrl.getLocale()),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ar', "AE"),
            Locale('de', "DE"),
            Locale('en', "US"),
            Locale('es', "ES"),
            Locale('fr', "FR"),
            Locale('hi', "IN"),
            Locale('id', "ID"),
            Locale('ja', "JP"),
            Locale('ko', "KR"),
            Locale('nl', "NL"),
            Locale('pt', "PT"),
            Locale('ru', "RU"),
            Locale('zh', "CN"),
          ],
          navigatorObservers: [
            SentryNavigatorObserver(),
          ],
          initialRoute: '/',
          onGenerateRoute: FluroRouter.router.generator,
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          title: 'Nex',
          debugShowCheckedModeBanner: false,
          themeMode: provideCtrl.currentTheme(),
          theme: ThemeData(
            primarySwatch: primarySwatch,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          darkTheme: ThemeData(
            primarySwatch: primarySwatch,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            colorScheme: theme.colorScheme.copyWith(
              secondary: accentColor,
              brightness: Brightness.dark,
              primary: Colors.purple,
            ),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          home: AppMiddleWare(),
        );
      }),
    );
  }
}

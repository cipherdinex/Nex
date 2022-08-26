import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/helpers/routes.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/pages/app_main.dart';
import 'package:kryptonia/utils/provider_controllers.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late FirebaseMessaging messaging;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(USERS);
  await Hive.openBox(SETTINGS);
  await Hive.openBox(ALL_CRYPTO_DATAS);
  await Hive.openBox(CRYPTO_DATAS);

  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");

  FluroRouter.setupRouter();

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
    },
    // Init your App.
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProviderControllers>(
            create: (context) => ProviderControllers(),
          ),
        ],
        child: AppMain(),
      ),
    ),
  );
}

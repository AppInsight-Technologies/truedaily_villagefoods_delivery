import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart' as config;
import 'generated/i18n.dart';
import 'route_generator.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import './providers/ordersitems.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: OrdersItemsList(),
      ),
    ],
      child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) {
            if (brightness == Brightness.light) {
              return ThemeData(
                fontFamily: 'Poppins',
                primaryColor: Colors.white,
                brightness: brightness,
                hoverColor: Colors.black,
                accentColor: config.Colors().mainColor(1),
                focusColor: config.Colors().accentColor(1),
                hintColor: config.Colors().secondColor(1),
                splashColor: Colors.transparent,
                textTheme: TextTheme(
                  headline1: TextStyle(fontSize: 20.0, color: config.Colors().secondColor(1)),
                  headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                  headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondColor(1)),
                  headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                  headline5: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                  subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                  subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainColor(1)),
                  bodyText1: TextStyle(fontSize: 12.0, color: config.Colors().secondColor(1)),
                  bodyText2: TextStyle(fontSize: 14.0, color: config.Colors().secondColor(1)),
                  caption: TextStyle(fontSize: 12.0, color: config.Colors().accentColor(1)),
                ),
              );
            } else {
              return ThemeData(
                fontFamily: 'Poppins',
                primaryColor: Color(0xFF252525),
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Color(0xFF2C2C2C),
                accentColor: config.Colors().mainDarkColor(1),
                hintColor: config.Colors().secondDarkColor(1),
                focusColor: config.Colors().accentDarkColor(1),
                textTheme: TextTheme(
                  headline1: TextStyle(fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
                  headline4:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1)),
                  headline3:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.Colors().secondDarkColor(1)),
                  headline2:
                  TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                  headline5:
                  TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1)),
                  subtitle1:
                  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
                  subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.Colors().mainDarkColor(1)),
                  bodyText1: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
                  bodyText2: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: config.Colors().secondDarkColor(1)),
                  caption: TextStyle(fontSize: 12.0, color: config.Colors().secondDarkColor(0.6)),
                ),
              );
            }
          },
          themedWidgetBuilder: (context, theme) {
            return ValueListenableBuilder(
                valueListenable: settingRepo.locale,
                builder: (context, Locale value, _) {
                  print(value);
                  return MaterialApp(
                    title: 'Delivery Boy',
                    initialRoute: '/Splash',
                    onGenerateRoute: RouteGenerator.generateRoute,
                    debugShowCheckedModeBanner: false,
                    locale: value,
                    localizationsDelegates: [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
                    navigatorObservers: [
                      FirebaseAnalyticsObserver(analytics: analytics),
                    ],
                    theme: theme,
                  );
                });
          }),
    );
  }
}

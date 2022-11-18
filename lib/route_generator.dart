/*import 'package:deliveryboy/src/pages/notifications.dart';
import 'package:deliveryboy/src/pages/profile.dart';
import 'package:deliveryboy/src/pages/returns.dart';*/


/*import 'src/models/route_argument.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/order.dart';

import 'src/pages/settings.dart';*/

import 'package:flutter/material.dart';
import '../../src/pages/cash_logs.dart';
import '../../src/pages/orders_history.dart';
import '../../src/pages/pending.dart';
import '../../src/pages/return.dart';
import '../../src/pages/totalorder.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/login.dart';
import 'src/pages/pages.dart';
import './src/pages/returns.dart';
import './src/models/route_argument.dart';
import './src/pages/order.dart';
import './src/pages/profile.dart';
import './src/pages/notifications.dart';
import './src/pages/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: args));
      case '/OrderDetails':
        return MaterialPageRoute(builder: (_) => OrderWidget(routeArgument: args as RouteArgument));
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsWidget());
      /*case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());*/
      /*case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());*/
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/CashScreen':
        return MaterialPageRoute(builder: (_) => CashScreen(routeArgument: args as RouteArgument));
      case '/PendingOrder':
        return MaterialPageRoute(builder: (_) => PendingOrder(routeArgument: args as RouteArgument));
      case '/TotalOrder':
        return MaterialPageRoute(builder: (_) => TotalOrder(routeArgument: args as RouteArgument));
      case '/OrdersHistory':
        return MaterialPageRoute(builder: (_) => OrdersHistoryWidget(routeArgument: args as RouteArgument));
      case '/ReturnOrder':
        return MaterialPageRoute(builder: (_) => ReturnWidget(routeArgument: args as RouteArgument));
      case '/ReturnDetails':
        return MaterialPageRoute(builder: (_) => ReturnsWidget(routeArgument: args as RouteArgument));
      default:
      // If there is no such named route in the switch statement, e.g. /third
      //return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: 1));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../repository/settings_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  String name = "";
  String email = "";
  String address = "";
  SharedPreferences prefs;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        name = prefs.getString("first_name") + " " + prefs.getString("last_name");
        email = prefs.getString("email");
        address = prefs.getString("address");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:/* _con.user.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : */ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 1);
                  },
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
                    ),
                    accountName: Text(
                      name,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    accountEmail: Text(
                      email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.account_circle, size: 80, color: Theme.of(context).accentColor,),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 1);
                  },
                  leading: Icon(
                    Icons.fastfood,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).orders,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                /*ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Notifications');
                  },
                  leading: Icon(
                    Icons.notifications,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).notifications,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),*/
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 2);
                  },
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).history,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Profile', arguments: 2);
                  },
                  leading: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).profile,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).application_preferences,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Settings');
                  },
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).settings,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),

               /* ListTile(
                  onTap: () {
                    if (Theme.of(context).brightness == Brightness.dark) {

                      setBrightness(Brightness.light);
                      DynamicTheme.of(context).setBrightness(Brightness.light);
                    } else {
                      setBrightness(Brightness.dark);
                      DynamicTheme.of(context).setBrightness(Brightness.dark);
                    }
                  },
                  leading: Icon(
                    Icons.brightness_6,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    Theme.of(context).brightness == Brightness.light
                        ? S.of(context).light_mode
                        : S.of(context).dark_mode,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),*/
                ListTile(
                  onTap: () {
                    prefs.setString("login_status", "false");
                    Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
                  },
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).log_out,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version + " 1.0.0",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
    );
  }
}

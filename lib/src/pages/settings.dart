import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../helpers/helper.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  String name = "";
  String email = "";
  String address = "";
  String mobilenum = "";
  SharedPreferences prefs;


  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        name = prefs.getString("first_name") + " " + prefs.getString("last_name");
        email = prefs.getString("email");
        address = prefs.getString("address");
        mobilenum = prefs.getString("mobile_number");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).settings,
            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: /*_con.user.id == null
            ? CircularLoadingWidget(height: 500)
            : */SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  name,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Text(
                                  email,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                              //crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          SizedBox(
                              width: 55,
                              height: 55,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(300),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                                },
                                child: Icon(Icons.account_circle, size: 55, color: Theme.of(context).accentColor,),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              S.of(context).profile_settings,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).full_name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              name,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).email,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              email,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).phone,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              mobilenum,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).address,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              Helper.limitString(address),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}

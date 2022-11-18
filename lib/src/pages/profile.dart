import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../../src/controllers/profile_controller.dart';
import '../../src/elements/DrawerWidget.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;
  String name = "";
  String email = "";
  String address = "";
  String wallet ="0";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SharedPreferences prefs;


  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        name = prefs.getString("firstName") + " " + prefs.getString("lastName");
        email = prefs.getString("email");
        address = prefs.getString("address");
        wallet = prefs.getString("wallet_balance");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: /*Theme.of(context).hintColor*/Colors.white),
            onPressed: () => Navigator.of(context).pop()
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
        ],
      ),
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: /*_con.user.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : */SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileAvatarWidget(name: name, email: email, address: address),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      "Address",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Container(
                     padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text(
                      address,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  ListTile(
                    onTap: ()async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setString("login_status", "false");
                        Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
                      });
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
                ],
              ),
            ),
      /*bottomNavigationBar:   Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: *//*Image.asset("assets/img/rupee.png",
                      color: Colors.grey ,
                      width: 50,
                      height: 30,),*//*
                      Text("₹‎ "+wallet, style: TextStyle(fontSize: 12.0,color: Colors.black),),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        "Cash in hand",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 10.0)),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  CircleAvatar(
                    radius: 13.0,
                    // minRadius: 50,
                    // maxRadius: 50,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    child: Image.asset("assets/img/home.png",
                      //  color:ColorCodes.greenColor,
                      color:Theme.of(context).accentColor,

                      width: 50,
                      height: 30,
                    ),

                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    //  S.of(context).home,
                      "Home",
                      style: TextStyle(
                          color:Theme.of(context).accentColor,
                          //  color: ColorCodes.greenColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                //  Navigator.of(context).pushNamed('/Profile', arguments: 2);
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/img/profile.png",
                        color: Colors.grey ,
                        width: 50,
                        height: 30,),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 10.0)),
                  ],
                ),
              ),
            ],
          )
      ),*/
    );
  }
}

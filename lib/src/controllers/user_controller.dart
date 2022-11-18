import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';

class UserController extends ControllerMVC {
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
    });
  }

  /*void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.login(user).then((value) {
        print(value.apiToken);
        if (value != null && value.apiToken != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.welcome + value.name),
          ));
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.wrong_email_or_password),
          ));
        }
      });
    }
  }*/
}

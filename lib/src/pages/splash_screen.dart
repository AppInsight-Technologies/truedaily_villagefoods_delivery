import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../handler/firebase_notification_handler.dart';
import '../../providers/ordersitems.dart';
import '../../src/models/route_argument.dart';
import '../../src/pages/orders.dart';
import '../../utils/prefUtils.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../controllers/controller.dart';

import 'package:firebase_messaging/firebase_messaging.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  Controller _con;
  SharedPreferences prefs;
  bool status = true;
  bool timmer = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SplashScreenState() : super(Controller()) {
    _con = controller;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      await PrefUtils.init();
      await new FirebaseNotifications().setUpFirebase();
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            timmer = false;
            /*Navigator.of(context).pushNamed(
            HomeScreen.routeName,
          );*/

            final responseJson = json.encode(message);
            final responseJsonDecode = json.decode(responseJson);
            final notificationEncode = json.encode(responseJsonDecode['notification']);
            final notificationDecode = json.decode(notificationEncode);
            final dataEncode = json.encode(responseJsonDecode['data']);
            final dataDecode = json.decode(dataEncode);

            Fluttertoast.showToast(msg: notificationDecode["body"].toString());

            if(prefs.containsKey("id"))
              Provider.of<OrdersItemsList>(context,listen:false).GetOrders("0").then((_) {
                setState(() {
                  OrdersWidget.ordersData = Provider.of<OrdersItemsList>(context,listen:false);
                });
              });

            return Fluttertoast.showToast(msg: notificationDecode["body"].toString());
          },

          onResume: (Map<String, dynamic> message) async {
            timmer = false;
        if(prefs.containsKey("id"))
          Provider.of<OrdersItemsList>(context,listen:false).GetOrders("0").then((_) {
            setState(() {
              OrdersWidget.ordersData = Provider.of<OrdersItemsList>(context,listen:false);
            });
          });

            final responseJson = json.encode(message);
            final responseJsonDecode = json.decode(responseJson);
            final notificationEncode = json.encode(responseJsonDecode['notification']);
            final notificationDecode = json.decode(notificationEncode);
            final dataEncode = json.encode(responseJsonDecode['data']);
            final dataDecode = json.decode(dataEncode);


       // return Fluttertoast.showToast(msg: notificationDecode["body"].toString());
      },

          onLaunch: (Map<String, dynamic> message) async {
            timmer = false;
            //Navigator.push(navigatorKey.currentContext, MaterialPageRoute(builder: (_) => HomeScreen()));
            final responseJson = json.encode(message);
            final responseJsonDecode = json.decode(responseJson);
            final notificationEncode = json.encode(responseJsonDecode['notification']);
            final notificationDecode = json.decode(notificationEncode);
            final dataEncode = json.encode(responseJsonDecode['data']);
            final dataDecode = json.decode(dataEncode);

            //return Fluttertoast.showToast(msg: "onLaunch!!!");
            debugPrint("api....." + responseJson.toString());
            debugPrint("mode..." + dataDecode["mode"].toString());
            Navigator.of(context).pushNamed('/OrderDetails',
              arguments: RouteArgument(
                id: dataDecode["ref"].toString(),
                fromScreen: "pushNotification",
                /*orderstatus: deliveredData.delivereditems[i].orderstatus,
                payment_type: deliveredData.delivereditems[i].payment_type,
                order_amount: deliveredData.delivereditems[i].order_amount,
                fix_date: deliveredData.delivereditems[i].fix_date,
                fix_time: deliveredData.delivereditems[i].fix_time,
                customer_name: deliveredData.delivereditems[i].customer_name,//OrdersWidget.ordersData.items[i].customer_name,
                address: deliveredData.delivereditems[i].address,
                actual_amount: deliveredData.delivereditems[i].actual_amount,
                delivery_charge:deliveredData.delivereditems[i].delivery_charge,
                otp:deliveredData.delivereditems[i].otp,*/
               // index: i,
              ),
            );
          }

      );

      if(prefs.containsKey("login_status")){
        if(prefs.getString("login_status") == "true") {
          setState(() {
            status = true;
          });
        } else {
          setState(() {
            status = false;
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
      loadData();
    });
    super.initState();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    if(status) {
      if(timmer) Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
    } else {
      if(timmer) Navigator.of(context).pushReplacementNamed('/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Image.asset( "assets/img/splash.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

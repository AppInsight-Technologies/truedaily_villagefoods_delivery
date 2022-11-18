import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OrderController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
}

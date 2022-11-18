import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OrderDetailsController extends ControllerMVC {
  double taxAmount = 0.00;
  double subTotal = 0.00;
  double total = 0.00;
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderDetailsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

}

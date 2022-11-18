import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class OrdersFields with ChangeNotifier {
  final String orderid;
  final String address;
  String orderstatus;
  final String payment_type;
  final String order_amount;
  final String fix_date;
  final String fix_time;
  final String customer_name;
  final String actual_amount;
  final String delivery_charge;
  final String imageurl;

  final String itemname;
  final String itemorderid;
  final String itemvar;
  final String itemqty;
  final String itemamount;
  final String itemorderdate;
  final String mobile;
  final String latitude;
  final String longitude;
  final String tax;

  final String returnreason;
  final String referenceid;
  final String dashboarddate;
  final String pending_order;
  final String completed_order;
  final String returns;
  final String wallet;
  final String recent_orders;
  String orderStatus;
  final String total_pending;
  final String otp;
  final String orderType;
  final String img;

  OrdersFields({
    this.orderid,
    this.address,
    this.orderstatus,
    this.payment_type,
    this.order_amount,
    this.fix_date,
    this.fix_time,
    this.customer_name,
    this.actual_amount,
    this.delivery_charge,

    this.itemname,
    this.itemorderid,
    this.itemvar,
    this.itemqty,
    this.itemamount,
    this.itemorderdate,
    this.mobile,
    this.latitude,
    this.longitude,
    this.tax,
    this.imageurl,
    this.returnreason,
    this.referenceid,
    this.dashboarddate,
    this.pending_order,
    this.completed_order,
    this.returns,
    this.wallet,
    this.recent_orders,
    this.orderStatus,
    this.total_pending,
    this.otp,
    this.orderType,
    this.img,
  });
}
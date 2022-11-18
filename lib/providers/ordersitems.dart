import 'dart:convert';
import 'package:flutter/material.dart';
import '../../constants/images.dart';
import '../../providers/cashlogfields.dart';
import '../../utils/prefUtils.dart';
import 'package:intl/intl.dart';
import '../constants/Iconstants.dart';
import '../providers/ordersfields.dart';
import '../providers/notificationfield.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersItemsList with ChangeNotifier {
  List<OrdersFields> _items = [];
  List<OrdersFields> _groceryitems = [];
  List<OrdersFields> _delivereditems = [];
  List<OrdersFields> _returnitems =[];
  List<OrdersFields> _pendingitems =[];
  List<OrdersFields> _itemsreturn = [];
  List<OrdersFields> _itemsreturnvalue = [];
  List<OrdersFields> _recentitems=[];
  List<CashFields> _cashitems=[];
  OrdersFields _dashboard;
  List<NotificationFields> _notItems = [];
  Future<void> GetRestaurant() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'get-resturant';
    debugPrint("asdfvbnm,");
  //  debugPrint("asdf"+ PrefUtils.prefs.getString('branch'));
    try {
      final response = await http.post(url,
          body: {
            // await keyword is used to wait to this operation is complete.
            "branch": PrefUtils.prefs.getString('branch'),
          });

      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      debugPrint("GetRestaurant . . . . .");
      debugPrint(responseJson.toString());
      if (responseJson.toString() == "[]") {
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));
        print("barbd length"+data.length.toString());
        for (int i = 0; i < data.length; i++) {
          print("currency"+data[i]['currency_format'].toString());
          PrefUtils.prefs.setString("currency_format", data[i]['currency_format'].toString());

        }
      }
    } catch (error) {
      throw error;
    }
  }


  Future<void> Login() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + "restaurant/delivery-boy-login";
    debugPrint("entered login.......");
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("entered login1......."+prefs.getString('phonenumber').toString()+"  "+ prefs.getString('Password').toString()+"  "+prefs.getString('tokenid').toString());
    final response = await http.post(url,body: { // await keyword is used to wait to this operation is complete.
      "mobile": prefs.getString('phonenumber'),
      "password": prefs.getString('Password'),
      "tokenId": prefs.getString('tokenid'),
      "branch": "95",
      "branchtype": "0",
      "mode": "0"
    }
    );
    debugPrint("entered login2.......");
    final responseJson = json.decode(response.body);
    debugPrint("entered login3.......");
    print("Response...................");
    print(responseJson);

    if(responseJson['status'].toString() == "200"){
      final dataJson = json.encode(responseJson['data']); //fetching categories data
      final dataJsondecode = json.decode(dataJson);

      List data = []; //list for categories

      dataJsondecode.asMap().forEach((index, value) =>
          data.add(dataJsondecode[index] as Map<String, dynamic>)
      );
      print("id.........." + data[0]['id'].toString());
      prefs.setString('id', data[0]['id'].toString());
      prefs.setString('firstName', data[0]['firstName'].toString());
      prefs.setString('lastName', data[0]['lastName'].toString());
      prefs.setString('mobileNumber', data[0]['mobileNumber'].toString());
      prefs.setString('email', data[0]['email'].toString());
      prefs.setString('address', data[0]['address'].toString());
      prefs.setString('branch',data[0]['branch'].toString());
      prefs.setString("login_status", "true");
      debugPrint("otttpp..."+responseJson['otp'].toString());
      IConstants.isOtp=(responseJson['otp'].toString()=="0")?true:false;
    } else {


    }

    }
    catch (error) {

      print(error);
      throw error;
    }
  }

  Future<void> dashboard(String date) async {
    var url = IConstants.API_PATH + 'delivery-dashboard';
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // try {
      debugPrint("id.." + prefs.getString('id').toString());
      final response = await http
          .post(
          url,
          body: {
            // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "date": /*"26-10-2021"*/date,
          }
      );
      final responseJson = json.decode(response.body);
      debugPrint("dashboard...."+responseJson.toString());
    _recentitems.clear();
      //_dashboard.clear();
      print(responseJson);
      if (responseJson.toString() != "[]") {
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/

        List data = []; //list for categories

        /*responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );*/
        //for (int i = 0; i < data.length; i++) {
          _dashboard=new OrdersFields(
              dashboarddate:responseJson['date'].toString(),
              total_pending:responseJson['total_pending'].toString(),
              pending_order:responseJson['pending_order'].toString(),
              completed_order:responseJson["completed_order"].toString(),
              returns:responseJson['return'].toString(),
              wallet: responseJson["wallet"].toString(),
             // recent_orders:responseJson['data']["recent_orders"].toString(),
          /*  orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) +
                double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double
                .parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['orderStatus'].toString(),*/
          );
        prefs.setString("wallet_balance",responseJson["wallet"].toString());
        //}

      }
      final recentOrderJson = json.encode(responseJson['recent_orders']);
      debugPrint("today.."+recentOrderJson.toString());
      final recentJsondecode = json.decode(recentOrderJson);
      if (recentJsondecode.toString() == "[]") {
      } else {
        List recentData = [];
        recentJsondecode.asMap().forEach((index, value) =>
            recentData.add(recentJsondecode[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < recentData.length; i++) {
          var delivery = "";
          var img;
          if(recentData[i]['orderStatus'].toString()=="dispatched"){
            delivery = "Assigned";
            img =Images.recieved;
          }else if(recentData[i]['orderStatus'].toString()=="onway"){
            delivery = "Out for Delivery";
            img =Images.out_delivery;
          }else if(recentData[i]['orderStatus'].toString()=="delivered"){
            delivery = "Delivered";
            img =Images.delivered;
          }else if(recentData[i]['orderStatus'].toString()=="reschedule"){
            delivery = "Reschedule";
            img =Images.delivered;
          }else if(recentData[i]['orderStatus'].toString()=="cancelled"){
            delivery = "Cancelled";
            img =Images.recieved;
          }
          var orderType ="";
          if(recentData[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _recentitems.add(OrdersFields(
            orderid: recentData[i]['id'].toString(),
            address: recentData[i]['address'].toString(),
            payment_type: recentData[i]['paymentType'].toString(),
            order_amount: (double.parse(recentData[i]['orderAmount']) + double.parse(recentData[i]['wallet'])).toStringAsFixed(2),
            fix_date: recentData[i]['fixDate'].toString(),
            fix_time: recentData[i]['fixtime'].toString(),
            customer_name: recentData[i]['customerName'].toString(),
            actual_amount: (recentData[i]['actualAmount'] == "") ? "0.00" : double.parse(recentData[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: recentData[i]['deliveryCharge'].toString(),
            orderstatus: recentData[i]['orderStatus'].toString(),
            orderStatus: delivery,
              orderType:/*recentData[i]['orderType'].toString()*/orderType,
            otp: (recentData[i]['otp'].toString() != "null") ? recentData[i]['otp'].toString() : "0",
            img:img,
          ));
        }
      }
      notifyListeners();
    /*} catch (error) {
      print(error);
      throw error;
    }*/
  }

  Future<void> GetOrders(String mode) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-neworder';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      debugPrint("id.."+prefs.getString('id').toString());
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "mode": mode,
          }
      );
      final responseJson = json.decode(response.body);
      _items.clear();
      print(responseJson);
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          var delivery = "";
          var img;
          if( data[i]['orderStatus'].toString()=="dispatched"){
            delivery = "Assigned";
            img =Images.recieved;
          }else if( data[i]['orderStatus'].toString()=="onway"){
            delivery = "Out for Delivery";
            img =Images.out_delivery;
          }else if( data[i]['orderStatus'].toString()=="delivered"){
            delivery = "Delivered";
            img =Images.delivered;
          }else if(data[i]['orderStatus'].toString()=="reschedule"){
            delivery = "Reschedule";
            img =Images.recieved;
          }else if(data[i]['orderStatus'].toString()=="cancelled"){
            delivery = "Cancelled";
            img =Images.recieved;
          }
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _items.add(OrdersFields(
            orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['orderStatus'].toString(),
            orderStatus: delivery,
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img:img,
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

   /* var url1 = IConstants.API_PATH + 'restaurant/delivery-boy-neworder';
    try {
      final response = await http
          .post(
          url1,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "mode": "1",
          }
      );
      final responseJson = json.decode(response.body);
      print(responseJson);
      if(responseJson.toString() != "[]"){
        *//*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*//*

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          _items.add(OrdersFields(
            orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['orderStatus'].toString(),
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
*/
  }

  List<OrdersFields> get items {
    return [..._items];
  }
  Future<void> GetItems(String orderid) async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'view-order/' + orderid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _groceryitems.clear();
      final response = await http.get(
        url,
      );
      final responseJson = json.decode(response.body);
      print('hello');
      print(responseJson);
      final itemsJson = json.encode(responseJson['items']);
      final itemsJsondecode = json.decode(itemsJson);
      List data = [];
      if (itemsJsondecode.toString() != "[]") {
        itemsJsondecode.asMap().forEach((index, value) =>
            data.add(itemsJsondecode[index] as Map<String, dynamic>));
        for (int i = 0; i < data.length; i++) {
          _groceryitems.add(OrdersFields(
              itemname: data[i]['itemName'].toString(),
              itemorderid: data[i]['order_d'].toString(),
              itemvar: data[i]['priceVariavtion'].toString(),
              itemqty: data[i]['quantity'].toString(),
              itemamount: data[i]['subTotal'].toString(),
              itemorderdate: responseJson['orderDate'].toString(),
              mobile: responseJson['mobileNo'].toString(),
              latitude: responseJson['latitude'].toString(),
              longitude: responseJson['logitude'].toString(),
            actual_amount:responseJson['actualAmount'].toString(),
            delivery_charge:responseJson['deliveryCharge'].toString(),
            order_amount:responseJson['orderAmount'].toString(),
              imageurl: data[i]['image'].toString(),
              customer_name:responseJson["customerName"].toString(),
            address: responseJson['address'].toString(),
            orderstatus: responseJson['orderStatus'].toString(),
            payment_type: responseJson['paymentType'].toString(),
            fix_time: responseJson['fixtime'].toString(),
            otp: (responseJson['otp'].toString() != "null") ? responseJson['otp'].toString() : "0",
          ));
          print('hi.............');
          debugPrint(data[i]['image'].toString());
          debugPrint(responseJson['otp'].toString());
          debugPrint(responseJson['latitude'].toString());
          debugPrint(responseJson['logitude'].toString());
          print(responseJson['mobileNo'].toString());
        }
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

 /* Future<void> GetItems(String orderid) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-neworder';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _groceryitems.clear();
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": orderid,
            "mode": "3",
          }
      );
      final responseJson = json.decode(response.body);
      print(responseJson);
      if(responseJson.toString() != "[]"){
        *//*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*//*

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          _groceryitems.add(OrdersFields(
            itemname: data[i]['itemName'].toString(),
            itemorderid: data[i]['order_d'].toString(),
            itemvar: data[i]['priceVariavtion'].toString(),
            itemqty: data[i]['quantity'].toString(),
            itemamount: double.parse(data[i]['price']).toStringAsFixed(2),
            itemorderdate: data[i]['orderDate'].toString(),
            mobile: data[i]['mobileNo'].toString(),
            latitude: data[i]['latitude'].toString(),
            longitude: data[i]['logitude'].toString(),
            tax: data[i]['tax'].toString(),
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

  }
*/
  List<OrdersFields> get orderitems {
    return [..._groceryitems];
  }

  Future<void> DeliveredItems(String orderid, String mobile) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-status';
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": orderid,
            "status": "4",
            "mobile": mobile,
          }
      );
      print("restaurant/delivery-boy-status after delivery...."+url.toString());
      print("Param..."+{ // await keyword is used to wait to this operation is complete.
        "id": orderid,
        "status": "4",
        "mobile": mobile,
      }.toString());
      final responseJson = json.decode(response.body);
      /*if(responseJson.toString() != "[]"){

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          _groceryitems.add(OrdersFields(
            itemname: data[i]['itemName'].toString(),
            itemorderid: data[i]['order_d'].toString(),
            itemvar: data[i]['priceVariavtion'].toString(),
            itemqty: data[i]['quantity'].toString(),
            itemamount: data[i]['orderAmount'].toString(),
            itemorderdate: data[i]['orderDate'].toString(),
          ));
        }
      } else {

      }*/
    } catch (error) {
      print(error);
      throw error;
    }
  }
  Future<void> GetPendingOrder(String date, String mode) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'delivery-pending-order';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _pendingitems.clear();
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "date": date,
            "mode": mode,
          }
      );
      final responseJson = json.decode(response.body);
      _pendingitems.clear();
      print(responseJson);
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          var delivery = "";
          var img;
          if(data[i]['orderStatus'].toString()=="dispatched"){
            delivery = "Assigned";
            img =Images.recieved;
          }else if(data[i]['orderStatus'].toString()=="onway"){
            delivery = "Out for Delivery";
            img =Images.out_delivery;
          }else if(data[i]['orderStatus'].toString()=="reschedule"){
            delivery = "Reschedule";
            img =Images.recieved;
          }else if(data[i]['orderStatus'].toString()=="cancelled"){
            delivery = "Cancelled";
            img =Images.recieved;
          }
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _pendingitems.add(OrdersFields(
            orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['orderStatus'].toString(),
            orderStatus: delivery,
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img: img,
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

  }
  Future<void> GetDelivered(String date) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'delivery-completed-order';
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // _delivereditems.clear();
    try {
      _delivereditems.clear();
      print("DElivery complete...."+  { // await keyword is used to wait to this operation is complete.
      "id": prefs.getString('id'),
      "date": date,
      }.toString());
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "date": date,
          }
      );
      final responseJson = json.decode(response.body);
      _delivereditems.clear();
      print(responseJson);
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _delivereditems.add(OrdersFields(
            orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['orderStatus'].toString(),
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img: Images.delivered,
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

  }
 /* Future<void> GetDelivered() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-neworder';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _delivereditems.clear();
    try {
      _items.clear();
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "mode": "2",
          }
      );
      final responseJson = json.decode(response.body);
      print(responseJson);
      if(responseJson.toString() != "[]"){
        *//*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*//*

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          _delivereditems.add(OrdersFields(
            orderid: data[i]['id'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
            order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['fixDate'].toString(),
            fix_time: data[i]['fixtime'].toString(),
            customer_name: data[i]['customerName'].toString(),
            actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: "delivered",
          ));
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

  }*/

  List<OrdersFields> get delivereditems {
    return [..._delivereditems];
  }
 List<OrdersFields> get pendingitems {
    return [..._pendingitems];
 }
  List<OrdersFields> get returnitems{
    return [..._returnitems];
  }
  Future<void> ReturnLog(String date) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'delivery-return-order';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // try {
      _returnitems.clear();
      debugPrint("wait....."+{
        "id": prefs.getString('id'),
        "date": date,
      }.toString());
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": prefs.getString('id'),
            "date": date,
          /*  "delivery": prefs.getString('id'),
            "mode": "1",*/
          }
      );
      final responseJson = json.decode(response.body);
      _returnitems.clear();
      print("resturn..."+responseJson.toString());
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          var delivery = "";
          var img;
          if(data[i]['status'].toString()=="1"){
            delivery = "Assigned";
            img =Images.recieved;
          }else if(data[i]['status'].toString()=="2"){
            delivery = "Out for Delivery";
            img =Images.out_delivery;
          }else if(data[i]['status'].toString()=="4"){
            delivery = "Completed";
            img =Images.recieved;
          }else if(data[i]['status'].toString()=="10"){
            delivery = "Delivered";
            img =Images.recieved;
          }
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _returnitems.add(OrdersFields(
            orderid: data[i]['ref'].toString(),
            address: data[i]['address'].toString(),
            payment_type: data[i]['paymentType'].toString(),
           // order_amount: (double.parse(data[i]['orderAmount']) + double.parse(data[i]['wallet'])).toStringAsFixed(2),
            fix_date: data[i]['date'].toString(),
            fix_time: data[i]['addedTime'].toString(),
            customer_name: data[i]['username'].toString(),
            mobile: data[i]['mobileNo'].toString(),
            latitude: data[i]['latitude'].toString(),
            longitude: data[i]['longitude'].toString(),
            returnreason: data[i]['reason'].toString(),
           // actual_amount: (data[i]['actualAmount'] == "") ? "0.00" : double.parse(data[i]['actualAmount']).toStringAsFixed(2),
            delivery_charge: data[i]['deliveryCharge'].toString(),
            orderstatus: data[i]['status'].toString(),
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img: img,
            orderStatus: delivery,
          ));
        }
      } else {

      }
  /*    notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }*/

  }
  Future<void> GetReturn() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'get-returns';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _itemsreturn.clear();
      _itemsreturnvalue.clear();
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "delivery": prefs.getString('id'),
            "mode": "1",
          }
      );
      final responseJson = json.decode(response.body);
      print("Return. .. .... .... ...");
      print(responseJson);
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/


        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );


        for(int i = 0; i < data.length; i++) {
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _itemsreturn.add(OrdersFields(
            orderid: data[i]['ref'].toString(),
            address: data[i]['address'].toString(),
            customer_name: data[i]['username'].toString(),
            mobile: data[i]['mobileNo'].toString(),
            latitude: data[i]['latitude'].toString(),
            longitude: data[i]['longitude'].toString(),
            returnreason: data[i]['reason'].toString(),
            fix_date: data[i]['date'].toString(),
            fix_time: data[i]['addedTime'].toString(),
            orderstatus: data[i]['status'].toString(),
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img: Images.recieved,
          ));
          debugPrint("data[i]['status'].toString() . / . / . / . / ." + data[i]['status'].toString() + "      " + data[i]['ref'].toString());

          final dataJson = json.encode(data[i]['items']); //fetching categories data
          final dataJsondecode = json.decode(dataJson);
          List itemsdata = [];
          dataJsondecode.asMap().forEach((index, value) =>
              itemsdata.add(dataJsondecode[index] as Map<String, dynamic>)
          );
          for(int j = 0; j < itemsdata.length; j++) {
            var orderType ="";
            if(data[i]['orderType'].toString()=="Delivery"){
              orderType= "Standard Delivery";
            }else {
              orderType= "Express Delivery";
            }
            _itemsreturnvalue.add(OrdersFields(
              referenceid: data[i]['ref'].toString(),
              address: data[i]['address'].toString(),
              customer_name: data[i]['username'].toString(),
              mobile: data[i]['mobileNo'].toString(),
              latitude: data[i]['latitude'].toString(),
              longitude: data[i]['longitude'].toString(),
              returnreason: data[i]['reason'].toString(),
              fix_date: data[i]['date'].toString(),
              fix_time: data[i]['addedTime'].toString(),
              itemname: itemsdata[j]['item'].toString(),
              tax: itemsdata[j]['tax'].toString(),
              itemvar: itemsdata[j]['priceVariavtion'].toString(),
              itemqty: itemsdata[j]['qty'].toString(),
                orderstatus:itemsdata[j]['orderStatus'].toString(),
              orderType:/*data[i]['orderType'].toString()*/orderType,
              otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
              img: Images.recieved,
              //orderstatus: "return",
            ));
          }
        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "delivery": prefs.getString('id'),
            "mode": "2",
          }
      );
      final responseJson = json.decode(response.body);
      print("Return..............");
      print(responseJson);
      if(responseJson.toString() != "[]"){
        /*final dataJson = json.encode(responseJson['data']); //fetching categories data
        final dataJsondecode = json.decode(dataJson);*/


        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );


        for(int i = 0; i < data.length; i++) {
          var orderType ="";
          if(data[i]['orderType'].toString()=="Delivery"){
            orderType= "Standard Delivery";
          }else {
            orderType= "Express Delivery";
          }
          _itemsreturn.add(OrdersFields(
            orderid: data[i]['ref'].toString(),
            address: data[i]['address'].toString(),
            customer_name: data[i]['username'].toString(),
            mobile: data[i]['mobileNo'].toString(),
            latitude: data[i]['latitude'].toString(),
            longitude: data[i]['longitude'].toString(),
            returnreason: data[i]['reason'].toString(),
            fix_date: data[i]['date'].toString(),
            fix_time: data[i]['addedTime'].toString(),
            orderstatus: data[i]['status'].toString(), /*"pickup",*/
            orderType:/*data[i]['orderType'].toString()*/orderType,
            otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
            img: Images.recieved,
          ));

          final dataJson = json.encode(data[i]['items']); //fetching categories data
          final dataJsondecode = json.decode(dataJson);
          List itemsdata = [];
          dataJsondecode.asMap().forEach((index, value) =>
              itemsdata.add(dataJsondecode[index] as Map<String, dynamic>)
          );
          for(int j = 0; j < itemsdata.length; j++) {
            var orderType ="";
            if(data[i]['orderType'].toString()=="Delivery"){
              orderType= "Standard Delivery";
            }else {
              orderType= "Express Delivery";
            }
            _itemsreturnvalue.add(OrdersFields(
              referenceid: data[i]['ref'].toString(),
              address: data[i]['address'].toString(),
              customer_name: data[i]['username'].toString(),
              mobile: data[i]['mobileNo'].toString(),
              latitude: data[i]['latitude'].toString(),
              longitude: data[i]['longitude'].toString(),
              returnreason: data[i]['reason'].toString(),
              fix_date: data[i]['date'].toString(),
              fix_time: data[i]['addedTime'].toString(),
              itemname: itemsdata[j]['item'].toString(),
              itemvar: itemsdata[j]['priceVariavtion'].toString(),
              itemqty: itemsdata[j]['qty'].toString(),
              tax: itemsdata[j]['tax'].toString(),
              orderType:/*data[i]['orderType'].toString()*/orderType,
              otp: (data[i]['otp'].toString() != "null") ? data[i]['otp'].toString() : "0",
              img: Images.recieved,
              //orderstatus: "return",
            ));
          }


        }
      } else {

      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  List<OrdersFields> get returnitems1 {
    return [..._itemsreturn];
  }
 OrdersFields get dashboarditems{
    return _dashboard;
 }
 List<OrdersFields>get recentitems{
    return [..._recentitems];
 }
  List<OrdersFields> findByreturnId(String refid) {
    return [..._recentitems.where((myorder) => myorder.referenceid == refid)];
  }

  Future<void> PickupItems(String orderid,) async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'update-return';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("orderid....................");
    print(orderid);
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "ref": orderid,
            "status": /*"4"*/ "2",
          }
      );
      final responseJson = json.decode(response.body);
      /*if(responseJson.toString() != "[]"){

        List data = []; //list for categories

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>)
        );
        for(int i = 0; i < data.length; i++) {
          _groceryitems.add(OrdersFields(
            itemname: data[i]['itemName'].toString(),
            itemorderid: data[i]['order_d'].toString(),
            itemvar: data[i]['priceVariavtion'].toString(),
            itemqty: data[i]['quantity'].toString(),
            itemamount: data[i]['orderAmount'].toString(),
            itemorderdate: data[i]['orderDate'].toString(),
          ));
        }
      } else {

      }*/
    } catch (error) {
      print(error);
      throw error;
    }
  }
  Future<void> fetchCashLogs() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + /*'wallet/get-logs'*/'wallet/delivery-get-logs';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //try {
      _cashitems.clear();
      final response = await http.post(url, body: {
        "userId": prefs.getString('id'),//PrefUtils.prefs.getString('userID'),
        "type": "0"//(type == "wallet") ? "0" : "3",
        // await keyword is used to wait to this operation is complete.
      });
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      _cashitems.clear();
      debugPrint("walletlog..."+responseJson.toString());
      List data = [];

      responseJson.asMap().forEach((index, value) =>
          data.add(responseJson[index] as Map<String, dynamic>));
      for (int i = 0; i < data.length; i++) {
        if (data[i]['data'].toString() != "[]") {
          final pricevarJson = json.encode(data[i]['data']);
          final pricevarJsondecode = json.decode(pricevarJson);

          var amount;
          var title;
          var img;
          if (double.parse(pricevarJsondecode['credit'].toString()) <= 0) {
            amount = /*"-  " +*/
                PrefUtils.prefs.getString("currency_format") +
                " " +
               /* pricevarJsondecode['debit'].toString()*/
                pricevarJsondecode['credit'].toString()
                /*: amount = "-  " + pricevarJsondecode['debit'].toString()*/;

            title = "Debit";
            img = Images.debitImg;
          } else {
          /*  (type == "wallet")
                ? */amount = /*"+  " +*/
                PrefUtils.prefs.getString("currency_format") +
                " " +
                pricevarJsondecode['credit'].toString()
               /* : amount = "+  " + pricevarJsondecode['credit'].toString()*/;
            title = "Credit";
            img = Images.creditImg;
          }

          _cashitems.add(CashFields(
            title: title,
            date: pricevarJsondecode['date'].toString(),
            time: pricevarJsondecode['datetime'].toString(),
            amount: amount,
            note: pricevarJsondecode['note'].toString() == "null"
                ? ""
                : pricevarJsondecode['note'].toString(),
            closingbalance: pricevarJsondecode['balance'].toString(),
            img: img,
          ));
        }
      }
      notifyListeners();
    /*} catch (error) {
      throw error;
    }*/
  }

  List<CashFields> get cashitems{
    return [..._cashitems];
  }
  Future<void> fetchNotificationLogs(String userId) async {
    // imp feature in adding async is the it automatically wrap into Future.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = IConstants.API_PATH + 'get-notification/$userId/'+'999'
    /* '999'*/ /*prefs.getString("branch")*/;
    _notItems = [];
    try {
      final response = await http.get(
        url,
        /*body: {
            "branch": prefs.getString('branch'),
          }*/
      );
      final responseJson = json.decode(response.body);
      if (response.body == "[]") {
      } else {
        List data = [];

        responseJson.asMap().forEach((index, value) =>
            data.add(responseJson[index] as Map<String, dynamic>));

        int unreadCount = 0;
        for (int i = 0; i < data.length; i++) {
          if (data[i]['status'].toString() == "0") unreadCount++;
          _notItems.add(NotificationFields(
            id: data[i]['id'].toString(),
            status: data[i]['status'].toString(),
            date: data[i]['date'].toString(),
            notificationFor: data[i]['notificationFor'].toString(),
            dateTime: data[i]['dateTime'].toString(),
            data: data[i]['data'].toString(),
            message: data[i]['message'].toString(),
            unreadcount: unreadCount,
          ));
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
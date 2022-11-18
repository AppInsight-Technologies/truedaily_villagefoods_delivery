
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../constants/Iconstants.dart';
import '../../utils/prefUtils.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../generated/i18n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../../src/elements/DrawerWidget.dart';
import '../../src/elements/OrderItemWidget.dart';
import '../../providers/ordersitems.dart';
import '../../src/controllers/order_details_controller.dart';
import '../../src/elements/ShoppingCartButtonWidget.dart';



import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ReturnsWidget extends StatefulWidget {
  RouteArgument routeArgument;


  ReturnsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ReturnsWidgetState createState() {
    return _ReturnsWidgetState();
  }
}

class _ReturnsWidgetState extends StateMVC<ReturnsWidget> {
  OrderDetailsController _con;
  bool _isloading = true;
  String _orderid = "";
  String _orderstatus = "";
  String _paymenttype = "";
  String _orderamount = "";
  String _fixdate = "";
  String _fixtime = "";
  String _customername = "";
  String _address = "";
  String _actualamount = "";
  String _deliverycharge = "";
  String _mobile = "";
  double _latitude = 0.0;
  double _longitude = 0.0;
  var returnData;
  String itemcount = "";
  int _index;
  var ordersData;
  var currency_format = "";

  _ReturnsWidgetState() : super(OrderDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    _orderid = widget.routeArgument.id;
    _orderstatus = widget.routeArgument.orderstatus;
    _paymenttype = widget.routeArgument.payment_type;
    _orderamount = widget.routeArgument.order_amount;
    _fixdate = widget.routeArgument.fix_date;
    _fixtime = widget.routeArgument.fix_time;
    _customername = widget.routeArgument.customer_name;
    _address = widget.routeArgument.address;
    _actualamount = widget.routeArgument.actual_amount;
    _deliverycharge = widget.routeArgument.delivery_charge;
    _index = widget.routeArgument.index;

    Future.delayed(Duration.zero, () async{
      await Provider.of<OrdersItemsList>(context,listen:false).Login();
      await  Provider.of<OrdersItemsList>(context,listen:false).GetRestaurant().then((value) {
        currency_format= PrefUtils.prefs.getString("currency_format");
        debugPrint("dxfcgvbhjn....."+currency_format);

      } );
      Provider.of<OrdersItemsList>(context,listen:false).GetItems(_orderid).then((
          _) async {
        setState(() {
          _isloading = false;
          ordersData = Provider.of<OrdersItemsList>(context,listen:false);
          itemcount = ordersData.orderitems.length.toString();
          _mobile = ordersData.orderitems[0].mobile;
          _latitude = double.parse(ordersData.orderitems[0].latitude);
          _longitude = double.parse(ordersData.orderitems[0].longitude);
         /* returnData = Provider.of<OrdersItemsList>(context,listen:false).findByreturnId(_orderid);
          itemcount = returnData.length.toString();

          _mobile = returnData[0].mobile;
          _latitude = double.parse(returnData[0].latitude);
          _longitude = double.parse(returnData[0].longitude);*/
        });
      }); // only create the future once.
    });

    super.initState();
  }

  _dialogforDelivered(BuildContext context) {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                      height: 100.0,
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 40.0,),
                          Text('Processing...'),
                        ],
                      )
                  ),
                );
              }
          );
        });
  }

  _dialogforProcessing() {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AbsorbPointer(
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          );
        });
  }

  Future<void> acceptOrder() async { // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-status';
    try {
      final response = await http
          .post(
          url,
          body: { // await keyword is used to wait to this operation is complete.
            "id": _orderid,
            "status": "10",
            //"mobile": _mobile,
          }
      );
      final responseJson = json.decode(response.body);
      debugPrint(responseJson.toString());
      if(responseJson['status'].toString() == "200") {
        Fluttertoast.showToast(msg: "Accepted successfully!", backgroundColor: Colors.black87, textColor: Colors.white);
        final returnData1 = Provider.of<OrdersItemsList>(context,listen:false);
        setState(() {
          for(int i = 0; i < returnData1.returnitems.length; i++){
            if(i == _index) {
              returnData1.returnitems[i].orderstatus = "2";
            }
          }
          _orderstatus = "2";
        });

      } else {
        Fluttertoast.showToast(msg: "Something went wrong!", backgroundColor: Colors.black87, textColor: Colors.white);
      }
      Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Something went wrong!", backgroundColor: Colors.black87, textColor: Colors.white);
      print(error);
      throw error;
    }
  }


  performDelivered() {
    Provider.of<OrdersItemsList>(context,listen:false).PickupItems(_orderid).then((
        _) async {
      setState(() {
        final returnData1 = Provider.of<OrdersItemsList>(context,listen:false);
        for(int i = 0; i < returnData1.returnitems.length; i++){
          if(i == _index) {
            returnData1.returnitems[i].orderstatus = "4"/*"pickup"*/;
          }
        }
        _orderstatus = "4";
        Navigator.pop(context);
        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Pickup Successfully"),
        ));
        print("Done............");
      });
    });
  }

  static Future<void> openMap(double latitude, double longitude) async {
    print("Latitude............" + latitude.toString());
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
   // final returnData = Provider.of<OrdersItemsList>(context,listen:false).findByreturnId(_orderid);
    ordersData = Provider.of<OrdersItemsList>(context,listen:false);
    /*debugPrint("_orderstatus ....... " + _orderstatus);
    debugPrint("_orderid . . . . " + _orderid);*/

    return Scaffold(
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: /*Theme.of(context).hintColor*/Colors.white),
          onPressed: () => /*_con.scaffoldKey.currentState.openDrawer()*/Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: /*Colors.transparent*/Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).order_details,
          style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(letterSpacing: 1.3,color: Colors.white)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
        body: _isloading
            ? CircularLoadingWidget(height: 500)
            : Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
            //  margin: EdgeInsets.only(bottom: _orderstatus == '4' ? 0 : 80),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                   /* Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).focusColor.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _orderstatus == '4'
                              ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 32,
                            ),
                          )
                              : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).hintColor.withOpacity(0.1)),
                            child: Icon(
                              Icons.update,
                              color: Theme.of(context).hintColor.withOpacity(0.8),
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Reference Id:" + "#${_orderid}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.subhead,
                                      ),
                                      *//*Text(
                                        _paymenttype,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.caption,
                                      ),*//*
                                      Text(
                                        _fixtime,
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    //Helper.getPrice(double.parse(_orderamount), style: Theme.of(context).textTheme.display1),
                                    //Text("AED " + _orderamount, style: Theme.of(context).textTheme.display1),
                                    Text(
                                      'Items: ' + itemcount,
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 5,
                              offset: Offset(0, 5)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          /* _orderstatus == 'delivered'
                                    ? Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                                        child: Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                          size: 32,
                                        ),
                                      )
                                    : Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).hintColor.withOpacity(0.1)),
                                        child: Icon(
                                          Icons.update,
                                          color: Theme.of(context).hintColor.withOpacity(0.8),
                                          size: 30,
                                        ),
                                      ),*/
                          SizedBox(width: 15),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Reference Id:" + "#${_orderid}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.0, fontWeight: FontWeight.w600,),
                                      ),
                                      /*Text(
                                              _paymenttype,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.caption,
                                            ),*/
                                      Text(
                                        _fixtime,
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    //Helper.getPrice(double.parse(_orderamount), style: Theme.of(context).textTheme.display1),
                                  //  Text(currency_format + _orderamount, style: Theme.of(context).textTheme.display1),
                                    Text(
                                      'Items: ' + itemcount,
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                   /* Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.person_pin,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Customer',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    ordersData.orderitems[0].customer_name,
                                    style: TextStyle(color: Colors.black,fontSize: 16.0, fontWeight: FontWeight.w600,),
                                  ),
                                ),
                                SizedBox(width: 20),
                                /* SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: FlatButton(
                                          padding: EdgeInsets.all(0),
                                          disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                          //onPressed: () {
//                                    Navigator.of(context).pushNamed('/Profile',
//                                        arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                          //},
                                          child: Icon(
                                            Icons.person,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),
                                          color: Theme.of(context).accentColor.withOpacity(0.9),
                                          shape: StadiumBorder(),
                                        ),
                                      ),*/
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _address,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                                    onPressed: () {
                                      /*Navigator.of(context).pushNamed('/Map',
                                          arguments: new RouteArgument(param: _address));*/
                                      openMap(_latitude, _longitude);
                                    },
                                    child: /*Icon(
                                            Icons.directions,
                                            color: Theme.of(context).primaryColor,
                                            size: 24,
                                          ),*/
                                    Image.asset( "assets/img/direction.png",
                                      color: Theme.of(context).accentColor,
                                      width: 22,
                                      height:22,
                                      //fit: BoxFit.fill,
                                    ),
                                    color: /*Theme.of(context).accentColor.withOpacity(0.9)*/Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _mobile,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      launch("tel: " + _mobile);
                                    },
                                    child:   Image.asset( "assets/img/call.png",
                                      width: 22,
                                      height:22,
                                      //fit: BoxFit.fill,
                                    ),
                                    color: /*Theme.of(context).accentColor.withOpacity(0.9)*/Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                   /* Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _customername,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                              //onPressed: () {
//                                    Navigator.of(context).pushNamed('/Profile',
//                                        arguments: new RouteArgument(param: _con.order.deliveryAddress));
                              //},
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context).accentColor.withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _address,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              disabledColor: Theme.of(context).focusColor.withOpacity(0.4),
                              onPressed: () {
                                openMap(_latitude, _longitude);
                              },
                              child: Icon(
                                Icons.directions,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context).accentColor.withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _mobile,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                launch("tel: " + _mobile);
                              },
                              child: Icon(
                                Icons.call,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context).accentColor.withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10,top:5),
                      child:/* ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.fastfood,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          "Return items",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),*/
                      Row(
                        children: [
                          /* Icon(
                                  Icons.fastfood,
                                  color: Theme.of(context).hintColor,
                                ),*/
                          Image.asset( "assets/img/order.png",
                            width: 22,
                            height:22,
                            //fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "Return items",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    ListView.separated(
                      padding: EdgeInsets.only(bottom: 10,left: 20,right: 20),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: ordersData.orderitems.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return /*OrderItemWidget(
                          heroTag: 'my_orders',
                          itemname: returnData[index].itemname,
                          itemvar: returnData[index].itemvar,
                          itemqty: returnData[index].itemqty,
                          itemamount: "",
                          itemorderdate: returnData[index].fix_time,
                          order: _con.order,
                        )*/
                          InkWell(
                            splashColor: Theme.of(context).accentColor,
                            focusColor: Theme.of(context).accentColor,
                            highlightColor: Theme.of(context).primaryColor,
                            onTap: () {
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 15),
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                          imageUrl: ordersData.orderitems[index].imageurl,
                                          placeholder: (context, url) => Image.asset(
                                            'assets/img/defaultImg.png',
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                          ),
                                          errorWidget: (context, url, error) => /*Icon(Icons.error)*/Image.asset(
                                            'assets/img/defaultImg.png',
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ordersData.orderitems[index].itemname,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.subtitle1,
                                              ),
                                              Text(
                                                ordersData.orderitems[index].itemvar,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                              Text(
                                                'Quantity: ${ordersData.orderitems[index].itemqty}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                      },
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height:  150, //177:230
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      /*decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).focusColor.withOpacity(0.15),
                                      offset: Offset(0, -2),
                                      blurRadius: 5.0)
                                ]),*/
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      S.of(context).subtotal,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                ),
                                //Helper.getPrice(double.parse(_actualamount), style: Theme.of(context).textTheme.subhead)
                                Text(currency_format + ordersData.orderitems[0].actual_amount,  style:TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                              ],
                            ),
                              SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Delivery charge",
                                      style:  TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                ),
                                //Helper.getPrice(double.parse(_deliverycharge), style: Theme.of(context).textTheme.subhead)
                                Text(currency_format + ordersData.orderitems[0].delivery_charge, style:  TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                              ],
                            ),
                            SizedBox(height: 10,),
                            DottedLine(
                              direction: Axis.horizontal,
                              dashColor: Colors.grey,
                            ),
                            SizedBox(height: 10,),
                            //Divider(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ),
                                //Helper.getPrice(double.parse(_orderamount), style: Theme.of(context).textTheme.title)
                                Text(currency_format + ordersData.orderitems[0].order_amount, style: Theme.of(context).textTheme.subtitle2),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           /* Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if( _orderstatus != '4' && _orderstatus == '2')
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Container(
                        margin: EdgeInsets.only(left: 40.0, right: 0.0,  bottom: 20.0),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Pickup Confirmation"),
                                    content: Text(S
                                        .of(context)
                                        .return_confir),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      FlatButton(
                                        child: new Text(S.of(context).confirm),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _dialogforDelivered(context);
                                          performDelivered();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text(S.of(context).dismiss),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Text(
                            "Pickup",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  *//*  if(_orderstatus != '4' && _orderstatus =='1' )
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                          child: Container(
                            margin: EdgeInsets.only(left: 40.0, right: 0.0, bottom: 20.0),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(S.of(context).delivery_confirmation),
                                    content: Text(S.of(context).would_you_please_confirm_if_you_are_accepting_this_order),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      FlatButton(
                                        child: new Text(S.of(context).confirm),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _dialogforProcessing();
                                          acceptOrder();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text(S.of(context).dismiss),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Text(
                            "Accept Order",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
    )
                      ),*//*

                  ],
                ),
              ),
            )*/
          ],
        ),
      bottomNavigationBar:_orderstatus == '4'?SizedBox.shrink():_isloading?SizedBox.shrink():_buildBottomNavigationBar(),
    );
  }
  _buildBottomNavigationBar() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if( _orderstatus != '4' && _orderstatus == '2')
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pickup Confirmation"),
                          content: Text(S
                              .of(context)
                              .would_you_please_confirm_if_you_have_delivered_all_meals),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: new Text(S.of(context).confirm),
                              onPressed: () {
//                                                        _con.doDeliveredOrder(_con.order);
                                Navigator.of(context).pop();
                                _dialogforDelivered(context);
                                performDelivered();
                                // Navigator.of(context).pop();

                              },
                            ),
                            FlatButton(
                              child: new Text(S.of(context).dismiss),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Theme.of(context).accentColor,
                //shape: StadiumBorder(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                   "Pickup",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if(_orderstatus != '4' && _orderstatus =='1' )
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S.of(context).delivery_confirmation),
                          content: Text(S.of(context).would_you_please_confirm_if_you_are_accepting_this_order),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: new Text(S.of(context).confirm),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _dialogforProcessing();
                                acceptOrder();
                              },
                            ),
                            FlatButton(
                              child: new Text(S.of(context).dismiss),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                padding: EdgeInsets.symmetric(vertical: 14),
                color: Theme.of(context).accentColor,
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Accept Order",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

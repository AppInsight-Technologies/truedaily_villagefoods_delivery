
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/Iconstants.dart';
import '../../utils/prefUtils.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/i18n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../../src/elements/DrawerWidget.dart';
import '../../src/elements/OrderItemWidget.dart';
import '../../src/elements/ShoppingCartButtonWidget.dart';
import '../../providers/ordersitems.dart';
import '../../src/controllers/order_details_controller.dart';



import 'package:http/http.dart' as http;
import 'dart:convert';


class OrderWidget extends StatefulWidget {
  RouteArgument routeArgument;


  OrderWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends StateMVC<OrderWidget> {
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
  String _totaldiscount = "";
  String _mobile = "";
  double _latitude = 0.0;
  double _longitude = 0.0;
  var ordersData;
  String itemcount = "";
  int _index;
  bool _isCheckbox = false;
  var _message = TextEditingController();
  String _itemTotal = "0";
  String _vatTotal = "0";
  var currency_format = "";
  TextEditingController _controller = TextEditingController();
  var otpvalue = "";
  String _otp = "";
  int _groupValue = 0;
  int _groupValue1 = 0;
  final _form = GlobalKey<FormState>();
  TextEditingController _ReceiverText;
  String mode;
  String _fromScreen;

  _OrderWidgetState() : super(OrderDetailsController()) {
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
    _totaldiscount = widget.routeArgument.total_discount;
    _index = widget.routeArgument.index;
    _otp = widget.routeArgument.otp;
    _fromScreen = widget.routeArgument.fromScreen;
   // debugPrint("_orderstatus.......... " + _orderstatus.toString());
    _ReceiverText = TextEditingController();
    Future.delayed(Duration.zero, () async {
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
          _orderstatus = ordersData.orderitems[0].orderstatus.toString().toLowerCase();
          _paymenttype = ordersData.orderitems[0].payment_type;
          _orderamount = ordersData.orderitems[0].order_amount;
          _fixdate = ordersData.orderitems[0].fix_date;
          _fixtime = ordersData.orderitems[0].fix_time;
          _customername = ordersData.orderitems[0].customer_name;
          _address = ordersData.orderitems[0].address;
          _actualamount = ordersData.orderitems[0].actual_amount;
          _deliverycharge = ordersData.orderitems[0].delivery_charge;
          _totaldiscount = ordersData.orderitems[0].total_discount;
          print("Discount charge..."+_totaldiscount.toString());
          _index = widget.routeArgument.index;
          _otp = ordersData.orderitems[0].otp;
          debugPrint("status...."+_orderstatus.toString());

        });
      });
      if(_fromScreen=="pushNotification") {
        Provider.of<OrdersItemsList>(context, listen: false).GetOrders("0").then((_) {
          setState(() {
            ordersData = Provider.of<OrdersItemsList>(context, listen: false);
            for (int i = 0; i < ordersData.items.length; i++) {
              if (ordersData.items[i].orderid == _orderid) {
                _index = i;
              }
            }
          });
        });
      }
     // only create the future once.
    });

    super.initState();
  }

  void showmodalbottoms(i) {
    _groupValue = /*ordersData.orderitems[i].indexvalue*/0;
    print('details');

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft: Radius.circular(20.0)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // VerticalDivider(),
                      Text('Issue', style: TextStyle(fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _groupValue = 0;
                              });
                            },
                            child: Row(
                              children: [
                                _groupValue == 0 ?
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: Theme
                                            .of(context)
                                            .accentColor,
                                        size: 15.0),
                                  ),
                                )
                                    :
                                Icon(
                                    Icons.radio_button_off_outlined,
                                    color: Theme
                                        .of(context)
                                        .accentColor),

                                /*   Radio(
                          value: 0,
                          groupValue: _groupValue,
                          onChanged: (value) =>
                              setState(() {
                                _groupValue = value;
                                debugPrint("111"+_groupValue.toString());
                              }),
                        ),*/
                                SizedBox(width:10,),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1 - 60,
                                  //padding: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.white,
                                  child: Form(
                                    key: _form,
                                    child: TextFormField(
                                      controller: _ReceiverText,
                                      minLines: 2,
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: ' Describe the Issue',
                                        hintStyle: TextStyle(fontSize: 14,color: Colors.grey),
                                        contentPadding: EdgeInsets.all(2),
                                        fillColor: Colors.green,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                              color: Colors.grey),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                              color: Colors.green),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                              color: Colors.green),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide:
                                          BorderSide(
                                              color: Colors.green, width: 1.2),
                                        ),
                                      ),
                                     onTap: (){
                                        setState((){
                                          _groupValue=0;
                                        });
                                     },
                                      /*decoration: InputDecoration(
                                      hintText: "Receiver’s Name*",
                                      contentPadding: EdgeInsets.all(5),
                                      border: OutlineInputBorder(),
                                    ),*/
                                      /*   validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Receiver’s Name';
                                      }
                                      return null;
                                    },*/
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*  Radio(
                          value: 1,
                          groupValue: _groupValue,
                          onChanged: (value) =>
                              setState(() {
                                _groupValue = value;
                                debugPrint("111"+_groupValue.toString());
                              }),
                        ),*/
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _groupValue = 1;
                              });
                            },
                            child: Row(
                              children: [
                                _groupValue == 1 ?
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: Theme
                                            .of(context)
                                            .accentColor,
                                        size: 15.0),
                                  ),
                                )
                                    :
                                Icon(
                                    Icons.radio_button_off_outlined,
                                    color: Theme
                                        .of(context)
                                        .accentColor),
                                SizedBox(width : 10,),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    // color:Color(0xFFF5F7F8),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Customer not available", //"Wrong item price",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text('Action Taken', style: TextStyle(fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 5),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          dashColor: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [],
                      ),
                      // _myRadioButton(
                      //     title: Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             width: MediaQuery.of(context).size.width/2-40,
                      //             //padding: EdgeInsets.symmetric(horizontal: 10),
                      //             color:Colors.white,
                      //             child: Form(
                      //               key: _form,
                      //               child: TextFormField(
                      //                 controller: _ReceiverText,
                      //                 minLines: 3,
                      //                 maxLines: 5,
                      //                 decoration: InputDecoration(
                      //                   hintText: 'Please describe the issue ',
                      //                   contentPadding: EdgeInsets.all(5),
                      //                   fillColor: Colors.green,
                      //                   enabledBorder: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(6),
                      //                     borderSide: BorderSide(color: Colors.grey),
                      //                   ),
                      //                   errorBorder: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(6),
                      //                     borderSide: BorderSide(color: Colors.green),
                      //                   ),
                      //                   focusedErrorBorder: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(6),
                      //                     borderSide: BorderSide(color: Colors.green),
                      //                   ),
                      //                   focusedBorder: OutlineInputBorder(
                      //                     borderRadius: BorderRadius.circular(6),
                      //                     borderSide:
                      //                     BorderSide(color: Colors.green, width: 1.2),
                      //                   ),
                      //                 ),
                      //                 /*decoration: InputDecoration(
                      //                   hintText: "Receiver’s Name*",
                      //                   contentPadding: EdgeInsets.all(5),
                      //                   border: OutlineInputBorder(),
                      //                 ),*/
                      //              /*   validator: (value) {
                      //                   if (value == null || value.isEmpty) {
                      //                     return 'Please Enter Receiver’s Name';
                      //                   }
                      //                   return null;
                      //                 },*/
                      //               ),
                      //             ),
                      //           ),
                      //       /*    Text(
                      //             "No Issues",
                      //             style: TextStyle(
                      //                 color: Colors.black87,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.w600),
                      //           ),
                      //           Text('No problem with the existing product',
                      //               style: TextStyle(
                      //                   color: Colors.grey,
                      //                   fontSize: 15,
                      //                   fontWeight: FontWeight.w400))*/
                      //         ]),
                      //     value: 0,
                      //     i: i,
                      //     onChanged: (newValue) {
                      //       Future.delayed(Duration.zero, () async {
                      //         setState(() {
                      //           _groupValue = newValue;
                      //          // ordersData.orderitems[i].selectedreason =
                      //          // 'No Problem';
                      //           print('11');
                      //           print(_groupValue);
                      //          // ordersData.orderitems[i].indexvalue = newValue;
                      //         });
                      //       });
                      //      // Navigator.pop(context);
                      //     }),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      /* Container(
                      child: Text('DESCRIBE THE PROBLEM'),
                    ),

                       */
                    SizedBox(
                      height: 10,
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reschedule Order",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _groupValue1 = 0;
                              });
                            },
                            child: Column(
                              children: [
                                _groupValue1 == 0 ?
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: Theme
                                            .of(context)
                                            .accentColor,
                                        size: 15.0),
                                  ),
                                )
                                    :
                                Icon(
                                    Icons.radio_button_off_outlined,
                                    color: Theme
                                        .of(context)
                                        .accentColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cancel Order",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _groupValue1 = 1;
                              });
                            },
                            child: Column(
                              children: [
                                _groupValue1 == 1 ?
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check,
                                        color: Theme
                                            .of(context)
                                            .accentColor,
                                        size: 15.0),
                                  ),
                                )
                                    :
                                Icon(
                                    Icons.radio_button_off_outlined,
                                    color: Theme
                                        .of(context)
                                        .accentColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /*  _myRadioButton(
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rescheduled Order",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                           */ /* Text(
                              'Item is not on the shelf',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )*/ /*
                          ]),
                      value: 2,
                      i: i,
                      onChanged: (newValue) {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            _groupValue = newValue;
                            print('33');
                           // ordersData.orderitems[i].selectedreason =
                          //  'Out Of Stock';
                            print(_groupValue);
                          //  ordersData.orderitems[i].indexvalue = newValue;
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),*/
                      /*    _myRadioButton(
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cancel Order",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                         */ /*   Text(
                              'Item is in a bad condition',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )*/ /*
                          ]),
                      value: 3,
                      i: i,
                      onChanged: (newValue) {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            _groupValue = newValue;
                            print('44');
                           // ordersData.orderitems[i].selectedreason =
                           // 'Poor Quality';
                            print(_groupValue);
                           // ordersData.orderitems[i].indexvalue = newValue;
                          });
                        });
                      //  Navigator.pop(context);
                      },
                    ),*/
                      /*  _myRadioButton(
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Not the Right Size",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            Text(
                              'There is no ordered item size ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )
                          ]),
                      value: 4,
                      i: i,
                      onChanged: (newValue) {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            _groupValue = newValue;
                           // ordersData.orderitems[i].selectedreason =
                           // 'Not the Right Size';
                            print('55');
                            print(_groupValue);
                          //  ordersData.orderitems[i].indexvalue = newValue;
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),*/
                      /*   _myRadioButton(
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Not the right quantity",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            Text('Their is not enough items in stock',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400))
                          ]),
                      value: 5,
                      i: i,
                      onChanged: (newValue) {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            _groupValue = newValue;
                            print('66');
                           // ordersData.orderitems[i].selectedreason =
                          //  'Not the Right Quantity';
                            print(_groupValue);
                          //  ordersData.orderitems[i].indexvalue = newValue;
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),*/
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 50,
                        child: FlatButton(
                          onPressed: () {
                            if(_groupValue==0) {
                              if (_ReceiverText.text == "" || _ReceiverText.text == "null") {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Description",
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white);
                              }else{
                                _dialogforProcessing();
                                cancelOrder();
                              }
                            }else{
                                _dialogforProcessing();
                                cancelOrder();
                              }
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme
                              .of(context)
                              .accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "SAVE",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Theme
                                .of(context)
                                .primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
  Widget _myRadioButton({Column title, int value, Function onChanged, int i}) {
    print(i);
    print('1221122121121');
    //final ordersData = Provider.of<OrdersItemsList>(context);
    print('22222222222');
    Future.delayed(Duration.zero, () async {
      print('9999999');
      print(_groupValue);

      if (_groupValue == 1) {
        print('111111111111111111111111111111');
        setState(() {
        /*  ordersData.orderitems[i].selectedreason = 'Wrong item price';
          print('o..hellooo');
          print('o..hellooo');
          debugPrint(ordersData.orderitems[i].selectedreason);
          print('o..hellooo');*/
        });
        /*prefs.setString("returning_reason", "Wrong item was sent");*/
      }
      else if (_groupValue == 2) {
        print('11111111111111111111111111222222221');
        setState(() {
         // ordersData.orderitems[i].selectedreason = 'Out of stock';
         // debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
      else if (_groupValue == 0) {
        print('111111111111111111111133333333331');
        setState(() {
          //ordersData.orderitems[i].selectedreason = 'No Problem';
         // debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
      else if (_groupValue == 3) {
        print('11111111111111111444444444444444441111');
        setState(() {
         // ordersData.orderitems[i].selectedreason = 'Poor Quality';
         // debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
      else if (_groupValue == 4) {
        print('111111111111111115555555555555555111111');
        setState(() {
         // ordersData.orderitems[i].selectedreason = 'Not the Right Size';
         // debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
      else if (_groupValue == 5) {
        print('11111111111111166666666666666611111');
        setState(() {
          //ordersData.orderitems[i].selectedreason = 'Not the Right Quantity';
         // debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
      else {
        setState(() {
        //  ordersData.orderitems[i].selectedreason = 'None of the above';
          debugPrint(ordersData.orderitems[i].selectedreason);
        });
      }
    });
    print('000000000');
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title],
      ),
    );
  }
  _dialogforOTP() {
    return showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)
                  ),
                  child: Container(
                    height: 210.0,
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Text('Enter the 4-digit code sent to the customer', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20.0,),
                        Center(
                          child: PinCodeTextField(
                            controller: _controller,
                            highlight: true,
                            highlightColor: Color(0xff00BD6D),
                            defaultBorderColor: Colors.grey,
                            hasTextBorderColor: Colors.grey,
                            maxLength: 4,
                            pinBoxWidth: 55.0,
                            pinBoxHeight: 55.0,
                            onTextChanged: (text) {
                              setState(() {
                                //hasError = false;
                              });
                            },
                            onDone: (text){
                              setState(() {
                                otpvalue = text;
                              });
                              print("DONE $text");
                            },
                            wrapAlignment: WrapAlignment.spaceAround,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        FlatButton(
                          onPressed: () {
                            if(otpvalue.length == 4) {
                              debugPrint("otp ----" + _otp.toString());
                              debugPrint("otp ----" + otpvalue.toString());
                              debugPrint("ordersData.orderitems[0].otp . . . .. " + ordersData.orderitems[0].otp);
                              /*if(_otp == otpvalue) {*/
                              if(ordersData.orderitems[0].otp == otpvalue) {
                                Navigator.of(context).pop();
                                _dialogforDelivered(context);
                                performDelivered();
                              } else {
                                Fluttertoast.showToast(msg: "Please enter a valid otp", backgroundColor: Colors.black87, textColor: Colors.white);
                              }
                            } else {
                              Fluttertoast.showToast(msg: "Please enter a valid otp", backgroundColor: Colors.black87, textColor: Colors.white);
                            }
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          color: Color(0xff00BD6D),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        });
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

  performDelivered() {
    Provider.of<OrdersItemsList>(context,listen:false).DeliveredItems(_orderid, _mobile).then((
        _) async {
      setState(() {
        for(int i = 0; i < ordersData.items.length; i++){
          if(i == _index) {
            ordersData.items[i].orderstatus = "delivered";
          }
        }
        _orderstatus = "delivered";
        Navigator.pop(context);
        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Delivered Successfully"),
        ));
       // Navigator.of(context).pushNamed('/Pages', arguments: 1);
        print("Done............");
      });
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
                    child: CircularProgressIndicator(color: Theme.of(context).accentColor,),
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
            "status": "1",
            "mobile": _mobile,
          }
      );
      final responseJson = json.decode(response.body);
      debugPrint(responseJson.toString());
      if(responseJson['status'].toString() == "200") {
        Fluttertoast.showToast(msg: "Accepted successfully!", backgroundColor: Colors.black87, textColor: Colors.white);
        setState(() {
          for(int i = 0; i < ordersData.items.length; i++){
            if(i == _index) {
              ordersData.items[i].orderstatus = "onway";
            }
          }
          _orderstatus = "onway";
        });
        Navigator.of(context).pop();

      } else {
        _isCheckbox = !_isCheckbox;
        Fluttertoast.showToast(msg: "Something went wrong!", backgroundColor: Colors.black87, textColor: Colors.white);
      }
    } catch (error) {
      _isCheckbox = !_isCheckbox;
      Fluttertoast.showToast(msg: "Something went wrong!", backgroundColor: Colors.black87, textColor: Colors.white);
      print(error);
      throw error;
    }
  }

  Future<void> cancelOrder() async {
    // imp feature in adding async is the it automatically wrap into Future.
    var url = IConstants.API_PATH + 'restaurant/delivery-boy-status';
     if(_groupValue1==0){
        mode='5';
     }else{
         mode='6';
     }
     if(_groupValue==0){

     }
    try {
      final response = await http.post(url, body: {
        // await keyword is used to wait to this operation is complete.
        "id": _orderid,
        "slotReason": _groupValue==0?_ReceiverText.text:"customer not available",/*_message.text*/
        'status':/*'5'*/_groupValue1==0?"5":"6",
      });
      final responseJson = json.decode(response.body);
      debugPrint(responseJson.toString());
      Navigator.pop(context);
      Navigator.pop(context);
      if (responseJson['status'].toString() == "200") {
        Navigator.of(context).pushNamed('/Pages', arguments: 1);

      } else {
        return Fluttertoast.showToast(msg: "Something went wrong!!!");
      }
    } catch (error) {
      Navigator.pop(context);
      //Navigator.pop(context);
      Fluttertoast.showToast(msg: "Something went wrong!!!");
      throw error;
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    print("Latitude............" + latitude.toString());
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    //if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    //}
    // else {
    //   throw 'Could not open the map.';
    // }
  }
  _dialogforCancel(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
              ),
               child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250.0,
                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 9.0,
                      ),
                  Text(
                                          "Order ID: " + _orderid,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          //hintText: "Reasons",
                          labelText: 'Please describe the issue ',labelStyle: TextStyle(fontSize: 12,color: Colors.grey),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                        ),
                        minLines: 3,
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          _dialogforProcessing();
                          cancelOrder();
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                   )
            ),
            );
           });
        });
  }
  // _dialogforCancel(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(3.0)),
  //             child: Container(
  //                 height: 250.0,
  //                 padding: EdgeInsets.only(left: 10.0, right: 10.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     SizedBox(
  //                       height: 10.0,
  //                     ),
  //                     Text(
  //                       "Order ID: " + _orderid,
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18.0),
  //                     ),
  //                     SizedBox(
  //                       height: 10.0,
  //                     ),
  //                     TextField(
  //                       controller: _message,
  //                       decoration: InputDecoration(
  //                         //hintText: "Reasons",
  //                         labelText: 'Please describe the issue ',labelStyle: TextStyle(fontSize: 12,color: Colors.grey),
  //                         contentPadding: EdgeInsets.all(10),
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       minLines: 3,
  //                       maxLines: 5,
  //                     ),
  //                     SizedBox(
  //                       height: 10.0,
  //                     ),
  //                     FlatButton(
  //                       onPressed: () {
  //                         _dialogforProcessing();
  //                         cancelOrder();
  //                       },
  //                       child: Text(
  //                         "Next",
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.green
  //                         ),
  //                       ),
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                   ],
  //                 )),
  //           );
  //         });
  //       });
  // }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersItemsList>(context,listen:false);




    return Scaffold(
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
        backgroundColor: Colors.white,
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
            ? CircularLoadingWidget(height: 500,)
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                   // margin: EdgeInsets.only(bottom: _orderstatus == 'delivered' ? 147 : 230),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
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
                                              S.of(context).order_id +" "+"#${_orderid}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.0, fontWeight: FontWeight.w600,),
                                            ),
                                            Text(
                                              _paymenttype,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(color: Colors.black,fontSize: 18.0, fontWeight: FontWeight.w600,),
                                            ),
                                            Text(
                                              /*_fixdate + " " +*/ _fixtime,
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
                                          Text(currency_format + _orderamount, style: Theme.of(context).textTheme.headline4),
                                          SizedBox(height: 5,),
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
                                          _customername,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10,top:5),
                            child: /*ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.fastfood,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).grocery_ordered,
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
                                  S.of(context).grocery_ordered,
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
                              return OrderItemWidget(
                                 imageurl: ordersData.orderitems[index].imageurl,
                                  itemname: ordersData.orderitems[index].itemname,
                                  itemvar: ordersData.orderitems[index].itemvar,
                                  itemqty: ordersData.orderitems[index].itemqty,
                                  itemamount: ordersData.orderitems[index].itemamount,
                                  itemorderdate: ordersData.orderitems[index].itemorderdate,
                                  itemTax: ordersData.orderitems[index].tax,
                                  //order: _con.order,
                                  );
                            },
                          ),
                          SizedBox(height:10),
                          Container(
                            height: _orderstatus == 'delivered' ? 150 : 150, //177:230
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
                                      Text(currency_format + _actualamount,  style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                    ],
                                  ),
                                  if(double.parse(_vatTotal) > 0)SizedBox(height: 5),
                                  if(double.parse(_vatTotal) > 0)
                                  /*Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Vat",
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                                //Helper.getPrice(double.parse(_actualamount), style: Theme.of(context).textTheme.subhead)
                                Text("Rs. " + _vatTotal, style: Theme.of(context).textTheme.subhead),
                              ],
                            ),*/
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
                                      Text(currency_format + _deliverycharge, style:  TextStyle(
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
                                            "Discount",
                                            style:  TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black,
                                            )),
                                      ),
                                      //Helper.getPrice(double.parse(_deliverycharge), style: Theme.of(context).textTheme.subhead)
                                      Text("-"+currency_format + _totaldiscount, style:  TextStyle(
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
                                      Text(currency_format + _orderamount, style: Theme.of(context).textTheme.subtitle2),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                /*  Row(
                                    children: [
                                      if(_orderstatus != 'delivered' && _orderstatus == 'onway')
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.43,
                                          child: FlatButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(S.of(context).delivery_confirmation),
                                                      content: Text(S
                                                          .of(context)
                                                          .would_you_please_confirm_if_you_have_delivered_all_meals),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        FlatButton(
                                                          child: new Text(S.of(context).confirm),
                                                          onPressed: () {
//                                                        _con.doDeliveredOrder(_con.order);
                                                          debugPrint("otp...."+IConstants.isOtp.toString());
                                                            Navigator.of(context).pop();
                                                            if(IConstants.isOtp){
                                                              _dialogforOTP();
                                                            }else{
                                                               _dialogforDelivered(context);
                                                                performDelivered();
                                                            }
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
                                              S.of(context).delivered,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                    //  if(_orderstatus != 'delivered' && _orderstatus == 'onway')
                                        SizedBox(width: 10,),
                                      if(_orderstatus != 'delivered' && _orderstatus == 'onway')
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.43,
                                          child: FlatButton(
                                            onPressed: () {
                                             // _dialogforCancel(context);
                                              showmodalbottoms(0);
                                              *//*                showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(S.of(context).delivery_confirmation),
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
                                                  _dialogforProcessing();
                                                  _dialogforCancel(context);
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
                                        });*//*
                                            },
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            color:*//* Theme.of(context).accentColor*//*Colors.white,
                                           // shape: StadiumBorder(),
                                            shape:RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: BorderSide(width:1.0,color:Theme.of(context).accentColor, )
                                            ),
                                            child: Text(
                                              S.of(context).issue,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),*/





                                 /* if(_orderstatus != 'delivered' && _orderstatus == 'dispatched')
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
                                  SizedBox(height: 10),*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar:_orderstatus == 'delivered'?SizedBox.shrink():_isloading?SizedBox.shrink():_buildBottomNavigationBar(),
    );
  }
  _buildBottomNavigationBar() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(_orderstatus != 'delivered' && _orderstatus == 'onway')
            SizedBox(
              width: MediaQuery.of(context).size.width*0.43,
              child: FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S.of(context).delivery_confirmation),
                          content: (_paymenttype=="cod")?Text("Do you confirm if you have delivered all the products and collected a cash of $currency_format $_orderamount"):Text(S
                              .of(context)
                              .would_you_please_confirm_if_you_have_delivered_all_meals),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: new Text(S.of(context).confirm),
                              onPressed: () {
//                                                        _con.doDeliveredOrder(_con.order);
                                debugPrint("otp...."+IConstants.isOtp.toString());
                                Navigator.of(context).pop();
                                if(IConstants.isOtp){
                                  _dialogforOTP();
                                }else{
                                  _dialogforDelivered(context);
                                  performDelivered();
                                }
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
                  S.of(context).delivered,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if(_orderstatus != 'delivered' && _orderstatus == 'onway')
          SizedBox(width: 10,),
          if(_orderstatus != 'delivered' && _orderstatus == 'onway')
            SizedBox(
              width: MediaQuery.of(context).size.width*0.43,
              child: FlatButton(
                onPressed: () {
                  // _dialogforCancel(context);
                  showmodalbottoms(0);
                  /*                showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(S.of(context).delivery_confirmation),
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
                                                  _dialogforProcessing();
                                                  _dialogforCancel(context);
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
                                        });*/
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                color:/* Theme.of(context).accentColor*/Colors.white,
                // shape: StadiumBorder(),
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(width:1.0,color:Theme.of(context).accentColor, )
                ),
                child: Text(
                  S.of(context).issue,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if(_orderstatus != 'delivered' && _orderstatus == 'dispatched')
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

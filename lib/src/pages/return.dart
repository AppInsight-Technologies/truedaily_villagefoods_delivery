import 'package:connectivity/connectivity.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/images.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../../providers/ordersitems.dart';
import '../../src/models/route_argument.dart';
import '../../src/elements/ShoppingCartButtonWidget.dart';

class ReturnWidget extends StatefulWidget {
  RouteArgument routeArgument;


  ReturnWidget({Key key, this.routeArgument}) : super(key: key);
  //final GlobalKey<ScaffoldState> parentScaffoldKey;

 // ReturnWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ReturnWidgetState createState() => _ReturnWidgetState();
}

class _ReturnWidgetState extends StateMVC<ReturnWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime initialdate;
  final TextEditingController datecontroller = new TextEditingController();
  OrderController _con;
  bool _isloading = true;
  bool _isOrderempty = true;
  var returnData;
  bool _isinternet = true;
  bool _isOrder = true;

  _ReturnWidgetState() : super(OrderController()) {
    _con = controller;
  }

  Future<void> _refreshProducts(BuildContext context) async {
    print("Done............");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        _isinternet = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Network state......" + "I am connected to a wifi network");
      setState(() {
        _isinternet = true;
      });
    } else {
      Fluttertoast.showToast(msg: "No internet connection!!!");
      setState(() {
        _isinternet = false;
      });
    }
   /* await Provider.of<OrdersItemsList>(context,listen:false).GetReturn().then((_) {
      returnData = Provider.of<OrdersItemsList>(context,listen:false);
    });*/
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
   /*   Provider.of<OrdersItemsList>(context,listen:false).GetReturn().then((
          _) async {
        setState(() {
          _isloading = false;
          returnData = Provider.of<OrdersItemsList>(context,listen:false);
          if(returnData.returnitems.length <= 0) {
            _isOrderempty = true;
          } else {
            _isOrderempty = false;
          }
        });
      });*/
      datecontroller.text = DateFormat("dd-MM-yyyy").format(_selectedDate);
      _dialogforProcessing();
      Provider.of<OrdersItemsList>(context, listen: false).ReturnLog(datecontroller.text).then((_)async{
        setState(() {
          _isloading = false;
          returnData =Provider.of<OrdersItemsList>(context,listen: false);
          if(returnData.returnitems.length<=0){
            _isOrderempty = true;
           // _isOrder = false;
          }else{
            _isOrderempty = false;
            //_isOrder = true;
          }
          Navigator.of(context).pop();
        });
      });
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        print("network state::::" + "I am connected to a mobile network");
        setState(() {
          _isinternet = true;
        });
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        print("Network state......" + "I am connected to a wifi network");
        setState(() {
          _isinternet = true;
        });
      } else {
        Fluttertoast.showToast(msg: "No internet connection!!!");
        setState(() {
          _isinternet = false;
        });
      }
    });
    super.initState();
  }
  _dialogforProcessing() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
                ),
              ),
            );
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    Future<void> _selectDate( BuildContext context, setState ) async {

      var now = new DateTime.now();
      debugPrint("date time friday...."+DateTime.friday.toString());
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(), // Refer step 1
        // firstDate: DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime(2020),
        lastDate: new DateTime(now.year, now.month + 10, now.day),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor:  Theme.of(context).accentColor,//Head background
              accentColor: Theme.of(context).accentColor,//selection color
            ),// This will change to light theme.
            child: child,
          );
        },
      );
      if (picked != null && picked != _selectedDate)
        setState(() {

          _selectedDate = picked;
          datecontroller
            ..text = DateFormat("dd-MM-yyyy").format(_selectedDate)
            ..selection = TextSelection.fromPosition(TextPosition(
                offset: datecontroller.text.length,
                affinity: TextAffinity.upstream));
          _dialogforProcessing();
          Provider.of<OrdersItemsList>(context, listen: false).ReturnLog(datecontroller.text).then((_)async{
            setState(() {
              _isloading = false;
              returnData =Provider.of<OrdersItemsList>(context,listen: false);
              if(returnData.returnitems.length<=0){
                _isOrderempty = true;
                _isOrder = false;
              }else{
                _isOrderempty = false;
                _isOrder = true;
              }
              Navigator.of(context).pop();
            });
          });

        });
    }

    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: /*Theme.of(context).hintColor*/Colors.white),
            onPressed: () => Navigator.of(context).pop()
        ),
        automaticallyImplyLeading: false,
        backgroundColor: /*Colors.transparent*/Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title:
        SvgPicture.asset("assets/img/Logo.svg", width: 40, height: 45,color: Colors.white,),/*Text(
          S.of(context).orders,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),

        ),*/
         //Image.asset( "assets/img/Logo.png",
        //   // width: MediaQuery.of(context).size.width*0.60,
        //   // height: 300,
        //   //fit: BoxFit.fill,
        // ),
      ),
      body: _isloading?CircularProgressIndicator(color: Colors.transparent,):Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectDate(context,setState);
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 18,),
                      Icon(Icons.keyboard_arrow_down,color: Theme.of(context).accentColor,size: 25,),
                      SizedBox(width: 5,),
                      Text(
                        DateFormat("d MMMM").format(_selectedDate),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(height: 10,),
                _isloading
                    ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
                )
                    :/*(!_isOrderempty)?
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(left: 80.0, right: 80.0,top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 200.0,
                            child: *//*new Image.asset('assets/img/nointernet.png')*//* SvgPicture.asset("assets/img/no order.svg", width: 80, height: 80,),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Text("Hold on! No Orders Assigned Yet",style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ): */ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: returnData.returnitems.length,//OrdersWidget.ordersData.items.length,
                  separatorBuilder: (context, index) {
                    return  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: DottedLine(
                        dashLength: 2.0,
                        dashGapLength: 2.0,
                        direction: Axis.horizontal,
                        dashColor: Colors.grey,
                      ),
                    );
                  },
                  itemBuilder: (context, i) {
                    return Theme(
                      data: theme,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${S.of(context).order_id}:'+" "+'#${returnData.returnitems[i].orderid}',style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600,fontSize: 15)),
                                Row(
                                  children: [
                                    Text(returnData.returnitems[i].orderStatus.toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize:14,fontWeight: FontWeight.w600),),
                                    SizedBox(width: 2,),
                                    Image.asset(
                                      returnData.returnitems[i].img,
                                      // fit: BoxFit.fill,
                                      //color: (returnData.returnitems[i].orderStatus=="Delivered")?Theme.of(context).accentColor:Color(0xFFE96124),
                                      width: 15.0,
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child:Container(
                                  child: Text(
                                    returnData.returnitems[i].address,
                                    style: TextStyle( fontSize: 13,color: Colors.black)/*Theme.of(context).textTheme.caption*/,
                                    //softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )),
                                SizedBox(width: 5,),
                                Row(
                                  children: [
                                    Text(returnData.returnitems[i].orderType,style: TextStyle(color: Colors.black,fontSize:14,fontWeight: FontWeight.w500)),
                                    SizedBox(width: 2,),
                                    (returnData.returnitems[i].orderType=="Standard Delivery")?Image.asset(Images.standard,height: 20,width: 20,):Image.asset(Images.express,height: 20,width: 20,),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: (){
                                debugPrint("status...."+returnData.returnitems[i].orderstatus.toString());
                                Navigator.of(context).pushNamed('/ReturnDetails',
                                  arguments: RouteArgument(
                                    id: returnData.returnitems[i].orderid,
                                    orderstatus: returnData.returnitems[i].orderstatus,
                                    fix_time: returnData.returnitems[i].fix_time,
                                    customer_name: returnData.returnitems[i].customer_name,
                                    address: returnData.returnitems[i].address,
                                    otp:returnData.returnitems[i].otp,
                                    index: i,
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border:Border.all(color:Theme.of(context).accentColor,)
                                ),
                                child: Center(child: Text('View Details',style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).accentColor,),),),
                              ),
                            ),
                          ],
                        ),
                      )/*ExpansionTile(
                          backgroundColor: Colors.white,//Theme.of(context).focusColor.withOpacity(0.05),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(returnData.returnitems[i].orderstatus.toString(),style: TextStyle(color: (returnData.returnitems[i].orderstatus=="completed")?Color(0xFFE96124):Theme.of(context).accentColor,fontWeight: FontWeight.w600),),
                              GestureDetector(
                                onTap: (){
                                 *//* Navigator.of(context).pushNamed('/OrderDetails',
                                    arguments: RouteArgument(
                                      id: deliveredData.delivereditems[i].orderid,
                                      orderstatus: deliveredData.delivereditems[i].orderstatus,
                                      payment_type: deliveredData.delivereditems[i].payment_type,
                                      order_amount: deliveredData.delivereditems[i].order_amount,
                                      fix_date: deliveredData.delivereditems[i].fix_date,
                                      fix_time: deliveredData.delivereditems[i].fix_time,
                                      customer_name: deliveredData.delivereditems[i].customer_name,//OrdersWidget.ordersData.items[i].customer_name,
                                      address: deliveredData.delivereditems[i].address,
                                      actual_amount: deliveredData.delivereditems[i].actual_amount,
                                      delivery_charge:deliveredData.delivereditems[i].delivery_charge,
                                      index: i,
                                    ),
                                  );*//*
                                  Navigator.of(context).pushNamed('/ReturnDetails',
                                    arguments: RouteArgument(
                                      id: returnData.returnitems[i].orderid,
                                      orderstatus: returnData.returnitems[i].orderstatus,
                                      fix_time: returnData.returnitems[i].fix_time,
                                      customer_name: returnData.returnitems[i].customer_name,
                                      address: returnData.returnitems[i].address,
                                      otp:returnData.returnitems[i].otp,
                                      index: i,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border:Border.all(color:(returnData.returnitems[i].orderstatus=="completed")?Color(0xFFE96124):Theme.of(context).accentColor,)
                                  ),
                                  child: Center(child: Text('View Details',style: TextStyle(fontWeight: FontWeight.w500,color: (returnData.returnitems[i].orderstatus=="completed")?Color(0xFFE96124):Theme.of(context).accentColor,),),),
                                ),
                              ),
                            ],
                          ),
                          *//*   IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/OrderDetails',
                                      arguments: RouteArgument(
                                        id: OrdersWidget.ordersData.items[i].orderid,
                                        orderstatus: OrdersWidget.ordersData.items[i].orderstatus,
                                        payment_type: OrdersWidget.ordersData.items[i].payment_type,
                                        order_amount: OrdersWidget.ordersData.items[i].order_amount,
                                        fix_date: OrdersWidget.ordersData.items[i].fix_date,
                                        fix_time: OrdersWidget.ordersData.items[i].fix_time,
                                        customer_name: OrdersWidget.ordersData.items[i].customer_name,
                                        address: OrdersWidget.ordersData.items[i].address,
                                        actual_amount: OrdersWidget.ordersData.items[i].actual_amount,
                                        delivery_charge: OrdersWidget.ordersData.items[i].delivery_charge,
                                        index: i,
                                      ),
                                  );
                                },
                              ),*//*

                          *//*  leading: OrdersWidget.ordersData.items[i].orderstatus == 'delivered'
                                  ? Container(
                                      width: 60,
                                      height: 60,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
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
                                          shape: BoxShape.circle, color: Theme.of(context).hintColor.withOpacity(0.1)),
                                      child: Icon(
                                        Icons.update,
                                        color: Theme.of(context).hintColor.withOpacity(0.8),
                                        size: 30,
                                      ),
                                    ),
*//*
                          title: Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Text('${S.of(context).order_id}:'+" "+'#${returnData.returnitems[i].orderid}',style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600),),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(Icons.location_on_outlined,color:Theme.of(context).accentColor,size: 18,),
                              SizedBox(width: 5,),
                              Expanded(child:Container(
                                child: Text(
                                  returnData.returnitems[i].address,
                                  style: Theme.of(context).textTheme.caption,
                                  //softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )),
                            ],
                          )
                        *//*children: List.generate(_con.orders.elementAt(i).foodOrders.length, (indexFood) {
                                return OrderItemWidget(
                                    heroTag: 'my_orders',
                                    order: _con.orders.elementAt(i),
                                    foodOrder: _con.orders.elementAt(i).foodOrders.elementAt(indexFood));
                              }),*//*
                      )*/,
                    );
                  },
                ),
              ],
            )
        ),
      ),
      /*RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _isinternet ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _isloading
                    ? CircularLoadingWidget(height: 500)
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: returnData.returnitems.length,
                  itemBuilder: (context, i) {
                    return Theme(
                      data: theme,
                      child: ExpansionTile(
                        backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/ReturnDetails',
                              arguments: RouteArgument(
                                id: returnData.returnitems[i].orderid,
                                orderstatus: returnData.returnitems[i].orderstatus,
                                fix_time: returnData.returnitems[i].fix_time,
                                customer_name: returnData.returnitems[i].customer_name,
                                address: returnData.returnitems[i].address,
                                index: i,
                              ),
                            );
                          },
                        ),
                        leading: returnData.returnitems[i].orderstatus == '4'
                            ? Container(
                          width: 60,
                          height: 60,
                          decoration:
                          BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
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
                              shape: BoxShape.circle, color: Theme.of(context).hintColor.withOpacity(0.1)),
                          child: Icon(
                            Icons.update,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                            size: 30,
                          ),
                        ),
                        initiallyExpanded: true,
                        title: Text('Reference Id: #${returnData.returnitems[i].orderid}', style: TextStyle(fontSize: 14.0),),
                        subtitle: Text(
                          returnData.returnitems[i].address,
                          style: Theme.of(context).textTheme.caption,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ) :
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 80.0, right: 80.0),
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                          child: new Image.asset('assets/img/nointernet.png')
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text("No internet connection"),
                    SizedBox(height: 5.0,),
                    Text("Ugh! Something's not right with your internet", style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                    SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: () {
                        _refreshProducts(context);
                      },
                      child: Container(
                        width: 90.0,
                        height: 40.0,
                        decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(3.0),),
                        child: Center(
                            child: Text('Try Again', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),*/
    );
  }
}

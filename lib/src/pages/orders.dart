import 'package:connectivity/connectivity.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/images.dart';
import '../../utils/prefUtils.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../../providers/ordersitems.dart';
import '../../src/models/route_argument.dart';
import '../../src/elements/ShoppingCartButtonWidget.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  static var ordersData;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;
  bool _isloading = true;
  bool _isOrderempty = true;
  bool _isOrder = true;
  bool _isinternet = true;
  int moodCheck = 0;
  final now = new DateTime.now();
  DateTime _selectedDate = DateTime.now();
  DateTime initialdate;
  final TextEditingController datecontroller = new TextEditingController();
  String Pending_order="0";
  String total_pending="0";
  String Return_order="0";
  String Completed_order="0";
  String wallet="0";
  var DashBoradData;
  var currency_format = "";

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  Future<void> _refreshProducts(BuildContext context) async {
    print("done..........");
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
    await Provider.of<OrdersItemsList>(context,listen:false).dashboard(datecontroller.text).then((_) {
      setState(() {
        DashBoradData = Provider.of<OrdersItemsList>(context, listen: false);
        total_pending = DashBoradData.dashboarditems.total_pending;
        debugPrint("pending1..." + total_pending.toString());
        wallet = DashBoradData.dashboarditems.wallet;
        Pending_order = DashBoradData.dashboarditems.pending_order;
        debugPrint("pending..." + Pending_order.toString());
        Return_order = DashBoradData.dashboarditems.returns;
        Completed_order = DashBoradData.dashboarditems.completed_order;
        if(DashBoradData.recentitems.length<=0){
          _isOrderempty = true;
          _isOrder = false;
        }else{
          _isOrderempty = false;
          _isOrder = true;
        }
      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<OrdersItemsList>(context,listen:false).Login();
      await  Provider.of<OrdersItemsList>(context,listen:false).GetRestaurant().then((value) {
        currency_format= PrefUtils.prefs.getString("currency_format");
        debugPrint("dxfcgvbhjn....."+currency_format);
      } );
      _dialogforProcessing();
      Provider.of<OrdersItemsList>(context, listen: false).dashboard(datecontroller.text).then((_)async{
        setState(() {
          _isloading = false;
          DashBoradData =Provider.of<OrdersItemsList>(context,listen: false);
          total_pending =DashBoradData.dashboarditems.total_pending;
          debugPrint("pending1..."+total_pending.toString());
          wallet=DashBoradData.dashboarditems.wallet;
          debugPrint("pending2..."+wallet.toString());
          Pending_order =DashBoradData.dashboarditems.pending_order;
          debugPrint("pending..."+Pending_order.toString());
          Return_order =DashBoradData.dashboarditems.returns;
          Completed_order =DashBoradData.dashboarditems.completed_order;
          if(DashBoradData.recentitems.length<=0){
            _isOrderempty = true;
            _isOrder = false;
          }else{
            _isOrderempty = false;
            _isOrder = true;
          }
          Navigator.of(context).pop();
        });
      });
   /*   _dialogforProcessing();
      Provider.of<OrdersItemsList>(context,listen:false).GetOrders("0").then((
          _) async {
        setState(() {
          _isloading = false;
          OrdersWidget.ordersData = Provider.of<OrdersItemsList>(context,listen:false);
          Navigator.of(context).pop();
          if(OrdersWidget.ordersData.items.length <= 0) {
            _isOrderempty = true;
            _isOrder = false;
          } else {
            _isOrderempty = false;
            _isOrder = true;
          }
        });
      });*/
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
      }// only create the future once.
    });
    datecontroller.text = DateFormat("dd-MM-yyyy").format(_selectedDate);
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
  void tabFunc(String mode) {
    setState(() {
      moodCheck = int.parse(mode);
      _isloading = true;
      _isOrder = true;
    });
    _dialogforProcessing();
    Provider.of<OrdersItemsList>(context, listen: false).GetOrders(mode).then((_) async {
      setState(() {
        //final myorderData = Provider.of<MyorderList>(context, listen: false);
        _isloading = false;
        OrdersWidget.ordersData = Provider.of<OrdersItemsList>(context, listen: false);
        if (OrdersWidget.ordersData.items.length <= 0) {
          _isOrder = false;
        } else {
          _isOrder = true;
        }
        Navigator.of(context).pop();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    DashBoradData =Provider.of<OrdersItemsList>(context,listen: false);
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
          Provider.of<OrdersItemsList>(context, listen: false).dashboard(datecontroller.text).then((_)async{
            setState(() {
              _isloading = false;
              DashBoradData =Provider.of<OrdersItemsList>(context,listen: false);
              Pending_order =DashBoradData.dashboarditems.pending_order;
              debugPrint("pending..."+Pending_order.toString());
              Return_order =DashBoradData.dashboarditems.returns;
              Completed_order =DashBoradData.dashboarditems.completed_order;
              if(DashBoradData.recentitems.length<=0){
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
      /*  leading: new IconButton(
          icon: new Icon(Icons.sort, color: *//*Theme.of(context).hintColor*//*Colors.white),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),*/
        automaticallyImplyLeading: false,
        backgroundColor: /*Colors.transparent*/Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: /*Text(
          S.of(context).orders,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),

        ),*/
        SvgPicture.asset("assets/img/Logo.svg", width: 40, height: 45,color: Colors.white,),
      // Image.asset( "assets/img/Logo.png",
         // width: MediaQuery.of(context).size.width*0.60,
         // height: 300,
          //fit: BoxFit.fill,
        //),
    /*    actions: <Widget>[
          GestureDetector(
            onTap: (){
            },
              child: Image.asset("assets/img/profile.png",color: Colors.white,width: 26,height: 26,)),
        SizedBox(width: 10,),
        *//*  new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),*//*
        ],*/
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _isinternet ? _isloading?CircularProgressIndicator(color: Colors.transparent,):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed('/TotalOrder');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFFFCF9F9),
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //SizedBox(width: 18,),
                        Text('Total Pending Orders',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFFE96124),fontSize: 18),),
                        Row(
                          children: [
                            Text(total_pending,style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xFFE96124),fontSize: 18),),
                            Image.asset("assets/img/right_arrow.png",width: 15,height:
                              15,),
                          ],
                        )
                      ],
                    )
                  ),
                ),
                SizedBox(height: 5,),
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
                SizedBox(
                  height: 145,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(left: 10,right: 10),
                    children: [
                      Container(
                        height: 100,
                        width: /*130*/MediaQuery.of(context).size.width/3-10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                //spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 10),
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Pending Order',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE96124),
                              fontSize: 14,
                            ),),
                            Text(Pending_order,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE96124),
                              fontSize: 50,
                            ),),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/PendingOrder',
                                    arguments: RouteArgument(
                                      date:datecontroller.text
                                  ),
                                );
                              },
                              child: Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width/3-23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Color(0xFFE96124),),
                                ),
                                child: Center(
                                  child: Text('View All',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE96124),
                                    fontSize: 12,
                                  ),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width/3-10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                //spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 10),
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Returns',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                            ),),
                            Text(Return_order,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                              fontSize: 50,
                            ),),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/ReturnOrder',
                                  arguments: RouteArgument(
                                      date:datecontroller.text
                                  ),
                                );
                              },
                              child: Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width/3-23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Theme.of(context).accentColor,),
                                ),
                                child: Center(
                                  child: Text('View All',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                    fontSize: 12,
                                  ),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width/3-10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                //spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 10),
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Completed',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                            ),),
                            Text(Completed_order,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                              fontSize: 50,
                            ),),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/OrdersHistory',
                                  arguments: RouteArgument(
                                      date:datecontroller.text
                                  ),
                                );
                              },
                              child: Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width/3-23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Theme.of(context).accentColor,),
                                ),
                                child: Center(
                                  child: Text('View All',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                    fontSize: 12,
                                  ),),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            SizedBox(
              height: 15,
            ),
               /* SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    *//*scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 5),*//*
                    children: [
                      GestureDetector(
                        onTap: () {
                          tabFunc("0");
                        },
                        child: Container(
                          height: 35,
                          width:150,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                             color: moodCheck== 0?Theme.of(context).accentColor:Colors.white,
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(color: moodCheck== 0?Theme.of(context).accentColor:Theme.of(context).accentColor,),
                          ),
                          child: Center(child: Text('New orders',style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: moodCheck== 0? Colors.white:Theme.of(context).accentColor,
                          ),)),
                        ),
                      ),
                      //VerticalDivider(color: Colors.grey,thickness: 2,indent: 4,endIndent: 4,),
                      GestureDetector(
                        onTap: (){
                          tabFunc("1");
                        },
                        child: Container(
                          height: 35,
                          width:150,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                             color: moodCheck== 1?Theme.of(context).accentColor:Colors.white,
                            borderRadius: BorderRadius.circular(3.0),
                             border: Border.all(color: moodCheck== 1?Theme.of(context).accentColor:Theme.of(context).accentColor,),
                          ),
                          child: Center(child: Text('Accepted orders',style: TextStyle(fontSize:14,color: moodCheck== 1?Colors.white:Theme.of(context).accentColor),)),
                        ),
                      ),
                    ],
                  ),
                ),*/
               /* SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey[200],
                       //spreadRadius: 1,
                       blurRadius: 2,
                       offset: Offset(0, 5),
                     )
                   ]
                 ),
                 height: 50,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Image.asset("assets/img/rupee.png",width: 23,height: 18,),
                        SizedBox(width: 5,),
                        Text('Cash in hand',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text("₹‎ " + "450",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE96124),
                            ),),
                            IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_right,size: 25,color:Color(0xFFE96124),))
                          ],
                        ),
                      )
                    ],
                  ),
                ),*/
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 18,),
                   // Image.asset("assets/img/order.png",height: 20,width: 20,),
                   // SizedBox(width: 8,),
                    Text('Recent Orders',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),)
                  ],
                ),
                SizedBox(height: 5,),
                _isloading
                    ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),
                )
                    :(!_isOrder)?
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: EdgeInsets.only(left: 80.0, right: 80.0,top: 20),
                              width: MediaQuery.of(context).size.width,
                              height: 200.0,
                              child: /*new Image.asset('assets/img/nointernet.png')*/ SvgPicture.asset("assets/img/no order.svg", width: 80, height: 80,),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Text("Hold on! No Orders Assigned Yet",style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ): ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: DashBoradData.recentitems.length,//OrdersWidget.ordersData.items.length,
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
                                      Text('${S.of(context).order_id}:'+" "+'#${DashBoradData.recentitems[i].orderid}',style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600,fontSize: 15)),
                                      Row(
                                        children: [
                                          Text(DashBoradData.recentitems[i].orderStatus.toString(),style: TextStyle(color:( DashBoradData.recentitems[i].orderStatus=="Delivered")?Theme.of(context).accentColor:Color(0xFFE96124),fontSize:14,fontWeight: FontWeight.w600),),
                                          SizedBox(width: 2,),
                                          Image.asset(
                                            DashBoradData.recentitems[i].img,
                                           // fit: BoxFit.fill,
                                           // color: ( DashBoradData.recentitems[i].orderStatus=="Delivered")?Theme.of(context).accentColor:Color(0xFFE96124),
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
                                          DashBoradData.recentitems[i].address,
                                          style: TextStyle( fontSize: 13,color: Colors.black)/*Theme.of(context).textTheme.caption*/,
                                              //softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      )),
                                      SizedBox(width: 5,),
                                      Row(
                                        children: [
                                          Text(DashBoradData.recentitems[i].orderType,style: TextStyle(color: Colors.black,fontSize:14,fontWeight: FontWeight.w600)),
                                          SizedBox(width: 2,),
                                          ( DashBoradData.recentitems[i].orderType=="Standard Delivery")?Image.asset(Images.standard,height: 20,width: 20,):Image.asset(Images.express,height: 20,width: 20,),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pushNamed('/OrderDetails',
                                        arguments: RouteArgument(
                                          id: DashBoradData.recentitems[i].orderid,
                                          orderstatus: DashBoradData.recentitems[i].orderstatus,
                                          payment_type: DashBoradData.recentitems[i].payment_type,
                                          order_amount: DashBoradData.recentitems[i].order_amount,
                                          fix_date: DashBoradData.recentitems[i].fix_date,
                                          fix_time: DashBoradData.recentitems[i].fix_time,
                                          customer_name: DashBoradData.recentitems[i].customer_name,//OrdersWidget.ordersData.items[i].customer_name,
                                          address: DashBoradData.recentitems[i].address,
                                          actual_amount: DashBoradData.recentitems[i].actual_amount,
                                          delivery_charge:DashBoradData.recentitems[i].delivery_charge,
                                          otp:DashBoradData.recentitems[i].otp,
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
                                  Text(DashBoradData.recentitems[i].orderStatus.toString(),style: TextStyle(color: Color(0xFFE96124),fontSize:14,fontWeight: FontWeight.w600),),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pushNamed('/OrderDetails',
                                        arguments: RouteArgument(
                                          id: DashBoradData.recentitems[i].orderid,
                                          orderstatus: DashBoradData.recentitems[i].orderstatus,
                                          payment_type: DashBoradData.recentitems[i].payment_type,
                                          order_amount: DashBoradData.recentitems[i].order_amount,
                                          fix_date: DashBoradData.recentitems[i].fix_date,
                                          fix_time: DashBoradData.recentitems[i].fix_time,
                                          customer_name: DashBoradData.recentitems[i].customer_name,//OrdersWidget.ordersData.items[i].customer_name,
                                          address: DashBoradData.recentitems[i].address,
                                          actual_amount: DashBoradData.recentitems[i].actual_amount,
                                          delivery_charge:DashBoradData.recentitems[i].delivery_charge,
                                          otp:DashBoradData.recentitems[i].otp,
                                          index: i,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border:Border.all(color:Theme.of(context).accentColor,)
                                      ),
                                      child: Center(child: Text('View Details',style: TextStyle(fontWeight: FontWeight.w500,color: Theme.of(context).accentColor,),),),
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
                                child: Text('${S.of(context).order_id}:'+" "+'#${DashBoradData.recentitems[i].orderid}',style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w600),),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color:Theme.of(context).accentColor,size: 18,),
                                 SizedBox(width: 5,),
                                 Expanded(child:Container(
                                   child: Text(
                                     DashBoradData.recentitems[i].address,
                                     style: TextStyle( fontSize: 13,color: Colors.grey)*//*Theme.of(context).textTheme.caption*//*,
                                     //softWrap: false,
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 1,
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
                            ),*/
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
      ),
      bottomNavigationBar:
      Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                Navigator.of(context).pushNamed('/CashScreen');
               // Navigator.of(context).pushNamed(' /CashScreen');
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                   // radius: 16.0,
                    color: Colors.transparent,
                    child: /*Image.asset("assets/img/rupee.png",
                      color: Colors.grey ,
                      width: 50,
                      height: 30,),*/
                    Text(currency_format+ " "+wallet, style: TextStyle(fontSize: 16.0,fontWeight:FontWeight.bold,color: Color(0xFFE96124)),),
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/Profile', arguments: 2);
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
      ),
    );
  }
}

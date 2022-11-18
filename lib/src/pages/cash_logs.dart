import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../providers/ordersitems.dart';
import '../../src/models/route_argument.dart';
import '../../utils/prefUtils.dart';
import 'package:provider/provider.dart';

class CashScreen extends StatefulWidget {
  RouteArgument routeArgument;

  CashScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<CashScreen> {

  bool _isloading = true;
  var currency_format = "\$";
  bool _istipslogs = true;
  bool notransaction = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<OrdersItemsList>(context,listen:false).Login();
      await  Provider.of<OrdersItemsList>(context,listen:false).GetRestaurant().then((value) {
        currency_format= PrefUtils.prefs.getString("currency_format");
        debugPrint("dxfcgvbhjn....."+currency_format);
      } );
      Provider.of<OrdersItemsList>(context,listen: false).fetchCashLogs().then((_) {
        setState(() {
          _istipslogs = false;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (!_istipslogs) {
      _isloading = false;
    }
    final walletData = Provider.of<OrdersItemsList>(context,listen: false);
    if (walletData.cashitems.length <= 0) {
    notransaction = true;
    } else {
    notransaction = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        //automaticallyImplyLeading: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: /*Theme.of(context).hintColor*/Colors.white),
            onPressed: () => Navigator.of(context).pop()
        ),
        backgroundColor: Theme.of(context).accentColor,
        title: Text('Cash in Hand',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isloading
              ? Center(
            child: CircularProgressIndicator(color: Theme.of(context).accentColor,),
          )
              : Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
             /* Container(
                margin: EdgeInsets.only(bottom: 20.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                   *//* Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          currency_format + " " + "20"*//**//*walletbalance*//**//*,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Tips Balance",
                          style: TextStyle(
                            fontSize: 21.0,
                            color: Color(0xff646464),
                          ),
                        ),
                      ],
                    ),*//*
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                  ],
                ),
              ),*/
              notransaction
                  ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      child: /*Image.asset(
                        "assets/img/nointernet.png",
                        width: 232.0,
                        height: 168.0,
                        alignment: Alignment.center,
                      ),*/
                      SvgPicture.asset("assets/img/no_transaction.svg", width: 200, height: 200,),
                    ),
                   /* SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "There is no transaction",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 19.0,
                          color: Color(0xff616060),
                          fontWeight: FontWeight.bold),
                    ),*/
                  ],
                ),
              )
                  : Expanded(
                child: new ListView.builder(
                  itemCount: walletData.cashitems.length,
                  itemBuilder: (_, i) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          Image.asset(
                            walletData.cashitems[i].img,
                            fit: BoxFit.fill,
                            width: 40.0,
                            height: 40.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                walletData.cashitems[i].title,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                walletData.cashitems[i].time,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                walletData.cashitems[i].date,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                walletData.cashitems[i].amount,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Total Balance: " +
                                    currency_format +
                                    " " +
                                    walletData.cashitems[i]
                                        .closingbalance,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 60.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 10.0),
                        child: Text(
                          walletData.cashitems[i].note,
                          style: TextStyle(
                              color: Colors.black54, fontSize: 12.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 60.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 10.0),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

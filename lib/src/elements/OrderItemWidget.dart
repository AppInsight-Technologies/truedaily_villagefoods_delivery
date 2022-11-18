import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utils/prefUtils.dart';
import 'package:intl/intl.dart' show DateFormat;
/*import '../helpers/helper.dart';
import '../models/food_order.dart';
import '../models/order.dart';*/
import '../models/route_argument.dart';
class OrderItemWidget extends StatelessWidget {
  final String heroTag;
  final String itemname;
  final String itemvar;
  final String itemqty;
  final String itemamount;
  final String itemorderdate;
  final String imageurl;
  final String itemTax;
  //final FoodOrder foodOrder;
  //final Order order;
  const OrderItemWidget({
    Key key,
    this.heroTag,
    this.itemname,
    this.itemvar,
    this.itemqty,
    this.itemamount,
    this.itemorderdate,
    this.imageurl,
    this.itemTax,
    /*this.order*/
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Tracking',
            arguments:
            RouteArgument(id: /*order.id*/ "12", heroTag: this.heroTag));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
             /*   CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child:   new Image.asset(
                      "assets/img/defaultImg.webp"),
                ),*/
                CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: imageurl,
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
              ],
            ),
            /*Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: "http://ssnadmin.srisrinaisargik.com/uploads/items/images/apple-royal-gala-regular.jpg",
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
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
                          itemname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          itemvar,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                       /* Text(
                          'Qty: ${itemqty}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),*/
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      /*Helper.getPrice(double.parse(itemamount),
                          style: Theme.of(context).textTheme.display1),*/
                      Text(PrefUtils.prefs.getString("currency_format")+" " + itemamount,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFE96124),
                          )),
                      Text(
                       /* DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(itemorderdate))*/ 'Qty: ${itemqty}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Theme.of(context).accentColor,
                        )),
                      /*Text(
                        DateFormat('HH:mm')
                            .format(DateTime.parse(itemorderdate)),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Theme.of(context).accentColor,
                        )),*/
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
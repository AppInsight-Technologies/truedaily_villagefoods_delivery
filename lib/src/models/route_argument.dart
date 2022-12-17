class RouteArgument {
  String id;
  String heroTag;
  dynamic param;
  String orderstatus;
  String payment_type;
  String order_amount;
  String fix_date;
  String fix_time;
  String customer_name;
  String address;
  String actual_amount;
  String delivery_charge;
  String total_discount;
  int index;
  String date;
  String otp;
  String fromScreen;

  RouteArgument({
    this.id,
    this.heroTag,
    this.param,
    this.orderstatus,
    this.payment_type,
    this.order_amount,
    this.fix_date,
    this.fix_time,
    this.customer_name,
    this.address,
    this.actual_amount,
    this.delivery_charge,
    this.index,
    this.date,
    this.fromScreen,
    this.otp,
    this.total_discount,
  });

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}

import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget(
      {Key key,
      this.color,
      this.text,
      this.onPressed})
      : super(key: key);

  final Color color;
  final Text text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       /* boxShadow: [
          BoxShadow(
              color: this.color.withOpacity(0.4),
              blurRadius: 40,
              offset: Offset(0, 15)),
          BoxShadow(
              color: this.color.withOpacity(0.4),
              blurRadius: 13,
              offset: Offset(0, 3))
        ],*/
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 78, vertical: 11),
        color: this.color,
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
        ),
        child: this.text,
      ),
    );
  }
}

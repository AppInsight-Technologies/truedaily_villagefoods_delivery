
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String name;
  final String email;
  final String address;

  ProfileAvatarWidget({
    Key key,
    this.name,
    this.email,
    this.address
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              /*SizedBox(
                width: 50,
                height: 50,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  child: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ),*/
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  child: Icon(Icons.account_circle, size: 120, color: Colors.white,)/*CachedNetworkImage(
                    height: 135,
                    width: 135,
                    fit: BoxFit.cover,
                    imageUrl: "https://ssnadmin.srisrinaisargik.com/uploads/items/images/apple-royal-gala-reguladfgfr.jpg",
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      height: 135,
                      width: 135,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )*/,
                ),
/*              SizedBox(
                width: 50,
                height: 50,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  child: Icon(Icons.chat, color: Theme.of(context).primaryColor),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ),*/
              ],
            ),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.headline1.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          Text(
            email,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}

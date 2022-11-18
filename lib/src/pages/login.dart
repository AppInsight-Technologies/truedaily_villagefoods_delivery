import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/Iconstants.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart' as config;
import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';


class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;
  final _form = GlobalKey<FormState>();
  final TextEditingController _mobilenumController = new TextEditingController();

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  void initState() {
    _mobilenumController.text="";
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var Mobilenum = prefs.getString('Mobilenum');
      setState(() {
//        countrycode = prefs.getString("country_code");
      });
    });
//    provider.of<>(context).LoginUser().then((_) {
//      setState(() {
//      });
//    });


    super.initState();
  }




  addMobilenumToSF(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phonenumber', value);
  }

  addPasswordToSF(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Password', value);
  }

  _saveForm() async {
    final isValid =_form.currentState.validate();
    if (!isValid) {
      return;
    }//it will check all validators
    _form.currentState.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Phone number............");
    print(prefs.getString('phonenumber'));

    print("password....");
    print(prefs.getString('Password'));
    Login();

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
            "tokenId": prefs.getString('tokenid')
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
        print("id1.........." + data[0]['id'].toString());
        prefs.setString('id', data[0]['id'].toString());
        prefs.setString('first_name', data[0]['first_name'].toString());
        prefs.setString('last_name', data[0]['last_name'].toString());
        prefs.setString('mobile_number', data[0]['mobile_number'].toString());
        prefs.setString('email', data[0]['email'].toString());
        prefs.setString('address', data[0]['address'].toString());
        prefs.setString("login_status", "true");
        debugPrint("otttpp..."+responseJson['otp'].toString());
        IConstants.isOtp=(responseJson['otp'].toString()=="0")?true:false;
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Invalid MobileNumber or Password");
      }

    } catch (error) {
       Navigator.of(context).pop();
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mobilenum;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(37),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child:/* Image.asset( "assets/img/Logo.webp",
                  width: MediaQuery.of(context).size.width*0.60,
                  height: 300,
                  //fit: BoxFit.fill,
                ),*/
                Padding(
                 padding: const EdgeInsets.all(80),
                  child: /*Image.asset("assets/img/Logo.png"),*/
                   SvgPicture.asset("assets/img/Logo.svg",),
                ),
              ),
            ),
            /*Positioned(
              top: config.App(context).appHeight(37) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(37),
                child: Text(
                  S.of(context).lets_start_with_login,
                  style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),*/
            Stack(
              children:[
              Positioned(
                top: config.App(context).appHeight(37) - 50,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 50,
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                        )
                      ]),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                  width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                  child: Form(
                    //key: _con.loginFormKey,
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Login to get started',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                        SizedBox(height: 5,),
                        Text('Please use your registered mobile number and phone',
                          textAlign: TextAlign.center,
                          style: TextStyle(color:Colors.grey ),),
                        SizedBox(height: 10,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _mobilenumController,
                          cursorColor: Colors.black,
                          //onSaved: (input) => _con.user.email = input,
                          onSaved: (value) {
                            addMobilenumToSF(value);
                          },
                       inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10)],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a Mobile number.';
                            }
                            return null; //it means user entered a valid input
                          },
                          decoration: InputDecoration(
                            labelText: S.of(context).phone,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            fillColor: Colors.black,
                            hoverColor: Colors.black,
                            contentPadding: EdgeInsets.all(5),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _mobilenumController.clear();
                                });
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(Icons.cancel,size: 20,color: Colors.grey[400],),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey
                                )),
                            // hintText: '9876543210',
                            // hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                           // prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                           // border: OutlineInputBorder(
                           //     borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                           // focusedBorder: OutlineInputBorder(
                           //     borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                           // enabledBorder: OutlineInputBorder(
                           //     borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
//                        onSaved: (input) => _con.user.password = input,
//                        validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                          onSaved: (value) {
                            addPasswordToSF(value);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a Password.';
                            }
                            return null; //it means user entered a valid input
                          },
                          obscureText: _con.hidePassword,
                          decoration: InputDecoration(
                            labelText: S.of(context).password,
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(5),
                              hoverColor: Colors.black,
                            // hintText: '••••••••••••',
                            // hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                           // prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off,size: 20,color: Colors.grey[400]),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey
                                ))
                           // border: OutlineInputBorder(
                            //    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                           // focusedBorder: OutlineInputBorder(
                           //     borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                           // enabledBorder: OutlineInputBorder(
                          //      borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
                Positioned(
                  bottom: config.App(context).appHeight(37) - 56,
                  left: MediaQuery.of(context).size.width*0.16,
                  child:  BlockButtonWidget(
                    text: Text(
                      S.of(context).login,
                      style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 18),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      print("Login pressed.........");
                      _dialogforProcessing();
                      _saveForm();
                      //_con.login();
                    },
                  ),
                )
            ],
            ),
          ],
        ),
      ),
    );
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
                child: CircularProgressIndicator(color: Theme.of(context).accentColor,),
              ),
            );
          });
        });
  }
}


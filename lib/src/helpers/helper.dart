import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

import '../models/setting.dart';
import '../repository/settings_repository.dart';

class Helper {
  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['name'],
            snippet: res['distance'].toStringAsFixed(2) + ' mi',
            onTap: () {
              print('infowi tap');
            }),
        position: LatLng(double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }

  static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: 18, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: 18, color: Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: 18, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static FutureBuilder<Setting> getPrice(double myPrice, {TextStyle style}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    return FutureBuilder(
      builder: (context, priceSnap) {
        if (priceSnap.connectionState == ConnectionState.none && priceSnap.hasData == false) {
          return Text('');
        }
        return RichText(
          softWrap: false,
          overflow: TextOverflow.fade,
          maxLines: 1,
          text: priceSnap.data?.currencyRight != null && priceSnap.data?.currencyRight == false
              ? TextSpan(
                  text: priceSnap.data?.defaultCurrency,
                  style: style ?? Theme.of(context).textTheme.subtitle1,
                  children: <TextSpan>[
                    TextSpan(
                        text: myPrice.toStringAsFixed(2) ?? '', style: style ?? Theme.of(context).textTheme.subtitle1),
                  ],
                )
              : TextSpan(
                  text: myPrice.toStringAsFixed(2) ?? '',
                  style: style ?? Theme.of(context).textTheme.subtitle1,
                  children: <TextSpan>[
                    TextSpan(
                        text: priceSnap.data?.defaultCurrency,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize:
                                style != null ? style.fontSize - 4 : Theme.of(context).textTheme.subtitle1.fontSize - 4)),
                  ],
                ),
        );
      },
      future: getCurrentSettings(),
    );
  }


  static String getDistance(double distance) {
    // TODO get unit from settings
    return distance != null ? distance.toStringAsFixed(2) + " mi" : "";
  }

  static String skipHtml(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }



  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }
}

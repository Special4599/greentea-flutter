import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentea/define.dart';
import 'package:greentea/model/delegate.dart';
import 'package:greentea/model/units.dart';
import 'package:greentea/model/user.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

class ScanCode extends StatefulWidget {
  int type;
  Unit unit;
  String token;

  ScanCode({this.type, this.unit, this.token});

  @override
  _ScanCodeState createState() {
    // TODO: implement createState
    return _ScanCodeState(type: type, unit: unit, token: token);
  }
}

class _ScanCodeState extends State<ScanCode> {
  final int type;
  final Unit unit;
  final String token;
  String barcode = "", mesage;
  Delegate delegate;
  User user;

  _ScanCodeState({this.type, this.unit, this.token}) {
    print("this is constructor");
    print(token);
  }

  @override
  void initState() {
    print("this is Initstate");
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      this.barcode = barcode;
    });
    getInforDelegate(type);
  }

  changePage(String type, bool _bool) {
    if (type == 'checkinManual') {
      if (_bool) {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
////              builder:
//                ));
        print("ckecinManutrue");
      } else {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
////              builder:
//                ));
        print("ckecinManualFALSE");
      }
      return;
    }
    if (_bool) {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
////              builder:t
//              ));
      print("ckecintrue");
    } else {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
////              builder:
//              ));
      print("ckecinFALSE");
    }
  }

  getInforDelegate(int type) {
    switch (type) {
      case 1:
        checkin('checkin');
        break;
      case 2:
        checkin('checkout');
        break;
      case 3:
        checkinManual();
        break;
    }
  }

  //checkin or checkout dua vao type truyen vao
  checkin(String type) async {
    var uri;
    if (type == "checkin") {
      print("ischeckIn" + barcode + "${unit.id}");
//      url = 'http://youth.gtnlu.site/api/checkin?data=$barcode&id=${unit.id}';
      uri = Uri.http('youth.gtnlu.site', 'api/checkin',
          {'data': barcode, 'id': '${unit.id}'});
    } else {
      print("ischeckOut" + barcode + "${unit.id}");
//      url = 'http://youth.gtnlu.site/api/checkout?data=$barcode&id=${unit.id}';
      uri = Uri.http('youth.gtnlu.site', 'api/checkout',
          {'data': barcode, 'id': '${unit.id}'});
    }
    final response = await http
        .get(uri, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print(body);
      if (body['status'] == 200) {
        delegate = Delegate.fromJson(body['member']);
        mesage = body['mes'];
        print("mesage:" + mesage);
        changePage(type, true);
      } else {
        mesage = body['mes'];
        print("mesage:" + mesage);
        changePage(type, false);
      }
    } else {
      mesage = "SERVER EROR";
      print("mesage:" + mesage);
      changePage(type, false);
    }
  }

  checkinManual() async {
    var uri = Uri.http('youth.gtnlu.site', '/api/program/checkin',
        {'id': '${unit.id}', 'idNlu': barcode});
    final response = await http
        .get(uri, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 200) {
        user = User(
          iddep: body['user']['idp'],
          idNlu: body['user']['idNlu'],
        );
        mesage = body['mes'];
        print("mesage:" + mesage);
        changePage('checkinManual', true);
      } else {
        mesage = body['mes'];
        print("mesage:" + mesage);
        changePage('checkinManual', false);
      }
    } else {
      mesage = "SERVER EROR";
      print("mesage:" + mesage);
      changePage('checkinManual', false);
    }
  }

//  GlobalKey<>
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("this is biuld");
    _scan();
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Back",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
          ]),
    );
  }
}

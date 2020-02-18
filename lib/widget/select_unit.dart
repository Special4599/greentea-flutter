import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greentea/model/units.dart';
import 'package:greentea/widget/scanPage.dart';
import 'package:http/http.dart' as http;

class SlectUnits extends StatefulWidget {
  String token;
  int type;

  SlectUnits({this.token, this.type});

  @override
  SlectUnitsState createState() => SlectUnitsState(token: token, type: type);
}

class SlectUnitsState extends State<SlectUnits> {
  Unit line;
  String token;
  int type;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  // chua danh sach cac unit lay tu server
  List<Unit>  units= new List();

  final urlType1_2 = "http://youth.gtnlu.site/api/checkinglist";
  final urlType3 = "http://youth.gtnlu.site/api/program/checkinglist";

  SlectUnitsState({this.token, this.type});

  getUnits(int type) async {
    //type 3 la diem danh bang tay !=3 la diem danh bang scan
    if (type == 3) {
      final response = await http.get(urlType3,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      List<dynamic> list = json.decode(response.body);
      units = list.toList();
      print("@GREN${units.length}");
    } else {
      final response = await http.get(urlType1_2,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      if (json.decode(response.body).toString().endsWith("]")) {
        List<dynamic> list = json.decode(response.body);
        // cap nhat lai data cho dropdown
        setState(() {
          units = list.map((i) => Unit.fromJson(i)).toList();
        });
        print("@GREN${units.length}");
      } else {
        // khong du quyen show snackbar
        print("@GREEN:${response.body}");
        units.add(new Unit());
        _globalKey.currentState.showSnackBar(SnackBar(content:Text("YOU NOT HAVE PERMISSION")));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUnits(type);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Units"),
      ),
      body: Center(
        child: DropdownButton<Unit>(
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          hint: Text("Select units"),
          style: TextStyle(color: Colors.red),
          underline: Container(
            height: 2,
            color: Colors.deepPurple,
          ),
          onChanged: (Unit value) {
            setState(() {
              line = value;
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ScanCode(type: type,)
              ));
            });
          },
          items: units.map<DropdownMenuItem<Unit>>((Unit value) {
            return DropdownMenuItem<Unit>(
                value: value,
                child: Text(value.name, style: TextStyle(color: Colors.black)));
          }).toList() ,

          value: line,
        ),
      ),
    );
  }
}

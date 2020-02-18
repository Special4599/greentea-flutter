import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';
import '../define.dart';
import 'select_unit.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String token="";
  getTokenFromSharePrefer()async{
    final sharePreferent= await SharedPreferences.getInstance();
    token=sharePreferent.getString(Define.KEY_TOKEN??"");
    if(token==""){
      sharePreferent.setBool(Define.KEY_STATUSLOGIN, false);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> LoginPage(),
      ));
    }
  }
  logout()async{
    final sharePreferent= await SharedPreferences.getInstance();
    sharePreferent.setBool(Define.KEY_STATUSLOGIN, false);
    sharePreferent.remove(Define.KEY_TOKEN);
    // ve man hinh login khog quay tro lai dc
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> LoginPage(),
    ));
  }

  @override
  void initState() {
    getTokenFromSharePrefer();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            FlatButton(
              child: Text("Checkin"),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: (){
                if(token!="") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlectUnits(token: token,type: Define.TYPESCAN_CHECKIN,),
                  ));
                }
              },
            ),
            FlatButton(
              child: Text("Checkout"),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue,
              padding: EdgeInsets.all(8.0),
              onPressed: (){
                if(token!="") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlectUnits(token: token,type: Define.TYPESCAN_CHECKOUT,),
                  ));
                }
              },
            ),
            FlatButton(
              child: Text("Attendance"),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue,
              padding: EdgeInsets.all(8.0),
              onPressed: (){
                if(token!="") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlectUnits(token: token,type: Define.TYPESCAN_CHECKMANUAL,),
                  ));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: (){
          logout();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

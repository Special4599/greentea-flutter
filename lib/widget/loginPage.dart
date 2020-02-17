import 'dart:convert';
import 'dart:io';
import 'package:greentea/widget/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../define.dart';
import '../model/user.dart';
import  'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordControler= new TextEditingController();
  String email,password;
  String token;
  User user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: CircularProgressIndicator());

  gettoken () async{
    final url='http://youth.gtnlu.site/api/login?idNlu=$email&password=$password';
    final response =await http.get(url,headers: {HttpHeaders.contentTypeHeader:'application/json'});
//    final client = http.Client();
    if(response.body!="") {
      if (json.decode(response.body)['status'] == 200) {
        print(response.statusCode);
        token = json.decode(response.body)['token'];
        print(response.statusCode);
        user = User.fromjson(json.decode(response.body)['user']);
        saveStatusLogin();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MyHomePage(title: "HomePage",)
        ));
      } else {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        print("!=200");
        //forcus username bao loi
        email = " ";
        _formKey.currentState.validate();
      }
    }else{
      _scaffoldKey.currentState.removeCurrentSnackBar();
      print("null");
      //forcus username bao loi
      email = " ";
      _formKey.currentState.validate();
    }
  }
// luu trang thai sau khi request thanh cong
  saveStatusLogin()async{
    if(token!=null&&user!=null){
      final sharepreferent= await SharedPreferences.getInstance();
      sharepreferent.setString(Define.KEY_TOKEN, token);
      sharepreferent.setBool(Define.KEY_STATUSLOGIN, true);
      sharepreferent.setString(Define.KEY_USER, user.toString());
    }else{
      //forcus username thong bao error
      return Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Somthing went wrong! Contact admin to fix')));
    }
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
  final _formKey= GlobalKey<FormState>();
  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: isPassword?passwordControler:emailController,
              obscureText: isPassword,
              validator: (value){
                if(value.isEmpty){
                  return "Username or password is empty";
                }else if(value!=email){
                  return "Username or password incorect";
                }
                print(value+"-"+email);
                return null;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.green, Colors.green]
          )
      ),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
//            onTap: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => SignUpPage()));
//            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'G',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
          children: [
            TextSpan(
              text: 'ree',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ntea',
              style: TextStyle(color: Colors.green, fontSize: 30),
            ),
          ]),
    );
  }

  Widget  _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child:Column(
        children: <Widget>[
          _entryField("UserName"),
          _entryField("Password", isPassword: true),
        ],
      ) ,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child:  _submitButton(),
                        onTap: (){
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          print("email:"+(email=emailController.text)+"-password:"+(password=passwordControler.text));
                          if(!_formKey.currentState.validate()){
                            gettoken();
                            print("gettoken");
                          }
                        },
                      )
                     ,
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style:
                                TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      _divider(),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _createAccountLabel(),
                ),
//                Positioned(top: 40, left: 0, child: _backButton()),
//                Positioned(
//                    top: -MediaQuery.of(context).size.height * .15,
//                    right: -MediaQuery.of(context).size.width * .4,
//                    child: BezierContainer())
              ],
            ),
          )
        )
      );
  }
}

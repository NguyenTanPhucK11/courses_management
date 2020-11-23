import 'dart:io';

import 'package:courses_management/providers/accounts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'courses_overview_screen.dart';
import '../providers/accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Album> createAlbum(
    String username, String password, BuildContext context) async {
  final http.Response response = await http.post(
    'http://118.69.123.51:5000/fis/api/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': 'DongPH',
      'password': 'Sieunhancamap21',
    }),
  );
  // print(response.body);
  Provider.of<Accounts>(context, listen: false).update(
      Album.fromJson(jsonDecode(response.body)).data['token'].toString());

  if (Album.fromJson(jsonDecode(response.body)).resultCode == 1) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
  }
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int resultCode;
  final data;

  Album({this.resultCode, this.data});

  factory Album.fromJson(Map<String, dynamic> json) {
    // print("json: ${json['resultCode']}");
    return Album(
      resultCode: json['resultCode'],
      data: json['data'],
    );
  }
}

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String displayName = '123';

  void initState() {
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
    });
  }

  var urlImg = 'lib/images/';
  final _distant = SizedBox(
    height: 15,
  );
  bool _rememberValue = false;
  bool _showPassword = true;
  final _mainColor = Colors.orange;
  final _backgroundColor = Colors.white;
  final _userName = TextEditingController();
  final _userPassword = TextEditingController();
  var _rememberUser = "";
  var _rememberPass = "";
  void _passHideShow() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget line(Color colors) {
    return Container(
      margin: EdgeInsets.all(3),
      height: 4.0,
      width: 30.0,
      color: colors,
    );
  }

  @override
  void dispose() {
    _userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('13'),
          ),
      body: FooterView(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                right: 30,
                left: 30,
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Image.asset('images/ic_fpt_is.png'),
                  _distant,
                  Text(
                    'FIS INSIGHT PORTAL',
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        line(Colors.blue),
                        line(_mainColor),
                        line(Colors.green)
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'ĐĂNG NHẬP HỆ THỐNGG',
                    style: TextStyle(
                      color: _mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _distant,
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          controller: _userName),
                    ),
                  ),
                  _distant,
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      obscureText: !_showPassword,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: _showPassword == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: _passHideShow,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: _userPassword,
                    ),
                  ),
                  _distant,
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: Checkbox.width,
                            height: Checkbox.width,
                            child: Container(
                              decoration: new BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context)
                                            .unselectedWidgetColor ??
                                        Theme.of(context).disabledColor),
                                borderRadius: new BorderRadius.circular(100),
                              ),
                              child: Checkbox(
                                checkColor: _mainColor,
                                hoverColor: _mainColor,
                                activeColor: _backgroundColor,
                                value: _rememberValue,
                                onChanged: (bool value) => setState(() {
                                  _rememberValue = value;
                                }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Ghi nhớ đăng nhập',
                          style: TextStyle(
                            color: _mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _distant,
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        createAlbum(
                            _userName.text, _userPassword.text, context);
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('displayName', _userName.text);
                    },
                    color: _mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(),
                      child: Center(
                        child: Text(
                          'ĐĂNG NHẬP',
                          style: TextStyle(
                            fontSize: 17,
                            color: _backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                    'images/swipe.png',
                    scale: 1.2,
                  ),
                ],
              ),
            ),
          ),
        ],
        footer: new Footer(
          child: Padding(
            padding: new EdgeInsets.all(0.0),
            child: Text(
              'Copyright ©2019, FPT Information System',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          alignment: Alignment.topCenter,
        ),
        flex: 4,
      ),
    );
  }
}

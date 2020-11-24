import 'dart:io';

import 'package:courses_management/models/post.dart';
import 'package:courses_management/providers/accounts.dart';
import 'package:courses_management/widget/snackbar.dart';
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

bool checkLogin = false;

Future<Album> checkAccount(
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
  final data = Album.fromJson(jsonDecode(response.body));
  // 'username': 'DongPH',
  // 'password': 'Sieunhancamap21',
  // print(response.body);

  if (data.resultCode == 1) {
    checkLogin = true;
    Provider.of<Accounts>(context, listen: false)
        .update(data.data['token'].toString());
  } else {
    checkLogin = false;
  }
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String displayName = '123';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _key,
      appBar: AppBar(
          //  title: Text('QUẢN LÝ ĐÀO TẠO'),
          ),
      body: _buildBody(_key),
    );
  }

  Widget _buildBody(_key) {
    var screen = MediaQuery.of(context).size;

    return FooterView(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              right: screen.width * 0.1,
              left: screen.width * 0.1,
              top: screen.height * 0.02,
              bottom: screen.height * 0.02,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    line(Colors.blue),
                    line(_mainColor),
                    line(Colors.green)
                  ],
                ),
                SizedBox(height: 25),
                Text(
                  'ĐĂNG NHẬP HỆ THỐNG',
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
                        autofocus: true,
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
                                  color:
                                      Theme.of(context).unselectedWidgetColor ??
                                          Theme.of(context).disabledColor),
                              borderRadius: new BorderRadius.circular(100),
                            ),
                            child: Checkbox(
                              checkColor: _mainColor,
                              hoverColor: _mainColor,
                              activeColor: _backgroundColor,
                              focusColor: _mainColor,
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
                    if (checkLogin) {
                      await _key.currentState.showSnackBar(
                        new SnackBar(
                          content: new Text('Đăng nhập thành công !'),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 1));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoursesOverviewScreen()));
                    } else {
                      await _key.currentState.showSnackBar(
                        new SnackBar(
                          content: new Text('Đăng nhập không thành công !'),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 1));
                    }

                    setState(() {
                      checkAccount(_userName.text, _userPassword.text, context);
                    });
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
                _distant,
                _distant,
                _distant,
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
    );
  }
}

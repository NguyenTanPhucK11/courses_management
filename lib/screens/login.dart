import 'dart:io';

import 'package:courses_management/models/post.dart';
import 'package:courses_management/providers/accounts.dart';
import 'package:courses_management/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'courses_overview_screen.dart';
import '../providers/accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Album> checkAccount(
    String username, String password, BuildContext context) async {
  final http.Response response = await http.post(
    'http://118.69.123.51:5000/fis/api/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  final data = Album.fromJson(jsonDecode(response.body));
  // 'username': 'DongPH',
  // 'password': 'Sieunhancamap21',
  // print(response.body);
  Provider.of<Accounts>(context, listen: false)
      .update(data.data['token'].toString());

  if (data.resultCode == 1) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
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
  bool _clicked = false;
  final _mainColor = Colors.orange;
  final _backgroundColor = Colors.white;
  TextEditingController _userName = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _keyUsername = GlobalKey<FormState>();
  final _keyPassword = GlobalKey<FormState>();
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
    return Scaffold(
      key: _key,
      appBar: AppBar(
          //  title: Text('QUẢN LÝ ĐÀO TẠO'),
          ),
      body: _buildBody(),
    );
  }

  addStringToSF(_userName, _userPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _userName);
    prefs.setString('password', _userPassword);
  }

  getStringValuesSF(
      TextEditingController _userName, TextEditingController _passWord) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    _userName.text = prefs.getString('username');
    _passWord.text = prefs.getString('password');
  }

  Widget _buildBody() {
    getStringValuesSF(_userName, _userPassword);
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
                Form(
                  key: _keyUsername,
                  child: TextFormField(
                    focusNode: _idFocus,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9]+|\s"))
                    ],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(null),
                      hintText: 'Email or Phone',
                    ),
                    textInputAction: TextInputAction.next,
                    controller: _userName,
                    validator: (value) {
                      return value.isEmpty
                          ? 'Vui lòng nhập email or phone'
                          : null;
                    },
                  ),
                ),
                _distant,
                Form(
                  key: _keyPassword,
                  child: TextFormField(
                    focusNode: _passFocus,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9]+|\s"))
                    ],
                    keyboardType: TextInputType.name,
                    obscureText: !_showPassword,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: _showPassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: _passHideShow,
                      ),
                      hintText: 'Password',
                    ),
                    textInputAction: TextInputAction.next,
                    controller: _userPassword,
                    validator: (value) {
                      return value.isEmpty ? 'Vui lòng nhập password' : null;
                    },
                  ),
                ),
                _distant,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: SizedBox(
                          width: Checkbox.width,
                          height: Checkbox.width,
                          child: Container(
                            decoration: new BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: _mainColor,
                              ),
                              borderRadius: new BorderRadius.circular(100),
                            ),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.transparent,
                              ),
                              child: Checkbox(
                                value: _rememberValue,
                                onChanged: (value) =>
                                    setState(() => _rememberValue = value),
                                activeColor: Colors.white,
                                checkColor: _mainColor,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                              ),
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
                  onPressed: _clicked
                      ? null
                      : () async {
                          if (_keyUsername.currentState.validate() ||
                              _keyPassword.currentState.validate()) {
                            if (_keyUsername.currentState.validate() &&
                                _keyPassword.currentState.validate()) {
                              setState(() => _clicked = true);
                              if (_rememberValue)
                                addStringToSF(
                                    _userName.text, _userPassword.text);
                              else
                                addStringToSF('', '');

                              if (_clicked) {
                                snackBar(_key, 'Đăng nhập thành công !', null);
                              }
                              await Future.delayed(Duration(milliseconds: 300));
                              setState(() {
                                checkAccount(_userName.text, _userPassword.text,
                                    context);
                              });
                              await Future.delayed(Duration(milliseconds: 300));
                              setState(() => _clicked = false);
                            }
                          }
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
      flex: 5,
    );
  }
}

import 'dart:convert';
import 'package:course_management/data/network/api/buildings_api.dart';
import 'package:course_management/data/sharedpref/shared_preference.dart';
import 'package:course_management/models/post.dart';
import 'package:course_management/providers/accounts.dart';
import 'package:course_management/screens/courses_overview_screen.dart';
import 'package:course_management/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<GetApi> checkAccount(String username, String password,
    BuildContext context, _key, bool _rememberValue) async {
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
  final data = GetApi.fromJson(jsonDecode(response.body));

  if (data.resultCode == -1) {
    snackBar(_key, 'Sai tài khoản hoặc mật khẩu !', null);
    await Future.delayed(Duration(milliseconds: 500));
  }
  if (data.resultCode == 1) {
    Provider.of<Accounts>(context, listen: false)
        .updateRole(data.data['eduRole']);
    Provider.of<Accounts>(context, listen: false)
        .update(data.data['token'].toString());
    fetchBR(context);
    SharedPreferenceHelper.saveUsername(username, password);
    _rememberValue
        ? SharedPreferenceHelper.saveAuth(data.data['token'])
        : SharedPreferenceHelper.saveAuth('');
    Provider.of<Accounts>(context, listen: false)
        .updateCheckRemember(_rememberValue);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
    if (data.data['eduRole'] == null) {
      snackBar(_key, 'Tài khoản này chưa có quyền admin !', null);
      await Future.delayed(Duration(milliseconds: 500));
    } else {}
  }
  if (response.statusCode == 200) {
    return GetApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get API !');
  }
}

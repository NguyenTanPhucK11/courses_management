import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accounts with ChangeNotifier {
  var token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYTNiMzY0ZTY1OTVhM2JkM2JiOTFmMCIsImlhdCI6MTYwNzg1MDIyNn0.ndu7Cyl3qkARCsyV-yy2UKgg8dB0yujU4QQrfYYrcCk';
  var role = '';
  var checkRemember = false;

  dynamic get _token {
    return [this.token];
  }

  void update(var _token) {
    token = _token;
    notifyListeners();
  }

  dynamic get _role {
    return [this.role];
  }

  void updateRole(var _role) {
    role = _role;
    notifyListeners();
  }

  dynamic get _checkRemember {
    return [this.checkRemember];
  }

  void updateCheckRemember(var _checkRemember) {
    checkRemember = _checkRemember;
    notifyListeners();
  }
}

import './account.dart';
import 'package:flutter/material.dart';

class Accounts with ChangeNotifier {
  var token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYTNiMzY0ZTY1OTVhM2JkM2JiOTFmMCIsImlhdCI6MTYwNjIwOTQzOH0.WiwSnThJvpLySCSGl-hERn_pfr6-vS91-958Owglp_Y';
  dynamic get _token {
    return [this.token];
  }

  void update(var _token) {
    token = _token;
    notifyListeners();
  }
}

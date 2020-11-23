import './account.dart';
import 'package:flutter/material.dart';

class Accounts with ChangeNotifier {
  var token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYTNiMzY0ZTY1OTVhM2JkM2JiOTFmMCIsImlhdCI6MTYwNjExNDAwMn0.FxEnbc3RapfGpKQZHHF4V93PwH3eEKosROUVlw7GdjM';
  dynamic get _token {
    return [this.token];
  }

  void update(var _token) {
    token = _token;
    notifyListeners();
  }
}

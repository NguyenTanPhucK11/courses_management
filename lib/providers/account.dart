import 'package:flutter/material.dart';

class Account {
  final String token;
  final String rules;
  final bool checkRemember;

  Account({@required this.token, @required this.rules, @required this.checkRemember});
}

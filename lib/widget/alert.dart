import 'package:course_management/data/sharedpref/shared_preference.dart';
import 'package:course_management/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertAdmin(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Icon(
      Icons.warning,
      color: Colors.red,
    ),
    content: Text("Tài khoản này chưa có quyền admin"),
    actions: [
      cancelButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertChooseRoom(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Icon(
      Icons.warning,
      color: Colors.red,
    ),
    content: Text("Chọn toà nhà trước !"),
    actions: [
      cancelButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertLogOutIOS(BuildContext context) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_outlined,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text("Log out?"),
          ],
        ),
        content: Text("Bạn muốn thoát phiên đăng nhập ?"),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          CupertinoDialogAction(
              textStyle: TextStyle(color: Colors.red),
              isDefaultAction: true,
              onPressed: () async {
                SharedPreferenceHelper.saveAuth('');
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login()));
              },
              child: Text("Log out")),
        ],
      ));
}

showAlertLogout(BuildContext context) {
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {
      SharedPreferenceHelper.saveAuth('');
      Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        Icon(
          Icons.login_outlined,
          color: Colors.red,
        ),
        Text(" Log out"),
      ],
    ),
    content: Text("Bạn muốn thoát phiên đăng nhập ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

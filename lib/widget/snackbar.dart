import 'package:flutter/material.dart';

Widget snackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    // action: SnackBarAction(
    //   label: 'Undo',
    //   onPressed: () {
    //     // Some code to undo the change.
    //   },
    // ),
  );

  // Find the Scaffold in the widget tree and use
  // it to show a SnackBar.
  Scaffold.of(context).showSnackBar(snackBar);
}


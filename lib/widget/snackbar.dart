import 'package:flutter/material.dart';

snackBar(GlobalKey<ScaffoldState> _key, String text, icons) async {
  return icons == null
      ? _key.currentState.showSnackBar(
          new SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                new Text(text),
              ],
            ),
          ),
        )
      : _key.currentState.showSnackBar(
          new SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                new Text(text),
                icons,
              ],
            ),
          ),
        );
}

import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  final Icon icons;
  final Color colors;
  final String nameId;
  final String nameValue;

  CourseInfo(this.icons, this.colors, this.nameId, this.nameValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(children: <Widget>[
        icons,
        Padding(
          padding: EdgeInsets.all(5),
        ),
        RichText(
          text: TextSpan(
              style: TextStyle(
                color: Colors.blueGrey[800],
              ),
              children: <TextSpan>[
                TextSpan(text: nameId),
                TextSpan(
                    text: nameValue,
                    style: TextStyle(
                      color: colors,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
        ),
      ]),
    );
  }
}

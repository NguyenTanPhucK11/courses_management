import 'package:course_management/providers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CourseInfo extends StatelessWidget {
  final FaIcon icons;
  final Color colors;
  final String nameId;
  final String nameValue;

  CourseInfo(this.icons, this.colors, this.nameId, this.nameValue);

  @override
  Widget build(BuildContext context) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Container(
      padding: EdgeInsets.all(12 * _scale),
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: icons,
        ),
        Expanded(
          flex: 7,
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        ),
      ]),
    );
  }
}

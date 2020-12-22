import 'dart:io';

import 'package:course_management/data/network/api/courses_api.dart';
import 'package:course_management/providers/courses.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/courses_listview.dart';
import './add_course.dart';
import '../providers/accounts.dart';

class CoursesOverviewScreen extends StatelessWidget {
  static const routeName = '/overview';

  @override
  Widget build(BuildContext context) {
    final idCourse = Provider.of<Courses>(context, listen: false).courses;
    if (idCourse.length == 0) fetchCourse(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: CoursesListView(),
      ),
    );
  }

  Widget _buildAppBar(context) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        child: IconButton(
          iconSize: 40 * _scale,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey[500],
          ),
          onPressed: () {
            Platform.isIOS ? alertLogOutIOS(context) : showAlertLogout(context);
          },
        ),
      ),
      title: Text(
        'QUẢN LÝ KHOÁ HỌC',
        style: TextStyle(
          fontSize: 40 * _scale,
          color: Colors.blueGrey[500],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 50 * _scale,
          icon: Icon(
            Icons.add,
            color: Colors.blueGrey[500],
          ),
          onPressed: () {
            // if (Provider.of<Accounts>(context, listen: false).role == 'admin') {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddCourse()));
            // } else {
            //   showAlertAdmin(context);
            // }
          },
        ),
      ],
    );
  }
}

import 'package:course_management/providers/accounts.dart';
import 'package:course_management/providers/classes.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/screens/add_class.dart';
import 'package:course_management/screens/courses_overview_screen.dart';
import 'package:course_management/widget/alert.dart';
import 'package:course_management/widget/class_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesOverview extends StatelessWidget {
  static const routeName = '/overview-class';
  String idCourse;
  ClassesOverview(@required this.idCourse);

  @override
  Widget build(BuildContext context) {
    print(idCourse);
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              iconSize: 40 * _scale,
              icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[500]),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoursesOverviewScreen()));
              }),
          title: Text(
            'QUẢN LÝ BUỔI HỌC',
            style: TextStyle(
              fontSize: 40 * _scale,
              color: Colors.blueGrey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 50 * _scale,
              icon: Icon(Icons.add, color: Colors.blueGrey[500]),
              onPressed: () {
                // if (Provider.of<Accounts>(context, listen: false).role ==
                //     'admin') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddClass(idCourse)));
                // } else {
                //   showAlertAdmin(context);
                // }
              },
            ),
          ],
        ),
        body: ClassListView(idCourse),
      ),
    );
  }
}

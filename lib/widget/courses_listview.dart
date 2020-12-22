import 'package:course_management/data/network/api/courses_api.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/screens/classes_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';
import './course_item.dart';

class CoursesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courseItemData = coursesData.courses;
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        fetchCourse(context);
      },
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 20 * _scale),
        padding: EdgeInsets.all(20 * _scale),
        itemCount: coursesData.courses.length,
        itemBuilder: (_, i) => GestureDetector(
          child: CourseItem(
              courseItemData[i].id,
              courseItemData[i].nameCourse,
              courseItemData[i].nameLectures,
              courseItemData[i].nameManager,
              courseItemData[i].date,
              courseItemData[i].building,
              courseItemData[i].room),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ClassesOverview(courseItemData[i].id)));
          },
        ),
      ),
    );
  }
}

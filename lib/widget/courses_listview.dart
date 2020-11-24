import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';

import './course_item.dart';

class CoursesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courseItemData = coursesData.courses;
    
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: coursesData.courses.length,
      itemBuilder: (_, i) => CourseItem(
          courseItemData[i].id,
          courseItemData[i].nameCourse,
          courseItemData[i].nameLectures,
          courseItemData[i].nameManager,
          courseItemData[i].date,
          courseItemData[i].building,
          courseItemData[i].room),
    );
  }
}

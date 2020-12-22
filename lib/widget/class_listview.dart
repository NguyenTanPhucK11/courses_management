import 'package:course_management/providers/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './class_item.dart';

class ClassListView extends StatelessWidget {
  final String idCourse;
  ClassListView(@required this.idCourse);
  @override
  Widget build(BuildContext context) {
    final classesData = Provider.of<Clss>(context);
    final classItemData = classesData.clss;
    print(classesData.clss);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        // fetchCourse(context);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: classesData.clss.length,
        itemBuilder: (_, i) => idCourse == classItemData[i].idCourse
            ? ClassItem(
                classItemData[i].id,
                classItemData[i].idCourse,
                classItemData[i].nameClass,
                classItemData[i].nameLectures,
                classItemData[i].nameManager,
                classItemData[i].date,
                classItemData[i].time,
                classItemData[i].building,
                classItemData[i].room)
            : Container(),
      ),
    );
  }
}

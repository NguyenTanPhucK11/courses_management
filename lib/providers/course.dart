import 'package:flutter/foundation.dart';

class Course {
  final String id;
  final String nameCourse;
  final String nameLectures;
  final String nameManager;
  final String date;
  final String building;
  final String room;

  Course({
    @required this.id,
    @required this.nameCourse,
    @required this.nameLectures,
    @required this.nameManager,
    @required this.date,
    @required this.building,
    @required this.room,
  });
}

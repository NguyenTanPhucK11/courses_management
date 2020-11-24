import 'package:flutter/material.dart';

import './course.dart';

class Courses with ChangeNotifier {
  List<Course> _courses = [
    // Course(
    //   id: 'p1',
    //   nameCourse: 'Giới thiệu hệ sinh thái bảo mật toàn diện của Cisco',
    //   nameLectures: 'Phan Từ Huy1',
    //   nameManager: 'trinhntk',
    //   date: '10/11/2020 - 10/11/2020',
    //   building: 'Tân Thuận 3',
    //   room: 'Chương Dương - Tầng 5',
    // ),
    // Course(
    //   id: 'p2',
    //   nameCourse: 'Giới thiệu hệ sinh thái bảo mật toàn diện của Cisco',
    //   nameLectures: 'Phan Từ Huy2',
    //   nameManager: 'trinhntk',
    //   date: '10/11/2020 - 10/11/2020',
    //   building: 'Tân Thuận 3',
    //   room: 'Chương Dương - Tầng 5',
    // ),
    // Course(
    //   id: 'p3',
    //   nameCourse: 'Giới thiệu hệ sinh thái bảo mật toàn diện của Cisco',
    //   nameLectures: 'Phan Từ Huy3',
    //   nameManager: 'trinhntk',
    //   date: '01/01/2020 - 01/11/2020',
    //   building: 'Tân Thuận 3',
    //   room: 'Chương Dương - Tầng 5',
    // ),
  ];

  List<Course> get courses {
    return [..._courses];
  }

  Course findById(String id) {
    return _courses.firstWhere((cour) => cour.id == id);
  }

  void addCourse(Course course) {
    final newCourse = Course(
        id: course.id,
        nameCourse: course.nameCourse,
        nameLectures: course.nameLectures,
        nameManager: course.nameManager,
        date: course.date,
        building: course.building,
        room: course.room);
    _courses.add(newCourse);
    notifyListeners();
  }

  void updateCourse(String id, Course newCourse) {
    final courIndex = _courses.indexWhere((cour) => cour.id == id);
    if (courIndex >= 0) {
      _courses[courIndex] = newCourse;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteCourse(String id) {
    _courses.removeWhere((cour) => cour.id == id);
    notifyListeners();
  }

  void remove() {
    _courses.clear();
    notifyListeners();
  }
}

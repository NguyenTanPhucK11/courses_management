import 'dart:convert';
import 'dart:io';

import 'package:courses_management/providers/courses.dart';
import 'package:courses_management/widget/course_item.dart';
import 'package:courses_management/widget/courses_listview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widget/courses_listview.dart';
import './add_course.dart';
import 'package:http/http.dart' as http;
import '../providers/course.dart';
import '../providers/accounts.dart';

Future<Album> fetchAlbum(BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  final response = await http.get(
    'http://10.86.224.37:5001/api/edu/get_all_course',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
  );
  var _album = Album.fromJson(jsonDecode(response.body)).data;
  for (var i = 0; i < _album.length; i++) {
    Provider.of<Courses>(context, listen: false).addCourse(Course(
      id: _album[i]['course_id'],
      nameCourse: _album[i]['courseName'],
      nameLectures: _album[i]['trainer'],
      nameManager: 'trinhntk',
      date: '${_album[i]['startedDate'].replaceAll('-', '/').substring(0,10)} - ${_album[i]['endedDate'].replaceAll('-', '/').substring(0,10)}',
      building: _album[i]['buildingName'],
      room: _album[i]['roomName'],
    ));
  }
  // print(_album[0]['courseName']);
  if (response.statusCode == 200) {
    if (Album.fromJson(jsonDecode(response.body)).resultCode == 1) {
      return Album.fromJson(jsonDecode(response.body));
    }
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int resultCode;
  final data;

  Album({this.resultCode, this.data});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      resultCode: json['resultCode'],
      data: json['data'],
    );
  }
}

class CoursesOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final idCourse = Provider.of<Courses>(context, listen: false).courses;
    if (idCourse.length == 0) fetchAlbum(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TẠO MỚI KHOÁ HỌC'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddCourse()));
            },
          ),
        ],
      ),
      body: CoursesListView(),
    );
  }
}
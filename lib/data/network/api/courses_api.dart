import 'dart:convert';
import 'dart:io';

import 'package:course_management/models/post.dart';
import 'package:course_management/providers/accounts.dart';
import 'package:course_management/providers/course.dart';
import 'package:course_management/providers/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<GetApi> fetchCourse(BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();

  String url = 'http://118.69.123.51:5000/fis/api/edu/get_all_course';
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
  );
  var _data = GetApi.fromJson(jsonDecode(response.body)).data;
  print(GetApi.fromJson(jsonDecode(response.body)).message);

  Provider.of<Courses>(context, listen: false).remove();
  for (var i = 0; i < _data.length; i++) {
    Provider.of<Courses>(context, listen: false).addCourse(Course(
      id: _data[i]['course_id'],
      nameCourse: _data[i]['courseName'],
      nameLectures: _data[i]['trainer'],
      nameManager: _data[i]['created_by'],
      date: _data[i]['startedDate'] == null || _data[i]['endedDate'] == null
          ? ''
          : '${_data[i]['startedDate'].replaceAll('-', '/').substring(0, 10)} - ${_data[i]['endedDate'].replaceAll('-', '/').substring(0, 10)}',
      building: _data[i]['buildingName'],
      room: _data[i]['roomName'],
    ));
  }
  print(GetApi.fromJson(jsonDecode(response.body)).message);
  if (response.statusCode == 200) {
    if (GetApi.fromJson(jsonDecode(response.body)).resultCode == 1) {
      return GetApi.fromJson(jsonDecode(response.body));
    }
  } else {
    throw Exception('Failed to get API !');
  }
}

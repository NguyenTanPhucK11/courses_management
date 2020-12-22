import 'dart:convert';
import 'dart:io';
import 'package:course_management/models/post.dart';
import 'package:course_management/providers/accounts.dart';
import 'package:course_management/providers/buildings_rooms.dart';
import 'package:course_management/providers/course.dart';
import 'package:course_management/screens/courses_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<GetApi> addCourse(Course course, BuildContext context, dateStart, dateEnd,
    int buildingId, int roomId) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  final _roomId = Provider.of<BuildingsRooms>(context, listen: false);
  final _buidingId = _roomId.listObjBuildingRoomId[buildingId];
  final http.Response response = await http.post(
    'http://118.69.123.51:5000/fis/api/edu/create_new_course',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
    body: jsonEncode(<String, String>{
      "courseName": course.nameCourse,
      "trainer": course.nameLectures,
      "startedDate": dateStart + 'T00:00:00.000Z',
      "endedDate": dateEnd + 'T00:00:00.000Z',
      "buildingId": _buidingId.keys
          .toString()
          .substring(1, _buidingId.keys.toString().length - 1),
      "roomId": _buidingId[_buidingId.keys
              .toString()
              .substring(1, _buidingId.keys.toString().length - 1)][roomId]
          .toString(),
    }),
  );

  print(GetApi.fromJson(jsonDecode(response.body)).message);
  if (GetApi.fromJson(jsonDecode(response.body)).resultCode == 1) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
  }
  if (response.statusCode == 200) {
    return GetApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get API !');
  }
}

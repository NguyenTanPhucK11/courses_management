import 'dart:convert';
import 'dart:io';

import 'package:courses_management/providers/accounts.dart';
import 'package:courses_management/screens/add_course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './course_info.dart';
import '../providers/courses.dart';
import 'package:http/http.dart' as http;

Future<Album> deleteAlbum(String idCourse, BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();

  var url = 'http://10.86.224.37:5001/api/edu/delete_course?courseId=';
  var urlParams = url + idCourse;
  final response = await http.get(
    urlParams.toString(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
  );
  print(Album.fromJson(jsonDecode(response.body)).message);
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int resultCode;
  final data;
  final String message;

  Album({this.resultCode, this.data, this.message});

  factory Album.fromJson(Map<String, dynamic> json) {
    // print("json: ${json['resultCode']}");
    return Album(
        resultCode: json['resultCode'],
        data: json['data'],
        message: json['message']);
  }
}

class CourseItem extends StatelessWidget {
  final String id;
  final String nameCourse;
  final String nameLectures;
  final String nameManager;
  final String date;
  final String building;
  final String room;

  Color _mainColor = Colors.blueGrey[800];

  CourseItem(this.id, this.nameCourse, this.nameLectures, this.nameManager,
      this.date, this.building, this.room);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding:
            const EdgeInsets.only(bottom: 20.0, top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Text(
                    nameCourse,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AddCourse.routeName,
                              arguments: id,
                            );
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                  // child: PopupMenuButton<int>(
                  //   itemBuilder: (context) => [],
                  //   elevation: 4,
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  // ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<Courses>(context, listen: false)
                                .deleteCourse(id);
                            deleteAlbum(id, context);
                          },
                          color: Theme.of(context).errorColor,
                        )
                ),
              ],
            ),
            CourseInfo(Icon(Icons.person, color: Colors.yellow),
                Colors.blue[300], 'Giảng viên: ', nameLectures),
            CourseInfo(Icon(Icons.contact_mail, color: Colors.purple),
                Colors.orange, 'Cán bộ quản lý: ', nameManager),
            CourseInfo(Icon(Icons.perm_contact_calendar, color: Colors.blue),
                _mainColor, 'Thời gian: ', date),
            CourseInfo(Icon(Icons.add_business, color: Colors.blueAccent),
                _mainColor, 'Toà nhà: ', building),
            CourseInfo(Icon(Icons.room_service, color: Colors.orange),
                _mainColor, 'Phòng: ', room),
          ],
        ),
      ),
    );
  }
}

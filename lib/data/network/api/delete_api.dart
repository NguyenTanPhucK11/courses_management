import 'dart:convert';
import 'dart:io';

import 'package:course_management/models/post.dart';
import 'package:course_management/providers/accounts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<GetApi> deleteCourse(String idCourse, BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  var url = 'http://118.69.123.51:5000/fis/api/edu/delete_course?courseId=';
  var urlParams = url + idCourse;
  final response = await http.get(
    urlParams.toString(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
  );
  print(GetApi.fromJson(jsonDecode(response.body)).message);
  if (response.statusCode == 200) {
    return GetApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get API !');
  }
}

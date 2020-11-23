import 'dart:developer';
import 'dart:math';

import 'package:courses_management/providers/accounts.dart';
import 'package:courses_management/providers/buildings_rooms.dart';
import 'package:courses_management/providers/courses.dart';
import 'package:courses_management/screens/courses_overview_screen.dart';
import 'package:courses_management/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/add_course.dart';
import './screens/login.dart';
import './providers/accounts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Courses(),
        ),
        ChangeNotifierProvider.value(
          value: BuildingsRooms(),
        ),
        ChangeNotifierProvider.value(
          value: Accounts(),
        )
      ],
      child: MaterialApp(
        title: 'My Courses',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login(),
        routes: {
          AddCourse.routeName : (ctx)=>AddCourse(),
        },
      ),
    );
  }
}

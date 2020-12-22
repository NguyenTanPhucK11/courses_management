import 'package:course_management/providers/classes.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/screens/add_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/login.dart';
import 'providers/accounts.dart';
import 'screens/add_course.dart';
import 'screens/courses_overview_screen.dart';
import './providers/courses.dart';
import 'providers/buildings_rooms.dart';

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
        ),
        ChangeNotifierProvider.value(
          value: Scales(),
        ),
        ChangeNotifierProvider.value(
          value: Clss(),
        ),
      ],
      child: MaterialApp(
        title: 'My Courses',
        theme: Theme.of(context).copyWith(
          appBarTheme: Theme.of(context)
              .appBarTheme
              .copyWith(brightness: Brightness.light),
        ),
        home: Login(),
        initialRoute: '/',
        routes: {
          AddCourse.routeName: (ctx) => AddCourse(),
          '/login': (ctx) => Login(),
          '/overview': (ctx) => CoursesOverviewScreen(),
          AddClass.routeName: (ctx) => AddClass(''),
        },
      ),
    );
  }
}

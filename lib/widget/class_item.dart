import 'package:course_management/providers/accounts.dart';
import 'package:course_management/providers/classes.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/screens/add_class.dart';
import 'package:course_management/widget/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'course_info.dart';

alertDeleteIOS(String id, BuildContext context) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text("Delete?"),
          ],
        ),
        content: Text("Bạn có muốn xoá buổi học ?"),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          CupertinoDialogAction(
              textStyle: TextStyle(color: Colors.red),
              isDefaultAction: true,
              onPressed: () async {
                Provider.of<Clss>(context, listen: false).deleteClass(id);
                Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    content: new Text('Xoá buổi học thành công !'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text("Delete")),
        ],
      ));
}

class ClassItem extends StatelessWidget {
  final String id;
  final String idCourse;
  final String nameCourse;
  final String nameLectures;
  final String nameManager;
  final String date;
  final String time;
  final String building;
  final String room;

  Color _mainColor = Colors.blueGrey[800];

  ClassItem(this.id, this.idCourse, this.nameCourse, this.nameLectures,
      this.nameManager, this.date, this.time, this.building, this.room);

  @override
  Widget build(BuildContext context) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Card(
      key: _scaffoldKey,
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60 * _scale,
                    child: PopupMenuButton<int>(
                      icon: FaIcon(
                        FontAwesomeIcons.ellipsisV,
                        size: 30 * _scale,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            // if (Provider.of<Accounts>(context, listen: false)
                            //         .role ==
                            //     'admin') {
                            Navigator.of(context).pushNamed(
                              AddClass.routeName,
                              arguments: id,
                            );
                            // } else {
                            //   showAlertAdmin(context);
                            // }
                            break;
                          case 2:
                            // if (Provider.of<Accounts>(context, listen: false)
                            //         .role ==
                            //     'admin')
                            alertDeleteIOS(id, context);
                            // else
                            //   showAlertAdmin(context);
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text('Edit')
                              ]),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  color: Theme.of(context).errorColor,
                                ),
                                Text('Delete')
                              ]),
                        )
                      ],
                      elevation: 4,
                      // padding: EdgeInsets.symmetric(horizontal: 50),
                    ),
                  ),
                ),
              ],
            ),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.userTie,
                  color: Colors.yellow,
                  size: 40 * _scale,
                ),
                Colors.blue[300],
                'Giảng viên: ',
                nameLectures),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.idCard,
                  color: Colors.deepPurple[400],
                  size: 40 * _scale,
                ),
                Colors.orange,
                'Cán bộ quản lý: ',
                nameManager),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.calendarCheck,
                  color: Colors.lightBlue,
                  size: 40 * _scale,
                ),
                _mainColor,
                'Ngày : ',
                date),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.lightGreen,
                  size: 40 * _scale,
                ),
                _mainColor,
                'Thời gian: ',
                time),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.solidBuilding,
                  color: Colors.blue,
                  size: 40 * _scale,
                ),
                _mainColor,
                'Toà nhà: ',
                building),
            CourseInfo(
                FaIcon(
                  FontAwesomeIcons.chalkboardTeacher,
                  color: Colors.orange,
                  size: 40 * _scale,
                ),
                _mainColor,
                'Phòng: ',
                room),
          ],
        ),
      ),
    );
  }
}

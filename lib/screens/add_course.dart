import 'dart:convert';
import 'dart:io';

import 'package:courses_management/providers/course.dart';
import 'package:courses_management/providers/courses.dart';
import 'package:courses_management/screens/courses_overview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/buildings_rooms.dart';
import 'package:http/http.dart' as http;
import '../providers/accounts.dart';

class AddCourse extends StatefulWidget {
  static const routeName = '/edit-course';

  @override
  _AddCourseState createState() => _AddCourseState();
}

Future<EditCourse> editCourses(String id, Course course, BuildContext context,
    dateStart, dateEnd, int buildingId, int roomId) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  // print(_token);
  final _roomId = Provider.of<BuildingsRooms>(context, listen: false);
  final _buidingId = _roomId.listObjBuildingRoomId[buildingId];
  final http.Response response = await http.post(
    'http://10.86.224.37:5001/api/edu/edit_course',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
    body: jsonEncode(<String, String>{
      "courseId": id,
      "courseName": course.nameCourse,
      "trainer": course.nameLectures,
      "startedDate": dateStart,
      "endedDate": dateEnd,
      "buildingId": _buidingId.keys
          .toString()
          .substring(1, _buidingId.keys.toString().length - 1),
      "roomId": _buidingId[_buidingId.keys
              .toString()
              .substring(1, _buidingId.keys.toString().length - 1)][roomId]
          .toString(),
    }),
  );
  print(EditCourse.fromJson(jsonDecode(response.body)).message);
  if (EditCourse.fromJson(jsonDecode(response.body)).resultCode == 1) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
  }
  if (response.statusCode == 200) {
    return EditCourse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class EditCourse {
  final int resultCode;
  final data;
  final String message;

  EditCourse({this.resultCode, this.data, this.message});

  factory EditCourse.fromJson(Map<String, dynamic> json) {
    // print("json: ${json['resultCode']}");
    return EditCourse(
        resultCode: json['resultCode'],
        data: json['data'],
        message: json['message']);
  }
}

Future<AlbumCourses> addCourse(Course course, BuildContext context, dateStart,
    dateEnd, int buildingId, int roomId) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  // print(_token);
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
      "startedDate": dateStart,
      "endedDate": dateEnd,
      "buildingId": _buidingId.keys
          .toString()
          .substring(1, _buidingId.keys.toString().length - 1),
      "roomId": _buidingId[_buidingId.keys
              .toString()
              .substring(1, _buidingId.keys.toString().length - 1)][roomId]
          .toString(),
    }),
  );
  print(AlbumCourses.fromJson(jsonDecode(response.body)).message);
  if (AlbumCourses.fromJson(jsonDecode(response.body)).resultCode == 1) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
  }
  if (response.statusCode == 200) {
    return AlbumCourses.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class AlbumCourses {
  final int resultCode;
  final data;
  final String message;

  AlbumCourses({this.resultCode, this.data, this.message});

  factory AlbumCourses.fromJson(Map<String, dynamic> json) {
    // print("json: ${json['resultCode']}");
    return AlbumCourses(
        resultCode: json['resultCode'],
        data: json['data'],
        message: json['message']);
  }
}

Future<Album> fetchAlbum(BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  final response = await http.get(
    'http://10.86.224.37:5001/api/edu/get_building',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Basic ${_token}",
    },
  );
  var _listBR;
  var _listBRId;
  var _data = Album.fromJson(jsonDecode(response.body)).data;
  final data = Provider.of<BuildingsRooms>(context, listen: false);
  _listBR = data.listObjBuildingRoom;
  _listBRId = data.listObjBuildingRoomId;
  for (var index = 0; index < _data.length; index++) {
    var listRoom = _listBR[index]
        [data.listObjBuildingRoom[index].keys.toString().substring(
              1,
              _listBR[index].keys.toString().length - 1,
            )];
    var listRoomId = _listBRId[index]
        [data.listObjBuildingRoomId[index].keys.toString().substring(
              1,
              _listBRId[index].keys.toString().length - 1,
            )];

    listRoom[0] = _data[index]['room'][0]['roomName'] +
        ' - ' +
        _data[index]['room'][0]['location'];
    listRoomId[0] = _data[index]['room'][0]['_id'];
    for (var i = 1; i < _data[index]['room'].length; i++) {
      listRoom.add(_data[index]['room'][i]['roomName'] +
          ' - ' +
          _data[index]['room'][i]['location']);
      listRoomId.add(_data[index]['room'][i]['_id']);
    }
  }
  Provider.of<BuildingsRooms>(context, listen: false).update(_listBR);
  Provider.of<BuildingsRooms>(context, listen: false).updateId(_listBRId);

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

class _AddCourseState extends State<AddCourse> {
  final _dateStart = TextEditingController();
  final _dateEnd = TextEditingController();
  final _nameCourse = TextEditingController();
  final _nameLecture = TextEditingController();

  final _colorBlue = Colors.blue[800];
  final _colorGrey = Colors.grey[300];
  final _keyNameCourse = GlobalKey<FormState>();
  final _keyNameLecture = GlobalKey<FormState>();
  final _form = GlobalKey<FormState>();
  String _dateTimeNow = DateFormat('yyyy-MM-dd').format(DateTime.now());

  int _selectedValueBuilding = 0;
  int _selectedValueRoom = 0;
  var _listBuilding = ['Keangnam'];
  var _listRoom = ['Berlin - Tầng 20'];
  var _listBR;
  var _isInit = true;

  var editCourse = Course(
    id: null,
    nameCourse: '',
    nameLectures: '',
    nameManager: '',
    date: '',
    building: '',
    room: '',
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final courseId = ModalRoute.of(context).settings.arguments as String;
      if (courseId != null) {
        editCourse =
            Provider.of<Courses>(context, listen: false).findById(courseId);
        _nameCourse.text = editCourse.nameCourse;
        _nameLecture.text = editCourse.nameLectures;
        _dateStart.text = editCourse.date.toString().substring(0, 10);
        _dateEnd.text = editCourse.date
            .toString()
            .substring(editCourse.date.length - 10, editCourse.date.length);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(dynamic dateStart, dynamic dateEnd) {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    editCourse = Course(
      id: editCourse.id,
      nameCourse: _nameCourse.text,
      nameLectures: _nameLecture.text,
      nameManager: 'trinkk',
      date: _dateStart.text + ' - ' + _dateEnd.text,
      building: _listBuilding[_selectedValueBuilding],
      room: _listRoom[_selectedValueRoom],
    );
    if (editCourse.id != null) {
      Provider.of<Courses>(context, listen: false)
          .updateCourse(editCourse.id, editCourse);
      editCourses(editCourse.id, editCourse, context, dateStart, dateEnd,
          _selectedValueBuilding, _selectedValueRoom);
    } else {
      Provider.of<Courses>(context, listen: false).addCourse(editCourse);
      addCourse(editCourse, context, dateStart, dateEnd, _selectedValueBuilding,
          _selectedValueRoom);
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CoursesOverviewScreen()));
  }

  String formatTime(int i) {
    return i < 10 ? '0' + i.toString() : i.toString();
  }

  Widget text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _colorBlue,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Widget dateTime(TextEditingController myController, Text textTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        textTime,
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.42,
          alignment: Alignment.center,
          child: TextFormField(
            readOnly: true,
            style: TextStyle(color: _colorBlue),
            controller: myController,
            decoration: InputDecoration(
              // hintText: _dateTimeNow.toString(),
              suffixIcon: Icon(Icons.today),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _colorGrey, width: 1.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _colorGrey, width: 1.0)),
            ),
            onTap: () {
              if (myController.text == "")
                myController.text = _dateTimeNow.toString();
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2010, 1, 1),
                  maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                myController.text =
                    '${formatTime(date.day)}/${formatTime(date.month)}/${date.year}';
              }, onConfirm: (date) {
                myController.text =
                    '${formatTime(date.day)}/${formatTime(date.month)}/${date.year}';
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
          ),
        ),
      ],
    );
  }

  Widget option(var list, showPicker) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        onPressed: showPicker,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${list}",
              style: TextStyle(color: _colorBlue),
            )),
      ),
    );
  }

  Widget nameInput(String name, GlobalKey<FormState> _key,
      TextEditingController myController) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Form(
        key: _key,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            return value.isEmpty ? 'Vui lòng ${name}' : null;
          },
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _colorGrey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _colorGrey, width: 1.0),
              ),
              hintText: name),
          textInputAction: TextInputAction.next,
          controller: myController,
        ),
      ),
    );
  }

  showPickerBuilding() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.width * 0.5,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedValueBuilding = value;
                  var _keysList = _listBR[value]
                      .keys
                      .toString()
                      .substring(1, _listBR[value].keys.toString().length - 1);
                  _listRoom = _listBR[value][_keysList];
                });
              },
              itemExtent: 32.0,
              children: [
                for (var itemBuilding in _listBuilding) Text(itemBuilding),
              ],
            ),
          );
        });
  }

  showPickerRoom() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.width * 0.5,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedValueRoom = value;
                });
              },
              itemExtent: 32.0,
              children: [
                for (var itemRoom in _listRoom) Text(itemRoom),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<BuildingsRooms>(context);
    _listBR = data.listObjBuildingRoom;
    var _keysList = _listBR[0]
        .keys
        .toString()
        .substring(1, _listBR[0].keys.toString().length - 1);
    if (_listRoom.length == 1) _listRoom = _listBR[0][_keysList];
    if (_listBuilding.length <= 1) {
      _listBuilding = [];
      for (var item in _listBR) _listBuilding.addAll(item.keys);
    }
    if (_dateStart.text == '') _dateStart.text = _dateTimeNow.toString();
    if (_dateEnd.text == '') _dateEnd.text = _dateTimeNow.toString();
    if (_listBR[0][_keysList].length <= 4) fetchAlbum(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TẠO MỚI KHOÁ HỌC'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Wrap(
            runSpacing: 10,
            children: <Widget>[
              text('Tên Khoá'),
              nameInput('Nhập tên khoá học', _keyNameCourse, _nameCourse),
              text('Giảng viên'),
              nameInput('Nhập tên giảng viên', _keyNameLecture, _nameLecture),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dateTime(_dateStart, text('Từ ngày')),
                  dateTime(_dateEnd, text('Đến ngày')),
                ],
              ),
              text('Toà nhà'),
              option(_listBuilding[_selectedValueBuilding], showPickerBuilding),
              text('Phòng'),
              option(_listRoom[_selectedValueRoom], showPickerRoom),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'LƯU',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (_keyNameCourse.currentState.validate() ||
                          _keyNameLecture.currentState.validate()) {
                        if (_keyNameCourse.currentState.validate() &&
                            _keyNameLecture.currentState.validate()) {
                          _saveForm(_dateStart.text, _dateEnd.text);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

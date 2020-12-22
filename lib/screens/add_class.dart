import 'package:course_management/data/network/api/buildings_api.dart';
import 'package:course_management/providers/class.dart';
import 'package:course_management/providers/classes.dart';
import 'package:course_management/providers/courses.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/screens/classes_overview.dart';
import 'package:course_management/widget/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/buildings_rooms.dart';

class AddClass extends StatefulWidget {
  static const routeName = '/edit-class';
  String idCourse;
  AddClass(@required this.idCourse);
  @override
  _AddClassState createState() => _AddClassState(idCourse);
}

class _AddClassState extends State<AddClass> {
  String idCourse = '';
  _AddClassState(@required this.idCourse);
  final _date = TextEditingController();
  final _timeStart = TextEditingController();
  final _timeEnd = TextEditingController();
  final _nameCourse = TextEditingController();
  final _nameLecture = TextEditingController();

  final _colorBlue = Colors.blue[800];
  final _colorGrey = Colors.grey[300];
  final _keyNameCourse = GlobalKey<FormState>();
  final _keyNameLecture = GlobalKey<FormState>();
  final _keyDate = GlobalKey<FormState>();
  final _keyTimeStart = GlobalKey<FormState>();
  final _keyTimeEnd = GlobalKey<FormState>();

  final _form = GlobalKey<FormState>();
  String _dateTimeNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _timeNow = DateFormat('H:mm').format(DateTime.now());

  var _timeStartNow = DateTime.now();

  int _selectedValueBuilding = 0;
  int _selectedValueRoom = 0;

  var _listBuilding = ['Chọn toà nhà'];
  var _listRoom = ['Chọn phòng'];
  var _listBR;
  var _isInit = true;
  var _textTitle;
  String _dateCourse;

  var editClass = Cls(
    id: null,
    idCourse: '',
    nameClass: '',
    nameLectures: '',
    nameManager: '',
    date: '',
    time: '',
    building: '',
    room: '',
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final clsId = ModalRoute.of(context).settings.arguments as String;

      if (clsId != null) {
        _textTitle = Text(
          'CHỈNH SỬA BUỔI HỌC',
          style: TextStyle(
            color: Colors.blueGrey[500],
            fontWeight: FontWeight.bold,
          ),
        );
        editClass =
            Provider.of<Clss>(context, listen: false).findByIdCls(clsId);
        _nameCourse.text = editClass.nameClass;
        _nameLecture.text = editClass.nameLectures;
        _date.text = editClass.date.toString();
        _timeStart.text = editClass.time.toString().substring(0, 5);
        _timeEnd.text =
            editClass.time.toString().substring(8, editClass.time.length);
        idCourse = editClass.idCourse;
        _fetchBR();
        _selectedValueBuilding = _listBuilding.indexOf(editClass.building);
        _listRoom = _listBR[_listBuilding.indexOf(editClass.building)]
            [editClass.building];
        _selectedValueRoom = _listRoom
            .indexWhere((element) => element.startsWith(editClass.room));
      } else {
        _textTitle = Text(
          'TẠO MỚI BUỔI HỌC',
          style: TextStyle(
            color: Colors.blueGrey[500],
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(_key) async {
    final isValid = _form.currentState.validate();
    final _data = Provider.of<Clss>(context, listen: false);
    if (!isValid) return;
    _form.currentState.save();
    editClass = Cls(
      id: editClass.id,
      idCourse: idCourse,
      nameClass: _nameCourse.text,
      nameLectures: _nameLecture.text,
      nameManager: 'trinkk',
      date: _date.text,
      time: _timeStart.text + ' - ' + _timeEnd.text,
      building: _listBuilding[_selectedValueBuilding],
      room: _listRoom[_selectedValueRoom],
    );
    editClass.idCourse = idCourse;
    if (editClass.id != null) {
      _data.updateClass(editClass.id, editClass);
    } else {
      _data.addClass(editClass);

      snackBar(_key, 'Thêm buổi học thành công !', null);
      await Future.delayed(Duration(milliseconds: 300));
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ClassesOverview(idCourse)));
  }

  String formatDay(int i) {
    return i < 10 ? '0' + i.toString() : i.toString();
  }

  String formatTime(int i) {
    return i == 0
        ? '00'
        : i < 10
            ? '0' + i.toString()
            : i.toString();
  }

  Widget text(String text, bool ness) {
    return RichText(
      text: TextSpan(
          style: TextStyle(
            color: Colors.blueGrey[800],
          ),
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: TextStyle(
                color: _colorBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            TextSpan(
                text: ness ? ' *' : '',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                )),
          ]),
    );
  }

  Widget dateTime(TextEditingController myController, RichText textTime,
      bool time, GlobalKey<FormState> _key) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textTime,
          SizedBox(height: 10),
          Container(
            width: !time
                ? MediaQuery.of(context).size.width * 0.9 * _scale
                : MediaQuery.of(context).size.width * 0.7 * _scale,
            alignment: Alignment.center,
            child: TextFormField(
              validator: (value) {
                return value.isEmpty ? 'Vui lòng chọn time' : null;
              },
              readOnly: true,
              style: TextStyle(color: _colorBlue),
              controller: myController,
              decoration: InputDecoration(
                hintText: !time ? '' : _timeNow.toString(),
                suffixIcon: Icon(Icons.today),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _colorGrey, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _colorGrey, width: 1.0)),
              ),
              onTap: () {
                if (myController.text == "") {
                  myController.text =
                      !time ? _dateTimeNow.toString() : _timeNow.toString();
                  _key.currentState.validate();
                }
                !time
                    ? DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(
                            int.parse(_dateCourse.substring(0, 4)),
                            int.parse(_dateCourse.substring(5, 7)),
                            int.parse(_dateCourse.substring(8, 10))),
                        maxTime: DateTime(
                            int.parse(_dateCourse.substring(13, 17)),
                            int.parse(_dateCourse.substring(18, 20)),
                            int.parse(_dateCourse.substring(21, 23))),
                        onChanged: (date) {
                        myController.text =
                            '${date.year}-${formatDay(date.month)}-${formatDay(date.day)}';
                      }, onConfirm: (date) {
                        myController.text =
                            '${date.year}-${formatDay(date.month)}-${formatDay(date.day)}';
                      }, currentTime: DateTime.now(), locale: LocaleType.en)
                    : DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                        _key.currentState.validate();
                        myController.text =
                            '${formatTime(date.hour)}:${formatTime(date.minute)}';
                      }, onConfirm: (date) {
                        _key.currentState.validate();
                        myController.text =
                            '${formatTime(date.hour)}:${formatTime(date.minute)}';
                      },
                        currentTime:
                            DateTime.parse('20201212 ${myController.text}:00'),
                        locale: LocaleType.en);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget option(var list, showPicker, bool isBuilding) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.blueGrey[50],
          ),
        ),
        onPressed: () {
          if (isBuilding || (!isBuilding && _listBuilding.length > 1)) {
            setState(() {
              _fetchBR();
            });
            showPicker();
          }
        },
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
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            _key.currentState.validate();
          },
          // readOnly: true,
          // inputFormatters: [
          //   WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s"))
          // ],
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            return (value.isEmpty || value.trim().isEmpty)
                ? 'Vui lòng ${name}'
                : null;
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
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CupertinoButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                        ),
                        CupertinoButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedValueBuilding != 0
                                ? _selectedValueBuilding
                                : 0),
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _selectedValueBuilding = value;
                            var _keysList = _listBR[value]
                                .keys
                                .toString()
                                .substring(1,
                                    _listBR[value].keys.toString().length - 1);
                            _listRoom = _listBR[value][_keysList];
                            if (_selectedValueRoom >
                                _listBR[value][_keysList].length - 1)
                              _selectedValueRoom =
                                  _listBR[value][_keysList].length - 1;
                          });
                        },
                        itemExtent: 32.0,
                        children: [
                          for (var itemBuilding in _listBuilding)
                            Text(itemBuilding),
                        ],
                      ),
                    )
                  ]));
        });
  }

  showPickerRoom() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CupertinoButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                        ),
                        CupertinoButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0,
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedValueRoom != 0
                                ? _selectedValueRoom
                                : 0),
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            if (_selectedValueRoom > _listRoom.length)
                              _selectedValueRoom = _listRoom.length;
                            else
                              _selectedValueRoom = value;
                          });
                        },
                        itemExtent: 32.0,
                        children: [
                          for (var itemRoom in _listRoom) Text(itemRoom),
                        ],
                      ),
                    )
                  ]));
        });
  }

  int compareTime(String timeStart, String timeEnd) {
    DateTime _timeStart = DateTime.parse("20120227 " + timeStart + ":00");
    DateTime _timeEnd = DateTime.parse("20120227 " + timeEnd + ":00");
    final diffence = _timeStart.difference(_timeEnd).inMinutes;
    return diffence;
  }

  bool timeOut(DateTime time) {
    int _timeOut = time.difference(_timeStartNow).inMilliseconds;
    if (_timeOut >= 1400) {
      _timeStartNow = time;
      return true;
    }
  }

  _fetchBR() {
    final data = Provider.of<BuildingsRooms>(context, listen: false);
    _listBR = data.listObjBuildingRoom;
    var _keysList = _listBR[0]
        .keys
        .toString()
        .substring(1, _listBR[0].keys.toString().length - 1);
    if (_listRoom.length <= 1) _listRoom = _listBR[0][_keysList];
    if (_listBuilding.length <= 1) {
      _listBuilding = [];
      for (var item in _listBR) _listBuilding.addAll(item.keys);
    }

    if (_listBR[0][_keysList].length <= 1) fetchBR(context);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    _dateCourse =
        Provider.of<Courses>(context, listen: false).findById(idCourse).date;
    if (_date.text == '')
      _date.text = Provider.of<Courses>(context, listen: false)
          .findById(idCourse)
          .date
          .substring(0, 10)
          .replaceAll('/', '-');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _key,
          appBar: _buildAppBar(),
          body: _buildBody(_key),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[200]),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: _textTitle,
    );
  }

  Widget _buildBody(_key) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _form,
        child: Wrap(
          runSpacing: 10,
          children: <Widget>[
            text('Tên buổi học', false),
            nameInput('Nhập tên buổi học', _keyNameCourse, _nameCourse),
            text('Giảng viên', false),
            nameInput('Nhập tên giảng viên', _keyNameLecture, _nameLecture),
            dateTime(_date, text('Ngày', true), false, _keyDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dateTime(
                    _timeStart, text('Giờ bắt đầu', true), true, _keyTimeStart),
                dateTime(_timeEnd, text('Giờ ', true), true, _keyTimeEnd),
              ],
            ),
            text('Toà nhà', false),
            option(_listBuilding[_selectedValueBuilding], showPickerBuilding,
                true),
            text('Phòng', false),
            option(_listRoom[_selectedValueRoom], showPickerRoom, false),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8 * _scale,
                height: MediaQuery.of(context).size.height * 0.1 * _scale,
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
                        _keyNameLecture.currentState.validate() ||
                        _keyTimeEnd.currentState.validate() ||
                        _keyTimeStart.currentState.validate()) {
                      if (_keyNameCourse.currentState.validate() &&
                          _keyNameLecture.currentState.validate() &&
                          _keyTimeStart.currentState.validate() &&
                          _keyTimeEnd.currentState.validate()) {
                        // if (compareDate(_date.text, _date.text) <= 0)
                        if (compareTime(_timeStart.text, _timeEnd.text) <= 0 &&
                            _listBuilding.length > 1) {
                          _saveForm(_key);
                        } else {
                          var now = new DateTime.now();
                          if (timeOut(now) == true) {
                            snackBar(
                                _key,
                                compareTime(_timeStart.text, _timeEnd.text) > 0
                                    ? 'Giờ bắt đầu phải nhỏ hơn giờ kết thúc !'
                                    : 'Vui lòng chọn toà nhà và phòng !',
                                Icon(
                                  Icons.warning,
                                  color: Colors.yellow,
                                ));
                          }
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

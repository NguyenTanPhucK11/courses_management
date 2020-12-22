import 'package:course_management/data/network/api/add_api.dart';
import 'package:course_management/data/network/api/buildings_api.dart';
import 'package:course_management/data/network/api/edit_api.dart';
import 'package:course_management/providers/course.dart';
import 'package:course_management/providers/courses.dart';
import 'package:course_management/providers/responsive.dart';
import 'package:course_management/widget/alert.dart';
import 'package:course_management/widget/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/buildings_rooms.dart';

class AddCourse extends StatefulWidget {
  static const routeName = '/edit-course';

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String _dateTimeNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Text _textTitle;
  int _selectedValueBuilding = 0;
  int _selectedValueRoom = 0;

  final _dateStart = TextEditingController();
  final _dateEnd = TextEditingController();
  final _nameCourse = TextEditingController();
  final _nameLecture = TextEditingController();
  final _colorBlue = Colors.blue[800];
  final _colorGrey = Colors.grey[300];
  final _keyNameCourse = GlobalKey<FormState>();
  final _keyNameLecture = GlobalKey<FormState>();
  final _keyDateStart = GlobalKey<FormState>();
  final _keyDateEnd = GlobalKey<FormState>();
  final _form = GlobalKey<FormState>();

  var _timeStart = DateTime.now();
  var _listBuilding = ['Chọn toà nhà'];
  var _listRoom = ['Chọn phòng'];
  var _listBR;
  var _isInit = true;
  var _isChooseBR = false;
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final courseId = ModalRoute.of(context).settings.arguments as String;
      if (courseId != null) {
        _textTitle = Text(
          'CHỈNH SỬA KHOÁ HỌC',
          style: TextStyle(
            color: Colors.blueGrey[500],
            fontWeight: FontWeight.bold,
          ),
        );

        editCourse =
            Provider.of<Courses>(context, listen: false).findById(courseId);
        _nameCourse.text = editCourse.nameCourse;
        _nameLecture.text = editCourse.nameLectures;
        _dateStart.text =
            editCourse.date.toString().substring(0, 10).replaceAll('/', '-');
        _dateEnd.text = editCourse.date
            .toString()
            .substring(editCourse.date.length - 10, editCourse.date.length)
            .replaceAll('/', '-');
        _fetchBR();
        _selectedValueBuilding = _listBuilding.indexOf(editCourse.building);
        _listRoom = _listBR[_listBuilding.indexOf(editCourse.building)]
            [editCourse.building];
        _selectedValueRoom = _listRoom
            .indexWhere((element) => element.startsWith(editCourse.room));
      } else
        _textTitle = Text(
          'TẠO MỚI KHOÁ HỌC',
          style: TextStyle(
            color: Colors.blueGrey[500],
            fontWeight: FontWeight.bold,
          ),
        );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(_key) async {
    final isValid = _form.currentState.validate();
    final _data = Provider.of<Courses>(context, listen: false);
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
      _data.updateCourse(editCourse.id, editCourse);
      snackBar(_key, 'Chỉnh sửa khoá học thành công !', null);
      await Future.delayed(Duration(milliseconds: 300));
      editCourses(editCourse.id, editCourse, context, _dateStart.text,
          _dateEnd.text, _selectedValueBuilding, _selectedValueRoom);
      _data.remove();
    } else {
      _data.addCourse(editCourse);
      snackBar(_key, 'Thêm khoá học thành công !', null);
      await Future.delayed(Duration(milliseconds: 300));
      addCourse(editCourse, context, _dateStart.text, _dateEnd.text,
          _selectedValueBuilding, _selectedValueRoom);
      _data.remove();
    }
  }

  String formatTime(int i) {
    return i < 10 ? '0' + i.toString() : i.toString();
  }

  Widget text(String text, i) {
    return Text(
      text,
      style: TextStyle(
        color: _colorBlue,
        fontWeight: FontWeight.bold,
        fontSize: 32 * i,
      ),
    );
  }

  Widget dateTime(GlobalKey<FormState> _key, TextEditingController myController,
      Text textTime, String _text, bool isDateStart) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    DateTime _date;
    //     DateTime.parse(myController.text.replaceAll('-', '') + 'T14Z');
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textTime,
          SizedBox(height: 20 * _scale),
          Container(
            width: MediaQuery.of(context).size.width * 0.44,
            alignment: Alignment.center,
            child: TextFormField(
              onChanged: (value) {},
              validator: (value) {
                return value.isEmpty ? 'Vui lòng nhập ${_text}' : null;
              },
              readOnly: true,
              style: TextStyle(color: _colorBlue),
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Chọn ngày',
                suffixIcon: Icon(Icons.today),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _colorGrey, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _colorGrey, width: 1.0)),
              ),
              onTap: () {
                _date = DateTime.now();
                if (isDateStart || (!isDateStart && _dateStart.text != '')) {
                  if (myController.text == '') {
                    myController.text = _dateTimeNow.toString();
                    _key.currentState.validate();
                    if (compareDate(_dateStart.text, _dateTimeNow) > 0)
                      myController.text = _dateStart.text;
                  }

                  _date = DateTime.parse(myController.text.replaceAll('-', ''));
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: !isDateStart
                          ? DateTime(
                              int.parse(_dateStart.text.substring(0, 4)),
                              int.parse(_dateStart.text.substring(5, 7)),
                              int.parse(_dateStart.text.substring(8, 10)))
                          : DateTime(2010, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                    myController.text =
                        '${date.year}-${formatTime(date.month)}-${formatTime(date.day)}';
                    _key.currentState.validate();
                    if (compareDate(_dateStart.text, _dateEnd.text) > 0) {
                      _dateEnd.text = _dateStart.text;
                    }
                  }, onConfirm: (date) {
                    _key.currentState.validate();
                    myController.text =
                        '${date.year}-${formatTime(date.month)}-${formatTime(date.day)}';
                    if (compareDate(_dateStart.text, _dateEnd.text) > 0) {
                      _dateEnd.text = _dateStart.text;
                    }
                  }, currentTime: _date, locale: LocaleType.en);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget option(var list, Function showPicker, bool isBuilding) {
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Container(
      width: MediaQuery.of(context).size.width * 2 * _scale,
      height: 110 * _scale,
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
              _isChooseBR = false;
              _fetchBR();
            });
            showPicker();
          } else
            alertChooseRoom(context);
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
    var _scale = Provider.of<Scales>(context, listen: false).scale(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Container(
      height: 125 * _scale,
      width: MediaQuery.of(context).size.width * 1.9 * _scale,
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
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: _selectedValueBuilding != 0
                              ? _selectedValueBuilding
                              : 0),
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _fetchBR();
                          _selectedValueBuilding = value;
                          var _keysList = _listBR[value]
                              .keys
                              .toString()
                              .substring(
                                  1, _listBR[value].keys.toString().length - 1);
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
                ]),
          );
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

  int compareDate(String dateStart, String dateEnd) {
    DateTime _dateStart =
        DateTime.parse(dateStart.replaceAll('/', '-') + 'T14Z');
    DateTime _dateEnd = dateEnd != ''
        ? DateTime.parse(dateEnd.replaceAll('/', '-') + 'T14Z')
        : _dateStart;
    final diffence = _dateStart.difference(_dateEnd).inDays;
    return (dateStart != '' || dateEnd != null) ? diffence : 0;
  }

  bool timeOut(time) {
    int _timeOut = time.difference(_timeStart).inMilliseconds;
    if (_timeOut >= 1400) {
      _timeStart = time;
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
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
      padding: EdgeInsets.all(40 * _scale),
      child: Form(
        key: _form,
        child: Wrap(
          runSpacing: 20 * _scale,
          children: <Widget>[
            text('Tên Khoá', _scale),
            nameInput('Nhập tên khoá học', _keyNameCourse, _nameCourse),
            text('Giảng viên', _scale),
            nameInput('Nhập tên giảng viên', _keyNameLecture, _nameLecture),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dateTime(_keyDateStart, _dateStart, text('Từ ngày', _scale),
                    'ngày bắt đầu!', true),
                dateTime(_keyDateEnd, _dateEnd, text('Đến ngày', _scale),
                    'ngày kết thúc', false),
              ],
            ),
            text('Toà nhà', _scale),
            option(_listBuilding[_selectedValueBuilding], showPickerBuilding,
                true),
            _isChooseBR
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Vui lòng chọn toà nhà!',
                          style: TextStyle(
                              color: Colors.red[700], fontSize: 25 * _scale),
                        ),
                      ),
                      SizedBox(height: 20 * _scale),
                      text('Phòng', _scale),
                    ],
                  )
                : Column(),
            option(_listRoom[_selectedValueRoom], showPickerRoom, false),
            _isChooseBR
                ? Container(
                    child: Text(
                      'Vui lòng chọn phòng!',
                      style: TextStyle(
                          color: Colors.red[700], fontSize: 25 * _scale),
                    ),
                  )
                : Column(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8 * _scale,
                height: MediaQuery.of(context).size.height * 0.1 * _scale,
                child: RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20 * _scale)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20 * _scale),
                      Text(
                        'LƯU',
                        style: TextStyle(
                          fontSize: 40 * _scale,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _listBuilding.length > 1
                        ? setState(() {
                            _isChooseBR = false;
                          })
                        : setState(() {
                            _isChooseBR = true;
                          });

                    if (_keyNameCourse.currentState.validate() ||
                        _keyNameLecture.currentState.validate() ||
                        _keyDateEnd.currentState.validate() ||
                        _keyDateStart.currentState.validate()) {
                      if (_keyNameCourse.currentState.validate() &&
                          _keyNameLecture.currentState.validate() &&
                          _keyDateStart.currentState.validate() &&
                          _keyDateEnd.currentState.validate()) {
                        _nameCourse.text = _nameCourse.text
                            .trim()
                            .replaceAll(RegExp('\\s+'), ' ');
                        _nameLecture.text = _nameLecture.text
                            .trim()
                            .replaceAll(RegExp('\\s+'), ' ');
                        if (!_isChooseBR) _saveForm(_key);
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

import 'package:flutter/material.dart';

import './class.dart';

class Clss with ChangeNotifier {
  List<Cls> _clss = [
    Cls(
      id: '0',
      idCourse: '5fcdfcca39dd753bc70da882',
      nameClass: 'Giới thiệu hệ sinh thái bảo mật toàn diện của Cisco',
      nameLectures: 'Phan Từ Huy1',
      nameManager: 'trinhntk',
      date: '2020-12-20',
      time: "13:30 - 15:30",
      building: 'Tân Thuận 3',
      room: 'Chương Dương - Tầng 5',
    ),
    Cls(
      id: '1',
      idCourse: '5fcf182ae6595a3bd3bb96d0',
      nameClass: 'Giới thiệu hệ sinh thái bảo mật toàn diện của Cisco',
      nameLectures: 'Phan Từ Huy2',
      nameManager: 'trinhntk',
      date: '2020-12-24',
      time: "09:30 - 10:30",
      building: 'Tân Thuận 3',
      room: 'Nhà Bè - Tầng 2',
    ),
    Cls(
      id: '2',
      idCourse: '5fcf182ae6595a3bd3bb96d0',
      nameClass: 'Giới thiệu hệ sinh thái bảo mật toàn diện của a',
      nameLectures: 'Phan Từ Huy2',
      nameManager: 'trinhntk',
      date: '2020-12-24',
      time: "09:30 - 11:00",
      building: 'Keangnam',
      room: 'Thang Long - Tầng 22',
    ),
  ];

  List<Cls> get clss {
    return [..._clss];
  }

  Cls findByIdCls(String id) {
    return _clss.firstWhere((clss) => clss.id == id);
  }

  Cls findByIdCourses(String idCourse) {
    return _clss.firstWhere((clss) => clss.idCourse == idCourse);
  }

  void addClass(Cls cls) {
    final newClass = Cls(
        id: (_clss.length).toString(),
        idCourse: cls.idCourse,
        nameClass: cls.nameClass,
        nameLectures: cls.nameLectures,
        nameManager: cls.nameManager,
        date: cls.date,
        time: cls.time,
        building: cls.building,
        room: cls.room);
    _clss.add(newClass);
    notifyListeners();
  }

  void updateClass(String id, Cls newCls) {
    final clssIndex = _clss.indexWhere((clss) => clss.id == id);
    if (clssIndex >= 0) {
      _clss[clssIndex] = newCls;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteClass(String id) {
    _clss.removeWhere((clss) => clss.id == id);
    notifyListeners();
  }

  void remove() {
    _clss.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import './building_room.dart';

class BuildingsRooms with ChangeNotifier {
  var listObjBuildingRoom = [
    {
      'Keangnam': [
        'Berlin - Tầng 20',
      ],
    },
    {
      'Tân Thuận 3': [
        'Tân Thuận 1',
      ],
    },
  ];

  var listObjBuildingRoomId = [
    {
      '5dcd0d9aa7717013a85cbf7a': [
        '5dde364030791013bce3f178',
      ],
    },
    {
      '5dde35040fdb380da04d1e7a': [
        '5dde364030791013bce3f178',
      ],
    },
  ];

  dynamic get _listObjBuildingRoom {
    return [...listObjBuildingRoom];
  }

  dynamic get _listObjBuildingRoomId {
    return [...listObjBuildingRoomId];
  }

  void update(var list) {
    listObjBuildingRoom = list;
    notifyListeners();
  }

  void updateId(var list) {
    listObjBuildingRoomId = list;
    notifyListeners();
  }
}

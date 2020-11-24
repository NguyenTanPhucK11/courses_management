import 'dart:convert';
import 'dart:io';

import 'package:courses_management/models/post.dart';
import 'package:flutter/material.dart';
import './building_room.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'accounts.dart';

Future<Album> fetchBR(BuildContext context) async {
  final _token = Provider.of<Accounts>(context, listen: false).token.toString();
  final response = await http.get(
    'http://118.69.123.51:5000/fis/api/edu/get_building',
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

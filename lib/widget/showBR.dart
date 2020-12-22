import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showPickerRoom(BuildContext context, _selectedValueRoom, _listRoom) {
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
                          initialItem:
                              _selectedValueRoom != 0 ? _selectedValueRoom : 0),
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (value) {
                        if (_selectedValueRoom > _listRoom.length)
                          _selectedValueRoom = _listRoom.length;
                        else
                          _selectedValueRoom = value;
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

void setState(Null Function() param0) {}

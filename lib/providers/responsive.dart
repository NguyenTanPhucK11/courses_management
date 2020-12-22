import 'package:flutter/material.dart';
import 'dart:math';

const WIDTH = 828;
const HEIGHT = 1640;

class Scale {
  final double width;
  final double height;

  Scale({
    @required this.width,
    @required this.height,
  });
}

class Scales with ChangeNotifier {
  scale(width, height) {
    return sqrt(pow(width, 2) + pow(height, 2)) /
        sqrt(pow(WIDTH, 2) + pow(HEIGHT, 2));
  }
}

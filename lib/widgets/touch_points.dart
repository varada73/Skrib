import 'package:flutter/material.dart';

class TouchPoints {
  Paint? paint;
  Offset points;
  TouchPoints({required this.paint, required this.points});
  Map<String, dynamic> toJSON() {
    return {
      'point': {'dx': points.dx.toString(), 'dy': points.dy.toString()}
    };
  }
}

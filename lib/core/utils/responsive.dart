import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late final double _width;
  late final double _height;

  Responsive(this.context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  double get width => _width;
  double get height => _height;

  // Fluid scale based on width
  double w(double value) => _width * (value / 375);
  double h(double value) => _height * (value / 812);
  double sp(double value) => _width * (value / 375);

  bool get isSmall => _width < 360;
  bool get isMedium => _width >= 360 && _width < 600;
  bool get isTablet => _width >= 600;

  int get gridCrossAxisCount {
    if (_width >= 900) return 4;
    if (_width >= 600) return 3;
    return 2;
  }

  double get gridChildAspectRatio {
    if (_width >= 600) return 0.65;
    return 0.62;
  }

  double get horizontalPadding {
    if (_width >= 600) return _width * 0.04;
    return 12;
  }
}

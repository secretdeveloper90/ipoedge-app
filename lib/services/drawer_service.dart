import 'package:flutter/material.dart';

class DrawerService {
  static final DrawerService _instance = DrawerService._internal();
  factory DrawerService() => _instance;
  DrawerService._internal();

  GlobalKey<ScaffoldState>? _scaffoldKey;

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
  }

  void openDrawer() {
    if (_scaffoldKey?.currentState != null && 
        _scaffoldKey!.currentState!.hasDrawer) {
      _scaffoldKey!.currentState!.openDrawer();
    }
  }

  bool get hasDrawer => 
      _scaffoldKey?.currentState?.hasDrawer ?? false;
}

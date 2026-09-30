import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int get selectedTab => _selectedTab;
  int _selectedTab = 0;
  void selectTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void backHome() => selectTab(0);
}

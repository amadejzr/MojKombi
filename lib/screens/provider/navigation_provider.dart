import 'package:flutter/material.dart';
import 'package:mycombi/screens/model/navigation_item.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationItem _navigationItem = NavigationItem.kombiji;

  NavigationItem get navigationItem => _navigationItem;

  void setNavigationItem(NavigationItem navigationItem) {
    _navigationItem = navigationItem;

    notifyListeners();
  }
}

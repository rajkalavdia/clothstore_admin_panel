import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onItemTapped(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

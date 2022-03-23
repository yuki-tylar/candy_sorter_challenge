import 'package:flutter/material.dart';

class GameSettingProvider extends ChangeNotifier {
  Duration get timerDuration => _timerDuration;
  int get numOfCandies => _numOfCandies;
  int get numOfColors => _numOfColors;

  Duration _timerDuration = const Duration(minutes: 5);
  int _numOfCandies = 100;
  int _numOfColors = 2;

  setTimerDuration(Duration duration) {
    _timerDuration = duration;
    notifyListeners();
  }

  setNumOfCandies(int num) {
    _numOfCandies = num;
    notifyListeners();
  }

  setNumOfColors(int num) {
    _numOfColors = num;
    notifyListeners();
  }
}

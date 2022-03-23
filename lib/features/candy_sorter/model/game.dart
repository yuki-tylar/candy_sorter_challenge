import 'dart:math';

import 'package:candy_sorter/features/candy_sorter/model/model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Game {
  Game({
    required int numberOfColors,
    required int numberOfCandies,
    Duration timerDuration = const Duration(minutes: 7),
    this.gameArea = const Size(0, 0),
  }) {
    _numberOfColors = numberOfColors;
    _numberOfCandies = numberOfCandies;
    _timerDuration = timerDuration;
    _timerController = StreamController();
    _timerController.add(_timerDuration);
    _statusController = StreamController<Status>();
    _statusController.add(status);
    _fillColors();
    _fillCandies();
  }

  Status get status => _status;

  StreamController<Duration> get timerController => _timerController;
  StreamController<Status> get statusController => _statusController;

  int get numberOfCandies => _numberOfCandies;
  int get numberOfLeft => candies.length;
  int get numberOfSorted => _numberOfCandies - numberOfLeft;

  List<Candy> get candies => _candies;
  Duration get timerDuration => _timerDuration;

  List<Color> get colors => _colors;
  int get numberOfColors => _numberOfColors;

  late int _numberOfCandies;
  late int _numberOfColors;
  List<Color> _colors = [];
  List<Candy> _candies = [];
  final Size gameArea;

  late StreamController<Duration> _timerController;
  late StreamController<Status> _statusController;
  var _status = Status.notStarted;
  late Duration _timerDuration;
  Timer? _timer;

  setNumberOfCandies(int num) {
    _numberOfCandies = num;
    _fillCandies();
  }

  setTimeDuration(Duration duration) {
    _timerDuration = duration;
  }

  setNumberOfColors(int num) {
    _numberOfColors = num;
    _fillColors();
    _fillCandies();
  }

  start() {
    _status = Status.started;
    _statusController.add(_status);

    const interval = Duration(milliseconds: 100);
    _timer = Timer.periodic(interval, (timer) {
      _timerDuration -= interval;
      if (_timerDuration.compareTo(Duration.zero) <= 0) {
        _timerDuration = Duration.zero;
        stop(status: Status.failed);
      }
      timerController.add(timerDuration);
    });
  }

  stop({Status status = Status.completed}) {
    _statusController.add(status);
    _timer?.cancel();
  }

  void removeCandy(Candy candy) {
    candies.remove(candy);
    if (candies.isEmpty) stop(status: Status.completed);
  }

  void _fillCandies() {
    _candies = [];
    final random = Random();
    for (var i = 0; i < numberOfCandies; i++) {
      int nextIndex = random.nextInt(numberOfColors);
      _candies.add(
        Candy(
          color: colors[nextIndex],
          top: random.nextInt(gameArea.height.toInt() - 120).toDouble(),
          left: random.nextInt(gameArea.width.toInt() - 100).toDouble(),
        ),
      );
    }
  }

  _fillColors() {
    List<Color> _candidates = [
      Colors.red,
      Colors.green,
      Colors.blueGrey,
      Colors.cyan,
      Colors.orange,
      Colors.grey,
      Colors.brown,
      Colors.purpleAccent,
      Colors.amber,
      Colors.pinkAccent,
    ];

    _colors = _candidates.sublist(0, _numberOfColors);
  }
}

enum Status {
  notStarted,
  started,
  completed,
  failed,
}

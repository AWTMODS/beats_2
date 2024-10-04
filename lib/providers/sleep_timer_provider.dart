import 'dart:async';

import 'package:flutter/material.dart';

class SleepTimerProvider with ChangeNotifier {
  Timer? _timer;
  bool _isTimerActive = false;

  bool get isTimerActive => _isTimerActive;

  void setTimer(Duration duration, VoidCallback onTimerEnd) {
    _cancelTimer();
    _timer = Timer(duration, () {
      _isTimerActive = true;
      notifyListeners();
      onTimerEnd();
    });
    _isTimerActive = true;
    notifyListeners();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _isTimerActive = false;
    notifyListeners();
  }

  void cancelTimer() {
    _cancelTimer();
  }
}

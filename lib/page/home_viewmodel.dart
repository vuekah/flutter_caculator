import 'package:flutter/material.dart';
import 'package:flutter_caculator/model/caculator_model.dart';

class HomeViewmodel extends ChangeNotifier {
  final List<String> _history = [];
  String result = '';
  bool _isCalculated = false;
  int _fixedIndex = 0;
  bool get isCalculated => _isCalculated;
  List<String> get history => _history;

  final CalculatorModel _calculator;

  HomeViewmodel() : _calculator = CalculatorModel();

  String calculate(
    String input, [
    bool isPercent = false,
  ]) {
    try {
      if (isPercent) {
        _fixedIndex++;
        int pressTimes = _fixedIndex * 2;
        debugPrint("======pressed times: $pressTimes");
        result = (double.parse(input) / 100).toStringAsFixed(pressTimes);
      } else {
        result = _calculator.evaluate(input).toStringAsFixed(0);
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    } finally {
      _isCalculated = true;
      _history.add(result);
      notifyListeners();
    }
    return result;
  }

  void clear() {
    _isCalculated = false;
    if (_history.isNotEmpty) {
      result = _history.last;
    }
    notifyListeners();
  }

  void resetAll() {
    _history.clear();
    result = '';
    _isCalculated = false;
    notifyListeners();
  }
}

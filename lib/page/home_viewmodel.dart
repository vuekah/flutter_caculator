import 'package:flutter/material.dart';
import 'package:flutter_caculator/model/caculator_model.dart';

class HomeViewmodel extends ChangeNotifier {
  final List<String> _history = [];
  final _textEditingController = TextEditingController();

  String result = '';
  String _display = '';
  bool _isCalculated = false;
  int _fixedIndex = 0;

  bool get isCalculated => _isCalculated;
  List<String> get history => _history;
  String get display => _display;
  TextEditingController get textEditingController => _textEditingController;

  final CalculatorModel _calculator;

  HomeViewmodel() : _calculator = CalculatorModel();

  void onButtonPressed(String input) {
    if (_isCalculated) {
      _display = history.last;
      _textEditingController.text = _display;
      clear();
    }
    _display += input;
    _textEditingController.text = _display;
    notifyListeners();
  }

  void changeNegativeNumber() {
    bool isNegative = _display.startsWith("-");
    if (isNegative) {
      _display = _display.substring(1);
    } else {
      _display = "-$_display";
    }
    _textEditingController.text = _display;
    notifyListeners();
  }

  void delete() {
    if (_display.isNotEmpty) {
      _display = _display.substring(0, _display.length - 1);
      _textEditingController.text = _display;
      notifyListeners();
    }
  }

  String calculate({bool isPercent = false}) {
    try {
      if (isPercent) {
        String input = result.isEmpty ? _textEditingController.text : result;
        _fixedIndex++;
        if (double.tryParse(input) != null) {
          int pressTimes = _fixedIndex * 2;
          result = (double.parse(input) / 100).toStringAsFixed(pressTimes);
        } else {
          print("aaaaa");
        }
      } else {
        String input = _display;
        result = _calculator.evaluate(input).toStringAsFixed(2);
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

  void calculateAndUpdateDisplay() {
    String input = _textEditingController.text;
    if (input.isNotEmpty) {
      _display = calculate(isPercent: true);
    } else if (_history.isNotEmpty) {
      _display = history.last;
      _display = calculate(isPercent: true);
    }
    notifyListeners();
  }

  void clear() {
    result = '';
    _isCalculated = false;
    notifyListeners();
  }

  void resetAll() {
    _history.clear();
    _fixedIndex = 0;
    result = '';
    _display = '';
    _textEditingController.clear();
    _isCalculated = false;
    notifyListeners();
  }
}

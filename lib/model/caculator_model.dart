
class CalculatorModel {
  double evaluate(String expression) {
    String tempExpression = expression;
    List<String> tokens = _tokenize(expression);
    List<double> values = [];
    List<String> ops = [];

    for (String token in tokens) {
      if (_isNumeric(token)) {
        values.add(double.parse(token));
      } else {
        while (ops.isNotEmpty && _precedence(ops.last) >= _precedence(token)) {
          double val2 = values.removeLast();
          double val1 = values.removeLast();
          String op = ops.removeLast();
          values.add(_applyOperation(val1, val2, op, tempExpression));
        }
        ops.add(token);
      }
    }

    while (ops.isNotEmpty) {
      double val2 = values.removeLast();
      double val1 = values.removeLast();
      String op = ops.removeLast();
      values.add(_applyOperation(val1, val2, op, tempExpression));
    }

    return values.last;
  }

  List<String> _tokenize(String expression) {
    if (expression.startsWith('-')) {
      expression = expression.substring(1);
    }
    return expression
        .split(RegExp(r'(?<=[-+x÷])|(?=[-+x÷])'))
        .map((s) => s.trim())
        .toList();
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == 'x' || op == '÷') return 2;
    return 0;
  }

  double _applyOperation(double a, double b, String op, String expression) {
    switch (op) {
      case '+':
        if (expression.startsWith('-')) {
          return (-a) + b;
        }
        return a + b;
      case '-':
        if (expression.startsWith('-')) {
          return (-a) - b;
        }
        return a - b;
      case 'x':
        if (expression.startsWith('-')) {
          return (-a) * b;
        }
        return a * b;
      case '÷':
        return b != 0 ? a / b : double.nan;
      default:
        return 0;
    }
  }
}

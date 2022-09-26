import 'package:math_expressions/math_expressions.dart';

class CalculatorOperation {
  static double fontsize = 40;
  static String result = '';

  static void calculations({required List listnumbers}) {
    if (listnumbers.length >= 30) {
      fontsize = 11200 / ((listnumbers.length) + 250);
    }
    if (listnumbers.length > 1) {
      String num1 = listnumbers.join();
      try {
        {
          num1 = num1.replaceAll('÷', '/');
          num1 = num1.replaceAll('×', '*');
          if (listnumbers[listnumbers.length - 1] == '%') {
            if (num1.contains('/')) {
              num1 = num1.replaceAll('%', '*100/1');
            } else {
              num1 = num1.replaceAll('%', '/100');
            }
          } else if (num1.contains('/') && num1.contains('%')) {
            String num2 = num1.replaceAll(RegExp(r'[0-9]'), '');
            int index = num2.indexOf('%');
            if (num2[index - 1] == '/') {
              num1 = num1.replaceAll('%', '*100*');
            } else {
              num1 = num1.replaceAll('%', '/100*');
            }
          } else {
            num1 = num1.replaceAll('%', '/100*');
          }

          result = _expression(num1: num1);
        }
      } catch (e) {
        print('error ==$e');
      }
    } else {
      result = listnumbers.join();
    }
  }

  static String _expression({required String num1}) {
    Parser p = Parser();
    Expression exp = p.parse(num1);
    ContextModel cm = ContextModel();
    double ans = exp.evaluate(EvaluationType.REAL, cm);
    if (ans % 1 == 0) {
      result = ans.toStringAsFixed(0);
    } else {
      result = ans.toString();
    }

    return result;
  }

  static getresult() {
    return (result);
  }
}

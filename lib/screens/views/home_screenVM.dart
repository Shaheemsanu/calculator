import 'package:flutter/cupertino.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../operations/calculations.dart';

class HomeScreenVM {
   void operators(
      {required String operatorname,
      required TextEditingController itemcontroller}) {
    insertText(myText: operatorname, itemcontroller: itemcontroller);
    var cursorPos = itemcontroller.selection.base.offset;
    String keypadnumber = itemcontroller.text;
    List keypadlist = keypadnumber.split('');
    if (keypadlist.length >= 320) {
      itemcontroller.clear();
      keypadlist.clear();
      keypadnumber = '0';
      CalculatorOperation.result = '0';
      insertText(myText: '0', itemcontroller: itemcontroller);
    }
    if (operatorname == '') {
      backspace(itemcontroller: itemcontroller);
      String keypadnumber = itemcontroller.text;
      List keypadlist = keypadnumber.split('');
      if (keypadlist.isEmpty) {
        itemcontroller.clear();
        CalculatorOperation.result = '';
      }
      CalculatorOperation.calculations(listnumbers: keypadlist);
    } else if (operatorname == 'c') {
      itemcontroller.clear();
      keypadlist.clear();
      keypadnumber = '';
      CalculatorOperation.fontsize = 40;
      CalculatorOperation.result = '';
    } else if (operatorname == '.' ||
        operatorname == '×' ||
        operatorname == '÷' ||
        operatorname == '-' ||
        operatorname == '+') {
      keypadlist = operatoroptn(
          keypadlist: keypadlist,
          cursorPos: cursorPos,
          keypadnumber: keypadnumber,
          val: operatorname);
      keypadnumber = keypadlist.join();
      keypadnumber = keypadlist.join();
      itemcontroller.clear();
      insertText(myText: keypadnumber, itemcontroller: itemcontroller);
      if (cursorPos < (keypadlist.length) ||
          keypadlist[keypadlist.length - 1] == '.') {
        CalculatorOperation.calculations(listnumbers: keypadlist);
      }
    } else if (operatorname == '%') {
      keypadlist[cursorPos - 1] = '';
      if (keypadlist.contains('%')) {
        keypadnumber = keypadlist.join();
        itemcontroller.clear();
        insertText(myText: keypadnumber, itemcontroller: itemcontroller);
      } else {
        keypadlist[cursorPos - 1] = '%';
        keypadlist = operatoroptn(
            keypadlist: keypadlist,
            cursorPos: cursorPos,
            keypadnumber: keypadnumber,
            val: operatorname);
        keypadnumber = keypadlist.join();
        itemcontroller.clear();
        insertText(myText: keypadnumber, itemcontroller: itemcontroller);

        CalculatorOperation.calculations(listnumbers: keypadlist);
      }
    } else {
      CalculatorOperation.calculations(listnumbers: keypadlist);
    }
  }

   List operatoroptn(
      {required List keypadlist,
      required int cursorPos,
      required String keypadnumber,
      required String val}) {
    if (val == '.') {
      if (keypadlist[cursorPos - 1] == '.' && keypadlist.length == 1) {
        keypadlist[0] = '0';
        keypadlist.add('.');
        keypadnumber = keypadlist.join();
      } else {
        try {
          if (cursorPos > 2) {
            if (keypadlist[cursorPos - 1] == '.' &&
                    keypadlist[cursorPos - 2] == '÷' ||
                keypadlist[cursorPos - 2] == '×' ||
                keypadlist[cursorPos - 2] == '%' ||
                keypadlist[cursorPos - 2] == '-' ||
                keypadlist[cursorPos - 2] == '+') {
              keypadlist.insert(cursorPos - 1, '0');
              keypadnumber = keypadlist.join();
            }
          }
          keypadnumber = keypadnumber.replaceAll('÷', '/');
          keypadnumber = keypadnumber.replaceAll('×', '*');
          keypadnumber = keypadnumber.replaceAll('%', '*0.01*');
          Parser p = Parser();
          Expression exp = p.parse(keypadnumber);
          return (keypadlist);
        } on FormatException {
          keypadlist[cursorPos - 1] = '';
          keypadnumber = keypadlist.join();
          keypadlist = keypadnumber.split('');
          if (cursorPos < keypadlist.length) {
            if (keypadlist[cursorPos - 1] == '.') {
              keypadlist[cursorPos - 1] = '';
            }
          }
        }
      }
    } else if (cursorPos == 1) {
      keypadlist[cursorPos - 1] = '';
    } else {
      if (val == keypadlist[cursorPos - 1] &&
              keypadlist[cursorPos - 2] == '÷' ||
          keypadlist[cursorPos - 2] == '×' ||
          keypadlist[cursorPos - 2] == '%' ||
          keypadlist[cursorPos - 2] == '-' ||
          keypadlist[cursorPos - 2] == '+') {
        keypadlist[cursorPos - 2] = keypadlist[cursorPos - 1];
        keypadlist[cursorPos - 1] = '';
        keypadnumber = keypadlist.join();
      } else if (cursorPos != (keypadlist.length)) {
        if (val == keypadlist[cursorPos - 1] && keypadlist[cursorPos] == '÷' ||
            keypadlist[cursorPos] == '×' ||
            keypadlist[cursorPos] == '%' ||
            keypadlist[cursorPos] == '-' ||
            keypadlist[cursorPos] == '+') {
          keypadlist[cursorPos] = keypadlist[cursorPos - 1];
          keypadlist[cursorPos - 1] = '';
          keypadnumber = keypadlist.join();
          if (cursorPos < (keypadlist.length) - 1) {
            CalculatorOperation.calculations(listnumbers: keypadlist);
          }
        }
      }
    }

    return (keypadlist);
  }

   insertText(
      {required String myText, required TextEditingController itemcontroller}) {
    final text = itemcontroller.text;
    final textSelection = itemcontroller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    itemcontroller.text = newText;
    itemcontroller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

   backspace({required TextEditingController itemcontroller}) {
    final text = itemcontroller.text;
    final textSelection = itemcontroller.selection;
    final selectionLength = textSelection.end - textSelection.start;
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      itemcontroller.text = newText;
      itemcontroller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }
    if (textSelection.start == 0) {
      return;
    }
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    itemcontroller.text = newText;
    itemcontroller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

   bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }
}



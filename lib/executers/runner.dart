import 'package:bfck/executers/terminator.dart';
import 'package:bfck/structures/cell_array.dart';
import 'package:dart_console/dart_console.dart';

class Runner extends Terminator {
  final CellArray cellArray;
  final String code;
  final int? eof;
  final String errorMode;
  final List<(int cmd, int line, int column)> loopCommands = [];
  (int cmd, int line, int column) currCommand = (0, 1, 1);

  Runner({
    required this.code,
    required this.eof,
    required this.errorMode,
    required bool allowNegativeCells,
    required bool allowNegativeValues,
    required String cellsLimit
  }) : cellArray = CellArray(allowNegativeValues, allowNegativeCells, cellsLimit);

  void _incrementCurrCell() => cellArray.increment();

  void _decrementCurrCell() {
    try {
      cellArray.decrement();
    } on Exception catch (exception) {
      _terminateOrWarn(exception.toString().substring(11));
    }
  }

  void _jumpRight() {
    try {
      cellArray.moveRight();
    } on Exception catch (exception) {
      _terminateOrWarn(exception.toString().substring(11));
    }
  }

  void _jumpLeft() {
    try {
      cellArray.moveLeft();
    } on Exception catch (exception) {
      _terminateOrWarn(exception.toString().substring(11));
    }
  }

  bool _inCurrentCell() {
    while(true) {
      final Key currKey = console.readKey();

      if(!currKey.isControl) {
        cellArray.currValue = currKey.char.codeUnitAt(0);
        return true;
      }

      switch(currKey.controlChar) {
        case ControlCharacter.enter:
          cellArray.currValue = 10;
        return true;
        case ControlCharacter.ctrlD:
          if(eof != null) {
            cellArray.currValue = eof ?? 0;
          }
        return true;
        case ControlCharacter.ctrlC:
          console.writeLine("\n^C");
        return false;
        default: break;
      }
    }
  }

  void _outCurrentCell() {
    try {
      console.write(String.fromCharCode(cellArray.currValue));
    } on RangeError catch (_) {
      _terminateOrWarn("Current cell value (${cellArray.currValue}) could not be translated into a character.");
    }
  }

  void _beginLoop() {
    if(cellArray.currValue == 0) {
      int loopsOpened = 1;
      (int cmd, int line, int column) tempCommand = (
        currCommand.$1 + 1,
        currCommand.$2,
        currCommand.$3
      );

      while(tempCommand.$1 <= code.length - 1) {
        switch(code[tempCommand.$1]) {
          case '[':
            loopsOpened++;
          break;
          case ']':
            loopsOpened--;
          break;
          case '\n':
            tempCommand = (
              tempCommand.$1, 
              tempCommand.$2 + 1, 
              0
            );
          break;
        }

        if(loopsOpened <= 0) {
          currCommand = tempCommand;
          return;
        }

        tempCommand = (
          tempCommand.$1 + 1, 
          tempCommand.$2, 
          tempCommand.$3 + 1
        );
      }

      _terminateOrWarn("There are $loopsOpened opened loops that haven't been closed.");
    }

    loopCommands.add(currCommand);
  }

  void _endLoop() {
    if(loopCommands.isEmpty) {
      _terminateOrWarn("There is a closing loop command that doesn't match a loop beginning.");
    }

    if(cellArray.currValue == 0) {
      loopCommands.removeLast();
      return;
    }

    currCommand = loopCommands.last;
  }

  void _endRunner() => currCommand = (code.length, currCommand.$2, currCommand.$3);

  void _terminateOrWarn(String message) {
    if(errorMode == "terminate") {
      throw Exception(message);
    }
    
    returnNum = 2;
    
    console.setForegroundColor(ConsoleColor.brightYellow);
    console.writeLine("Warning: $message");
    console.resetColorAttributes();
  }


  @override
  int run() {
    stopwatch.start();

    try {
      while(currCommand.$1 <= code.length - 1) {
        switch(code[currCommand.$1]) {
          case '>' : 
            _jumpRight();
          break;
          case '<' : 
            _jumpLeft();
          break;
          case '+' : 
            _incrementCurrCell();
          break;
          case '-' : 
            _decrementCurrCell();
          break;
          case '.' : 
            _outCurrentCell();
          break;
          case ',' : 
            if(!_inCurrentCell()) {
              _endRunner();
            }
          break;
          case '[' : 
            _beginLoop();
          break;
          case ']' : 
            _endLoop();
          break;
          case '\n' : 
            currCommand = (
              currCommand.$1, 
              currCommand.$2 + 1, 
              0
            );
          break;
        }

        currCommand = (
          currCommand.$1 + 1, 
          currCommand.$2, 
          currCommand.$3 + 1
        );
      }
    } on Exception catch (exception) {
      returnNum = 1;
      error = "$exception\nLine: ${currCommand.$2}, Col: ${currCommand.$3}.";
    }

    stopwatch.stop();

    return super.run();
  }
}
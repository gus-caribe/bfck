import 'package:bfck/executers/executer.dart';
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

class Terminator extends Executer {
  final Stopwatch stopwatch = Stopwatch();
  String error = "";

  @mustCallSuper
  @override
  int run() {
    if(error != "") {
      console.setForegroundColor(ConsoleColor.brightRed);
    }
    
    console.writeLine("\n---------------------------");

    if(error != "") {
      console.writeLine(error);
    }

    console.resetColorAttributes();
    console.writeLine("Process terminated.\nTime: ${stopwatch.elapsedMilliseconds}ms.\n");
    console.writeLine("Application returned $returnNum.");

    return super.run();
  }
}
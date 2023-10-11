import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

class Executer {
  final Console console = Console();
  int returnNum = 0;

  @mustBeOverridden
  int run() {
    console.write('\n');
    
    return returnNum;
  }
}
import 'dart:io';
import 'package:bfck/commands/no_output/no_output_command.dart';
import 'package:bfck/executers/executer.dart';
import 'package:bfck/executers/runner.dart';
import 'package:dart_console/dart_console.dart';


class RunCommand extends NoOutputCommand {
  @override
  String get name => "run";
  @override
  String get description => "Run the runtime interpreter for brainfuck code.";

  final Console console = Console();

  RunCommand() : super();

  @override
  Executer run() {
    List<String> standaloneArguments = argResults?.rest ?? [];

    if(standaloneArguments.length > 1) {
      console.writeLine("Run command does not support more than one standalone argument.");
      return Executer();
    }

    int? cellsLimitTest = int.tryParse(argResults?["cells-limit"]);

    if(
      (cellsLimitTest == null || cellsLimitTest < 0)
      && argResults?["cells-limit"] != "dynamic"
    ) {
      console.writeLine(
        "Invalid value \"${argResults?["cells-limit"]}\" for option \"cells-limit\"."
      );
      return Executer();
    }

    int? eofTest = int.tryParse(argResults?["eof"]);

    if(
      eofTest == null
      && argResults?["eof"] != "none"
    ) {
      console.writeLine("Invalid value \"${argResults?["eof"]}\" for option \"eof\".");
      return Executer();
    }

    switch(argResults?["error-mode"]) {
      case "terminate": break;
      case "ignore": break;
      default:
        console.writeLine(
          "Invalid value \"${argResults?["error-mode"]}\" for option \"error-mode\"."
        );
      return Executer();
    }

    String runFileName = standaloneArguments.isNotEmpty ? standaloneArguments[0] : "main.bf";
    String runFileContent = "";

    try {
      runFileContent = File(runFileName).readAsStringSync();
    } on Exception catch(_) {
      console.writeLine(
        "Couldn't find a file named \"$runFileName\"${runFileName == "main.bf" ? " (default)" : ""}."
      );
      return Executer();
    }

    return Runner(
      code: runFileContent,
      allowNegativeCells: argResults?["negative-cells"] ?? false,
      allowNegativeValues: argResults?["negative-values"] ?? false,
      cellsLimit: argResults?["cells-limit"] ?? "dynamic",
      eof: eofTest,
      errorMode: argResults?["error-mode"] ?? "terminate"
    );
  }
}
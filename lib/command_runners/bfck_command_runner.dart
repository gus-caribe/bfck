import 'dart:async';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:bfck/constants/constants.dart';
import 'package:bfck/executers/executer.dart';
import 'package:dart_console/dart_console.dart';

class BfckCommandRunner extends CommandRunner<Executer> {
  final Console console = Console();
  bool _containsHelp = false;
  String localDescription = "";
  @override
  String get description => localDescription;
  
  BfckCommandRunner() : super("bfck", " ") {
    localDescription = kDescription;

    argParser.addFlag(
      "version",
      abbr: 'v',
      negatable: false,
      help: "See the release version of bfck interpreter."
    );
  }

  void printVersion() async {
    console.setForegroundColor(ConsoleColor.brightBlue);
    console.write("\nbfck ");
    console.resetColorAttributes();
    console.write("version ");
    console.setForegroundColor(ConsoleColor.brightCyan);
    console.write("$kVersion\n");
    console.resetColorAttributes();
    console.writeLine(description);
  }

  @override
  void printUsage() async {
    if(!_containsHelp) {
      console.write('\n');

      for(String ascii in kBfckAscii.split('')) {
        console.setForegroundColor(
          ascii == '#'
          ? ConsoleColor.brightCyan
          : ConsoleColor.brightBlue
        );

        console.write(ascii);
      }

      console.resetColorAttributes();
      console.writeLine("\n\n$description");
      console.write("\nType ");
      console.setForegroundColor(ConsoleColor.brightBlue);
      console.write("bfck ");
      console.setForegroundColor(ConsoleColor.brightCyan);
      console.write("--help ");
      console.resetColorAttributes();
      console.write("to see the available commands.\n\n");

      return;
    }

    super.printUsage();
  }

  @override
  Future<Executer?> runCommand(ArgResults topLevelResults) async {
    _containsHelp = topLevelResults['help'] as bool;
    return super.runCommand(topLevelResults);
  }

  @override
  Future<Executer> run(Iterable<String> args) async {
    ArgResults straightUpFlagsResults = argParser.parse(args);

    if(straightUpFlagsResults["version"]) {
      printVersion();
    } else {
      Executer? superExecuter = await super.run(args);

      if(superExecuter != null) {
        return superExecuter;
      }
    }

    return Executer();
  }
}
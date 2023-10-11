import 'package:args/command_runner.dart';
import 'package:bfck/executers/executer.dart';

abstract class BaseCommand extends Command<Executer> {
  BaseCommand() {
    argParser.addFlag(
      "negative-cells",
      help: "Defines if bfck interpreter will accept cells with index below zero."
    );
    argParser.addFlag(
      "negative-values",
      help: "Defines if bfck interpreter will accept values below zero."
    );
    argParser.addOption(
      "cells-limit",
      defaultsTo: "dynamic",
      help: "Overall limit of cells.",
      valueHelp: "SIZE"
    );
    argParser.addOption(
      "eof",
      defaultsTo: "0",
      help: "Defines what will be added to current cell when EOF(^D) is inserted.",
      valueHelp: "TYPE"
    );
    argParser.addOption(
      "error-mode",
      defaultsTo: "terminate",
      help: "Defines what will be performed when a non-coherent operation occurs.",
      valueHelp: "TYPE"
    );

    /** 
     * COMING SOON:
     * 
     * argParser.addOption(
     *  "cell-size",
     *   defaultsTo: "64",
     *   help: "Cells' memory size, in bits.",
     *   valueHelp: "SIZE",
     *   allowed: ['8', "16", "32", "64"]
     * );
    **/
  }
}
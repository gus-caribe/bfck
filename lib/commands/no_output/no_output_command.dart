import 'package:bfck/commands/base_command.dart';

abstract class NoOutputCommand extends BaseCommand {
  NoOutputCommand() : super() {
    /** 
     * COMING SOON:
     * 
     * argParser.addOption(
     *  "log-at",
     *   defaultsTo: "none",
     *   help: "Log file name.",
     *   valueHelp: "SIZE"
     * );
    **/
  }
}
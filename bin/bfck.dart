import 'package:bfck/command_runners/bfck_command_runner.dart';
import 'package:bfck/commands/no_output/run_command.dart';
import 'package:bfck/executers/executer.dart';

Future<int> main(List<String> arguments) async {
  final BfckCommandRunner bfck = BfckCommandRunner()
    ..addCommand(RunCommand());

  final Executer toRun = await bfck.run(arguments);

  return toRun.run();
}

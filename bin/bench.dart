import 'dart:io';

import 'package:bench/bench.dart' as bench;

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("Wrong arguments. Pass either 'reuse-router' or 'no-reuse-router' as an argument");
    exit(1);
  }

  final arg = arguments.first;
  late final bool reuseNestedRouter;

  if (arg == "reuse-router") {
    reuseNestedRouter = true;
  } else if (arg == "no-reuse-router") {
    reuseNestedRouter = false;
  } else {
    print("Wrong arguments. Pass either 'reuse-router' or 'no-reuse-router' as an argument");
    exit(1);
  }

  await bench.startServer(
    reuseNestedRouter: reuseNestedRouter,
  );
}

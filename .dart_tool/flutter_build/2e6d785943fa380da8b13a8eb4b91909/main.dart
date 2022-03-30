// @dart=2.12

import 'dart:ui' as ui;

import 'package:particle_background/main.dart' as entrypoint;

Future<void> main() async {
  await ui.webOnlyInitializePlatform();
  entrypoint.main();
}

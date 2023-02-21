/* example - example to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class ExampleConfig {
  void copyFrom(ExampleConfig config) {}

  ExampleConfig();

  Map<String, dynamic> toJson() => {};

  ExampleConfig.fromJson(Map<String, dynamic> json);
}

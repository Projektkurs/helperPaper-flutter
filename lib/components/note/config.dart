/* Note - Note to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class NoteConfig {
  void copyFrom(NoteConfig config) {}

  NoteConfig();

  ///The default digitalNote
  NoteConfig.digital();

  Map<String, dynamic> toJson() => {};

  NoteConfig.fromJson(Map<String, dynamic> json);
}

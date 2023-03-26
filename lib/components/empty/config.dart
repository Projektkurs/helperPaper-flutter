/* empty/config.dart - config of empty component
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';

class EmptyConfig {
  int width = 0;
  int height = 0;
  Component? replacement;
  Function? replace;
  late Key key;
  EmptyConfig();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
      };

  EmptyConfig.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'];
}

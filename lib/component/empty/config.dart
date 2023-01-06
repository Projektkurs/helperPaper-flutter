/* empty_component-config.dart - config of empty_component
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class EmptyComponentConfig {
  int width = 0;
  int height = 0;
  Component? replacement;
  bool apply = false;
  Function? replace;
  late Key key;
  EmptyComponentConfig();

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
      };

  EmptyComponentConfig.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'];
}

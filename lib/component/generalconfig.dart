/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

/// a Class that saves information which is used by every Component
/// the reason behind this variables beeing outsourced into a distinct class
/// is that the data can be loaded and stored into json format which should not
/// need a specific component to work.
class GeneralConfig {
  /// relativ size of the widget in the direction of the scaffolding
  int flex;
  double? borderWidth;
  double? borderRadius;
  double? padding;
  Bordertype? bordertype;
  Color? borderColor;

  GeneralConfig(
    this.flex,
  );

  GeneralConfig.createGeneral()
      : flex = 1,
        borderWidth = 5,
        borderRadius = 10,
        padding = 5;

  void takeFrom(GeneralConfig config) {
    flex = config.flex;
    borderWidth = config.borderWidth;
    borderRadius = config.borderRadius;
    padding = config.padding;
    bordertype = config.bordertype;
    borderColor = config.borderColor;
  }

  GeneralConfig.createFrom(GeneralConfig config)
      : flex = config.flex,
        borderWidth = config.borderWidth,
        borderRadius = config.borderRadius,
        padding = config.padding,
        bordertype = config.bordertype,
        borderColor = config.borderColor;

  /// encode Config into Json format
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'flex': flex,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
    };
    if (borderColor != null) {
      map['bordercolor'] = borderColor!.value;
    }
    if (borderWidth != null) {
      map['borderWidth'] = borderWidth;
    }
    if (borderRadius != null) {
      map['borderRadius'] = borderRadius;
    }
    return map;
  }

  /// create a GeneralConfig from a json map
  /// this method will always return a GeneralConfig, even if the input
  /// Map is empty
  GeneralConfig.fromJson(Map<String, dynamic> json)
      : flex = json['flex'] ?? 1,
        borderWidth = json["borderWidth"] ?? 5,
        borderRadius = json["borderRadius"] ?? 10;
}

enum Bordertype { round, sharp, fused }

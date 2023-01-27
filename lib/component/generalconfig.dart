/* generalconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/components/scaffholding/config.dart';
import 'package:helperpaper/main_header.dart';

class Defaultgeneral {}

class GeneralConfig {
  int flex;
  double? borderWidth;
  double? borderRadius;
  double? padding;
  Bordertype? bordertype;
  Color? borderColor;

  void takeFrom(GeneralConfig config) {
    flex = config.flex;
    borderWidth = config.borderWidth;
    borderRadius = config.borderRadius;
    padding = config.padding;
    bordertype = config.bordertype;
    borderColor = config.borderColor;
  }

  GeneralConfig(
    this.flex,
  ); //this.cconfig);
  GeneralConfig.copyFrom(GeneralConfig config)
      : flex = config.flex,
        borderWidth = config.borderWidth,
        borderRadius = config.borderRadius,
        padding = config.padding,
        bordertype = config.bordertype,
        borderColor = config.borderColor;
  //must be of ContentType Defaultgeneral
  GeneralConfig.createGeneral()
      : //cconfig = Defaultgeneral(),
        flex = 1,
        borderWidth = 5,
        borderRadius = 10,
        padding = 5;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'flex': flex,
      //'type': type.toString(),
      //'cconfig': cconfig,
      //border:
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

  GeneralConfig.fromJson(Map<String, dynamic> json)
      : flex = json['flex'],
        //cconfig = cconf,
        //border
        borderWidth = json["borderWidth"],
        borderRadius = json["borderRadius"];
  //type=stringtoType(json['type']);
}

enum Bordertype { round, sharp, fused }

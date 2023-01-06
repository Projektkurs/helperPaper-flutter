/* clock-config.dart - config of component clock
 *
 * Copyright 2022 by Béla Wohlers <bela.wohlers@gmx.de>
 * 
*/
import 'package:helperpaper/main_header.dart';

class ClockConfig {
  bool isdigital = true;
  bool showsecond = true;
  //config of analogclock:
  bool showDigitalClock = true;
  bool showTicks = true;
  bool showNumbers = true;
  bool showSecondHand = true;
  bool showAllNumbers = false;
  bool useMilitaryTime = true;
  double textScaleFactor = 1;
  Color hourColor = Colors.black;
  Color minuteColor = Colors.black;
  Color secondColor = Colors.redAccent;
  Color digitalClockColor = Colors.black;
  Color numberColor = Colors.black;

  FontWeight fontweight = FontWeight.w200;
  void copyFrom(ClockConfig config) {
    isdigital = config.isdigital;
    showsecond = config.showsecond;
    hourColor = config.hourColor;
    minuteColor = config.minuteColor;
    secondColor = config.secondColor;
    fontweight = config.fontweight;
  }

  ClockConfig();

  ///The default digitalclock
  ClockConfig.digital();

  Map<String, dynamic> toJson() => {
        'isdigital': isdigital,
        'showsecond': showsecond,
        'fontweight': fontweight.index
      };

  ClockConfig.fromJson(Map<String, dynamic> json)
      : isdigital = json['isdigital'] ?? true,
        showsecond = json['showsecond'] ?? true,
        fontweight = fontweights[(json['fontweight'] ?? 1)];
}

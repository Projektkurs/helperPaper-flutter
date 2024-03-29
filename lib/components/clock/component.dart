/* clock/component.dart - a clock based upon the dart-libary: 'analog_clock'
 * it also has a simple digital clock
 *
 * Copyright 2022-2022 by Béla Wohlers <bela.wohlers@gmx.de>
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
*/

import 'package:helperpaper/header.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:google_fonts/google_fonts.dart';

/// This Component can either be a digital or analog clock
class Clock extends Component<ClockConfig> {
  Clock(
      {super.key,
      required super.gconfig,
      required ClockConfig cconfig,
      super.inpopup})
      : super(cconfig: cconfig);

  final String? name = 'Clock';

  Clock.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: ClockConfig.fromJson(json['cconfig']));

  @override
  State<Clock> createState() => ClockState();
}

class ClockState extends ComponentState<Clock> {
  late DateTime now;
  bool timeupdatective = false;
  @override
  popup() async {
    await popupdialog(
        ClockPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
    if (!timeupdatective) {
      timeupdate();
    }
  }

  timeupdate() async {
    timeupdatective = true;
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (widget.cconfig.isdigital && mounted) {
        if (!(now.minute == DateTime.now().minute &&
            !widget.cconfig.showsecond)) {
          setState(() {});
        }
        timeupdate();
      } else {
        timeupdatective = false;
      }
    });
  }

  @override
  initState() {
    super.initState();
    timeupdate();
  }

  @override
  Widget build(BuildContext context) {
    String pad(int date) => date < 10 ? '0$date' : date.toString();
    now = DateTime.now();
    String time = '${pad(now.hour)}:${pad(now.minute)}';
    if (widget.cconfig.isdigital) {
      return componentbuild(FittedBox(
        fit: BoxFit.contain,
        child: Text(time,
            style: GoogleFonts.chivo(
              fontWeight: widget.cconfig.fontweight,
            )),
      ));
    } else {
      return componentbuild(AnalogClock(
        useMilitaryTime: widget.cconfig.useMilitaryTime,
        showTicks: widget.cconfig.showTicks,
        showDigitalClock: widget.cconfig.showDigitalClock,
        showNumbers: widget.cconfig.showNumbers,
        showSecondHand: widget.cconfig.showSecondHand,
        showAllNumbers: widget.cconfig.showAllNumbers,
        hourHandColor: widget.cconfig.hourColor,
        minuteHandColor: widget.cconfig.minuteColor,
        secondHandColor: widget.cconfig.secondColor,
        digitalClockColor: widget.cconfig.digitalClockColor,
        numberColor: widget.cconfig.numberColor,
        textScaleFactor: widget.cconfig.textScaleFactor,
        decoration: BoxDecoration(
            border: Border.all(
              width: 8.0,
              style: BorderStyle.none,
              color: Colors.black,
            ),
            shape: BoxShape.circle,
            color: Colors.transparent),
      ));
    }
  }
}

/* countdown/component.dart - a countdown that shows the time remainding of 
 * the current lesson / break as well as which lesson it is
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
*/

import 'package:helperpaper/header.dart';
import 'package:helperpaper/vpmobil.dart' as vp;
import 'package:google_fonts/google_fonts.dart';

// TODO: disable countdown on weekends / free days
class Countdown extends Component<CountdownConfig> {
  Countdown(
      {required Key key,
      required GeneralConfig gconfig,
      required CountdownConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  Countdown.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: CountdownConfig.fromJson(json['cconfig']));

  @override
  State<Countdown> createState() => CountdownState();
}

class CountdownState extends ComponentState<Countdown> {
  var ctr = tr['countdown']!;
  String message = '';
  late DateTime now;
  vp.XmlDay? xmlday;
  @override
  popup() async {
    await popupdialog(
        CountdownPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
  }

  List<List<DateTime>>? hourtimes;
  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    vp.addvplandirectcallback((List<vp.XmlDay> daylist) {
      if (mounted) {
        setState(() {
          xmlday = daylist[0];
          hourtimes = xmlday!.gethourtimes();
        });
      }
    });
  }

  // TODO: the update should not just be delayed by 1 second and then check whether
  // the next minute started, but directly change the duration to update on the next
  // minute or the epaper update interval. this is also true for clock
  timeupdate() async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      // TODO: currently, if the widget is removed from the tree, this function
      // still runs. Create a function that on build checks wether this function
      // is running and if not, call it again
      if (mounted) {
        if (!(now.minute == DateTime.now().minute)) {
          setState(() {});
        }
      }
      timeupdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hourtimes == null) {
      return componentbuild(const SizedBox());
    }
    var starttimes = hourtimes![0];
    var endtimes = hourtimes![1];

    /// -2 means the day has not startet and -1 that the last lesson is over
    /// the first lesson is lesson 0
    int lesson = 0;

    /// e.g. if isbreak is true and lesson:=1, it is the break after the first
    /// lesson
    bool isbreak = false;
    // assumption: all lessons have an equal duration
    Duration lessonlength = endtimes[0].difference(starttimes[0]);
    //now = DateTime.now().subtract(Duration(hours: 5));
    now = DateTime.now();
    // TODO: calculating which lesson currently takes place should not
    // be recalculated each time
    if (starttimes[0].isAfter(now)) {
      message = ctr['before_start']!;
      lesson = -2;
    } // the for loop is dependent on this condition being checked before
    else if (endtimes.last.isBefore(now)) {
      message = ctr['after_last']!;
      lesson = -1;
    } else {
      for (int i = 0; i < starttimes.length; i++) {
        if (starttimes[i].isBefore(now) && endtimes[i].isAfter(now)) {
          lesson = i;
          message = ctr['lesson']!.replaceAll('%', '${i + 1}.');
          break;
        }
        if (endtimes[i].isBefore(now) && starttimes[i + 1].isAfter(now)) {
          lesson = i;
          isbreak = true;
          message = ctr['break']!.replaceAll('%', '${i + 2}.');
          break;
        }
      }
    }
    const int totalbarflex = 2 << 30;
    int firstbar = 0;
    int secondbar = 0;
    if (lesson == -2) {
      message =
          '$message\n\n${starttimes[0].difference(now).inMinutes} Minuten bis\n Unterrichtsstart';
    }
    if (!widget.cconfig.showbar) {
      if (lesson >= 0 && !isbreak) {
        message =
            '$message\n\nnoch ${endtimes[lesson].difference(now).inMinutes} Minuten';
      }
      if (lesson >= 0 && isbreak) {
        message =
            '$message\n\nnoch ${starttimes[lesson + 1].difference(now).inMinutes} Minuten';
      }
    } else {
      if (lesson >= 0 && !isbreak) {
        secondbar = (totalbarflex.toDouble() *
                endtimes[lesson].difference(now).inSeconds /
                lessonlength.inSeconds)
            .floor();
        firstbar = totalbarflex - secondbar;
      }
      if (lesson >= 0 && isbreak) {
        secondbar = (totalbarflex.toDouble() *
                endtimes[lesson + 1].difference(now).inSeconds /
                endtimes[lesson + 1].difference(starttimes[lesson]).inSeconds)
            .floor();
        firstbar = totalbarflex - secondbar;
      }
    }
    return componentbuild(Column(children: [
      Expanded(
          flex: 10,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Text(message,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.chivo()))),
      !widget.cconfig.showbar || lesson == -2
          ? const Expanded(flex: 0, child: SizedBox.shrink())
          : Expanded(
              flex: 10,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 4)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: firstbar,
                              child: Container(
                                color: Colors.black,
                              )),
                          Expanded(flex: secondbar, child: Container())
                        ],
                      ),
                    )
                  ])),
    ]));
  }
}

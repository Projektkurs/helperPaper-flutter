import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/message.dart';
import 'package:helperpaper/vpmobil.dart' as vp;

class Countdown extends Component {
  @override
  Countdown(
      {required Key key,
      required GeneralConfig gconfig,
      required CountdownConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> tmpconf = super.toJson();
    return tmpconf;
  }

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
  String message = "";
  vp.XmlDay? xmlday;
  popup() async {
    await popupdialog(
        CountdownPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
  }

  List<List<DateTime>>? hourtimes;
  @override
  void initState() {
    super.initState();
    vp.addvplandirectcallback((List<vp.XmlDay> daylist) {
      print("test");
      xmlday = daylist[0];
      hourtimes = xmlday!.gethourtimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// cheap two length leftpad
    String pad(int date) => date < 10 ? "0$date" : date.toString();
    if (hourtimes == null) {
      return componentbuild(const SizedBox());
    }
    var starttimes = hourtimes![0];
    var endtimes = hourtimes![1];
    // assumption: all lessons have an equal duration

    /// -2 means the day has not startet and -1 that the last lesson is over
    /// the first lesson is lesson 0
    int lesson = 0;

    /// e.g. if isbreak is true and lesson:=1, it is the break after the first
    /// lesson
    bool isbreak = false;
    Duration lessonlength = starttimes[0].difference(endtimes[0]);
    DateTime now = DateTime.now();
    // todo: calculating which lesson currently takes place should not
    // be recalculated each time
    if (starttimes[0].isAfter(now)) {
      message = ctr['before_start']!;
      lesson = -2;
    } else if (endtimes.last.isBefore(now)) {
      message = ctr['after_last']!;
      lesson = -1;
    } else {
      for (int i = 0; i < starttimes.length; i++) {
        if (starttimes[i].isBefore(now) && endtimes[i].isAfter(now)) {
          lesson = i;
          message = ctr['lesson']!.replaceAll("%", "${i + 1}.");
          break;
        }
        if (endtimes[i].isBefore(now) && starttimes[i + 1].isAfter(now)) {
          lesson = i;
          isbreak = true;
          message = ctr['break']!.replaceAll("%", "${i + 2}.");
          break;
        }
      }
    }
    // Stunden, Minuten und Sekunden werden aus der aktuellen Dauervaraiable extrahiert
    //final hours = pad(myDuration.inHours.remainder(24));
    //final minutes = pad(myDuration.inMinutes.remainder(60));
    //final seconds = pad(myDuration.inSeconds.remainder(60));
    return componentbuild(
        //Scaffold(
        //flutter  appBar: ...,
        //body: Center(
        //child:
        Column(
      children: [
        SizedBox(
          height: 50,
        ),
        FittedBox(
            fit: BoxFit.contain,
            child:
                // Hinzufügen eines Widgets um den Countdown-Timer anzuzeigen
                Text(
              message, //'$hours:$minutes:$seconds',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            )),
        SizedBox(height: 20),
      ],
    ));
  }
}

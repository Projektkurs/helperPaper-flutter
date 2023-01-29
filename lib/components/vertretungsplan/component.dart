import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/vpmobil.dart' as vp;

class Vertretungsplan extends Component {
  @override
  Vertretungsplan(
      {super.key,
      required super.gconfig,
      required VertretungsplanConfig cconfig,
      super.inpopup})
      : super(cconfig: cconfig);

  void popup() async {}
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> tmpconf = super.toJson();
    return tmpconf;
  }

  Vertretungsplan.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: VertretungsplanConfig.fromJson(json["cconfig"]));
  @override
  State<Vertretungsplan> createState() => VertretungsplanState();
}

class VertretungsplanState extends ComponentState<Vertretungsplan> {
  DateTime? lastupdate;
  vp.Plan? vplan;
  List<vp.XmlDay>? xmlday;
  @override
  popup() async {
    await popupdialog(
        VertretungsplanPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    //setState(() {
    //  neuerplan = false;
    //});
    //update vetretungsplan if new room is applied
    vplan = vp.Plan.newplan(widget.cconfig.raum, xmlday!);
    if (mounted) {
      setState(() {});
    }
  }

  void updateplan(List<vp.XmlDay> a) {
    xmlday = a;
    lastupdate = DateTime.now();
    vplan = vp.Plan.newplan(widget.cconfig.raum, a);
    if (widget.built) {
      if (mounted) {
        setState(() {});
      }
      debugPrint("plan loaded");
      vp.addvplanupdatecallback(updateplan);
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.scheduleFrameCallback((Duration duration) {
      vp.addvplandirectcallback(updateplan);
    });
  }

  Widget hourformat(vp.Lesson? lesson) {
    if (lesson == null) {
      return const Text("");
    } else {
      var note = lesson.info == "" ? "" : "\nInfo:${lesson.info}";
      return Text("${lesson.level}: ${lesson.subject}, ${lesson.teacher}$note",
          style: Theme.of(context).textTheme.titleMedium);
    }
  }

  String getweekday(DateTime date) {
    switch (date.weekday) {
      case (1):
        return "Mo";
      case (2):
        return "Di";
      case (3):
        return "Mi";
      case (4):
        return "Do";
      case (5):
        return "Fr";
      case (6):
        return "Sa";
      case (7):
        return "So";
      default:
        return "";
    }
  }

  String getday(DateTime date) {
    if (date == vp.trim(DateTime.now())) {
      return "Heute";
    }
    if (date == vp.trim(DateTime.now().add(const Duration(days: 1)))) {
      return "Morgen";
    }
    return "${getweekday(date)} der ${date.day}. ${date.month}";
  }

  TableRow onecollumn(int hour) {
    List<Widget> text = [
      Text("${hour + 1}. Stunde", style: Theme.of(context).textTheme.titleLarge)
    ];
    for (var i in vplan!.lessons) {
      text.add(hourformat(i[hour]));
    }
    return TableRow(children: text);
  }

  List<TableRow> createcompletetable() {
    if (vplan == null) {
      return [];
    }
    List<Widget> firstrow = [Text("")];
    for (int i = 0; i < 5; i++) {
      if (i == vplan!.days.length) {
        break;
      }
      firstrow.add(Text(
        getday(vplan!.days[i].date),
        textScaleFactor: 1.5,
      ));
    }
    List<TableRow> tables = [TableRow(children: firstrow)];
    for (int i = 0; i < 7; i++) {
      tables.add(onecollumn(i));
    }
    return tables;
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Expanded(
              child: Text(
            "Belegungsplan ${widget.cconfig.raum}",
            textScaleFactor: 2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    lastupdate == null
                        ? ""
                        : "letztes Update: ${lastupdate!.hour}:${lastupdate!.minute}",
                    textScaleFactor: 1.3,
                  )))
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
            textDirection: TextDirection.ltr,
            border: TableBorder.all(width: 1.0, color: Colors.black),
            children: createcompletetable()),
      ),
    ]));
  }
}

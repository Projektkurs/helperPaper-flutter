import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/components/vertretungsplan/vpmobil.dart' as vp;

class Vertretungsplan extends Component {
  @override
  Vertretungsplan({
    required Key key,
    required GeneralConfig gconfig,
    required VertretungsplanConfig cconfig,
  }) : super(key: key, gconfig: gconfig, cconfig: cconfig);

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
            cconfig:
                VertretungsplanConfig.fromJson(json["gconfig"]["cconfig"]));
  @override
  State<Vertretungsplan> createState() => VertretungsplanState();
}

class VertretungsplanState extends ComponentState<Vertretungsplan> {
  popup() {}
  DateTime? lastupdate;
  vp.Plan? vplan;
  @override
  void initState() {
    super.initState();

    //does this create a call stack overflow?
    updateplan() async {
      lastupdate = DateTime.now();
      vplan = await vp.Plan.newplan(widget.cconfig.raum);
      if (widget.built) {
        if (this.mounted) {
          setState(() {});
        }
        debugPrint("plan loaded");
        Future.delayed(const Duration(minutes: 5)).then((value) async {
          updateplan();
        });
      }
    }

    SchedulerBinding.instance.scheduleFrameCallback((Duration duration) {
      updateplan();
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
    //update vetretungsplan if new room is applied
    if ((widget.cconfig as VertretungsplanConfig).neuerplan == true) {
      print("ja");
      () async {
        vplan = await vp.Plan.newplan(widget.cconfig.raum);
        (widget.cconfig as VertretungsplanConfig).neuerplan = false;
        if (mounted) {
          setState(() {});
        }
      }();
    }

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
                        : "letztes Update:${lastupdate!.day}.${lastupdate!.day}",
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

import "package:http/http.dart" as http;
import "package:helperpaper/main_header.dart";
import "package:path/path.dart";
import "package:xml/xml.dart";

const MAXHOURSPERDAY = 7;
List<XmlDay>? _xmldays;
List<void Function(List<XmlDay>)> _callbacks = [];

List<void Function()> _handlers = [];
bool _updatehandlerruning = false;
bool startupdatehandler() {
  if (!_updatehandlerruning) {
    _vplanAutoUpdater();
    _updatehandlerruning = true;
  }
  return _updatehandlerruning;
}

/// the given Function is called directly if vplan is already available or
/// as soon as it is.
void addvplandirectcallback(void Function(List<XmlDay>) callback) {
  if (_xmldays == null) {
    _callbacks.add(callback);
  } else {
    callback(_xmldays!);
  }
}

/// The given Function is excecuted after the update of the vplan.
void addvplanupdatecallback(void Function(List<XmlDay>) callback) {
  _callbacks.add(callback);
}

/// Updates vplan automatically every 5 minutes
void _vplanAutoUpdater() async {
  while (true) {
    _xmldays = await _getcurrentdays();

    /// as the callbacks itself can call addvplanupdatecallback the Functions need to be copied
    var currentcallbacks = _callbacks;
    _callbacks = [];
    for (var callback in currentcallbacks) {
      callback(_xmldays!);
    }
    await Future.delayed(const Duration(minutes: 5));
  }
}

Future<List<XmlDay>> _getcurrentdays() async {
  XmlDay startday = (await XmlDay.async(null))!;
  List<String> freedaysStrings = [];
  startday.xml.findAllElements("ft").forEach((node) {
    freedaysStrings.add(node.text);
  });
  var freedates = freedays(freedaysStrings);
  // goes one day back in case of the current day being free
  DateTime currentday = startday.date.subtract(const Duration(days: 1));
  List<XmlDay> days = [];
  for (int i = 0; i <= 4; i++) {
    currentday =
        nextday(currentday, freedates)!; //the next times needs to exist
    XmlDay? tmpday = await XmlDay.async(currentday);
    if (tmpday == null) {
      break;
    }
    days.add(tmpday);
  }
  return days;
}

class Plan {
  final List<List<Lesson?>> lessons;
  final List<XmlDay> days;
  final List<DateTime> freedates;
  Plan(this.lessons, this.days, this.freedates);

  static Plan newplan(String room, List<XmlDay> days) {
    //the startday is eventually not be a schoolday
    XmlDay startday = days[0];
    //get all free days
    List<String> freedaysStrings = [];
    startday.xml.findAllElements("ft").forEach((node) {
      freedaysStrings.add(node.text);
    });
    var freedates = freedays(freedaysStrings);
    List<List<Lesson?>> lessons = [];

    for (var i in days) {
      lessons.add(roomallocation(i, room));
    }
    return Plan(lessons, days, freedates);
  }
}

class Lesson {
  final int hour;
  final int room;
  final String subject;
  final String teacher;
  final String info;
  final String level;
  Lesson(
      this.hour, this.room, this.subject, this.teacher, this.info, this.level);
  Lesson.fromxmlnode(XmlNode node)
      : hour = int.parse(node.getElement("St")!.text.toString()),
        room = int.parse(node.getElement("Ra")!.text.toString()),
        subject = node.getElement("Fa")!.text.toString(),
        teacher = node.getElement("Le")!.text.toString(),
        info = node.getElement("If")!.text.toString(),
        level = node.parent!.parent!.getElement("Kurz")!.text.toString();

  String printString() {
    return """hour $hour:
  room: $room
  subject: $subject
  teacher: $teacher
  info: $info
  Stufe: $level
""";
  }
}

class XmlDay {
  XmlDocument xml;
  DateTime date;
  XmlDay(this.xml, this.date);

  List<List<DateTime>> gethourtimes() {
    List<List<DateTime>> times = [[], []];
    var xmlhours = xml.findAllElements("KlStunden").first.children;
    for (var xmlhour in xmlhours) {
      String? startstring = xmlhour.getAttribute("ZeitVon");
      List<int> hour_minute = [];

      startstring!.split(":").forEach((element) {
        hour_minute.add(int.tryParse(element)!);
      });
      times[0].add(DateTime.fromMillisecondsSinceEpoch(
          (hour_minute[0] - 1) * 3600000 + hour_minute[1] * 60000));
      String? endstring = xmlhour.getAttribute("ZeitBis");
      hour_minute = [];

      endstring!.split(":").forEach((element) {
        hour_minute.add(int.tryParse(element)!);
      });
      times[1].add(DateTime.fromMillisecondsSinceEpoch(
          (hour_minute[0] - 1) * 3600000 + hour_minute[1] * 60000));
    }
    return times;
    //xml.getAttributeNode("KlStunden"); //xml.findAllElements("KlStunden");
  }

  static Future<XmlDay?> async(DateTime? date) async {
    //date ??= trim(DateTime.now());
    //vpmobil needs day and month to have two digits; eg. January, 4th -> 01.04
    String pad(int date) => date < 10 ? "0$date" : date.toString();

    String xmlname = date == null
        ? "Klassen.xml"
        : "PlanKl${date.year}${pad(date.month)}${pad(date.day)}.xml";
    debugPrint("Xmlname:$xmlname");
    http.Response? plan;
    try {
      plan = await http.get(
          Uri.https("z2.stundenplan24.de",
              "/schulen/52002736/mobil/mobdaten/$xmlname"),
          headers: {
            'authorization':
                "Basic ${base64Encode(utf8.encode('${jsonconfig.vpuser}:${jsonconfig.vppasswd}'))}"
          });
    } catch (_) {
      debugPrint("connecting to stundenplan24.de failed");
      return null;
    }
    try {
      return XmlDay(XmlDocument.parse(plan.body), date ?? trim(DateTime.now()));
    } catch (_) {
      debugPrint("Xml Parser failed");
      return null;
    }
  }
}

DateTime trim(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<Lesson?> roomallocation(XmlDay plan, String room) {
  var rooms = plan.xml.findAllElements("Ra");
  List<XmlNode> filteredrooms = [];
  //todo: room does not exist
  rooms.forEach((node) {
    node.text == room ? filteredrooms.add(node.ancestors.first) : "";
  });
  List<Lesson?> lessons = [];
  for (int i = 0; i < MAXHOURSPERDAY; i++) {
    lessons.add(null);
  }
  //print("test")
  for (var node in filteredrooms) {
    lessons[int.parse(node.getElement("St")!.text.toString()) - 1] =
        Lesson.fromxmlnode(node);
  }

  return lessons;
}

List<DateTime> freedays(List<String> days) {
  DateTime freetodate(String strdate) {
    return DateTime(int.parse(strdate.substring(0, 2)) + 2000,
        int.parse(strdate.substring(2, 4)), int.parse(strdate.substring(4, 6)));
  }

  List<DateTime> dates = [];

  for (var i in days) {
    dates.add(freetodate(i));
  }
  return dates;
}

//returns the next regular school day
DateTime? nextday(DateTime currentday, List<DateTime> freedates) {
  for (int i = 0; i < 60; i++) {
    currentday = currentday.add(const Duration(days: 1));
    if (currentday.weekday == DateTime.sunday ||
        currentday.weekday == DateTime.saturday) {
      //print("wochenende");
      continue;
    }
    if (freedates.contains(currentday)) {
      //print("freier Tag");
      continue;
    }
    //print(currentday);
    return currentday;
  }
}

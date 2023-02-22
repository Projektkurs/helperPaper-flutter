import "package:http/http.dart" as http;
import "package:helperpaper/main_header.dart";
import "package:xml/xml.dart";
import 'dart:collection';

const maxHoursPerDay = 7;
List<XmlDay>? _xmldays;
List<void Function(List<XmlDay>)> _callbacks = [];
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
    _xmldays = await XmlDay._getcurrentdays();

    /// as the callbacks itself can call addvplanupdatecallback the Functions need to be copied
    var currentcallbacks = _callbacks;
    _callbacks = [];
    for (var callback in currentcallbacks) {
      callback(_xmldays!);
    }
    _xmldays![0].getrooms();
    await Future.delayed(const Duration(minutes: 5));
  }
}

/// a complete plan of School lessons for the next 5 days. If vpmobil does not have
/// the plans for all five days, it might be less.
class Plan {
  final List<List<Lesson?>> lessons;
  final List<XmlDay> days;
  final List<DateTime> freedates;
  Plan(this.lessons, this.days, this.freedates);

  static Plan roomplan(String room, List<XmlDay> days) {
    //the startday is eventually not be a schoolday
    var freedates = freedays(days[0].xml);
    List<List<Lesson?>> lessons = [];

    for (var i in days) {
      lessons.add(roomallocation(i, room));
    }
    return Plan(lessons, days, freedates);
  }

  static Plan classplan(String level, List<XmlDay> days) {
    //the startday might eventually not be a schoolday
    var freedates = freedays(days[0].xml);
    List<List<Lesson?>> lessons = [];

    for (var i in days) {
      lessons.add(classalocation(i, level));
    }
    return Plan(lessons, days, freedates);
  }
}

/// a school lesson with its related data.
class Lesson {
  final int hour;
  final String room; // a room might be not just a number
  final String subject;
  final String teacher;
  final String info;
  final String level;
  Lesson(
      this.hour, this.room, this.subject, this.teacher, this.info, this.level);
  Lesson.fromxmlnode(XmlNode node)
      : hour = int.parse(node.getElement("St")!.text.toString()),
        room = (node.getElement("Ra")!.text.toString()),
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

  /// returns a list within a list which hold the start and end times of the
  /// lessons. The first list has two rows. The first holds a list of the start
  /// times and the second a list of the end times.
  List<List<DateTime>> gethourtimes() {
    List<List<DateTime>> times = [[], []];
    var xmlhours = xml.findAllElements("KlStunden").first.children;
    //get the current Date
    DateTime now = DateTime.now();
    now = now.subtract(Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        milliseconds: now.millisecond,
        microseconds: now.microsecond));
    for (var xmlhour in xmlhours) {
      String? startstring = xmlhour.getAttribute("ZeitVon");
      List<int> hourMinute = [];
      startstring!.split(":").forEach((element) {
        hourMinute.add(int.tryParse(element)!);
      });
      times[0].add(DateTime.fromMillisecondsSinceEpoch(
          (hourMinute[0]) * 3600000 + hourMinute[1] * 60000));
      times[0].last =
          times[0].last.add(Duration(microseconds: now.microsecondsSinceEpoch));
      String? endstring = xmlhour.getAttribute("ZeitBis");
      hourMinute = [];

      endstring!.split(":").forEach((element) {
        hourMinute.add(int.tryParse(element)!);
      });
      times[1].add(DateTime.fromMillisecondsSinceEpoch(
          (hourMinute[0]) * 3600000 + hourMinute[1] * 60000));
      times[1].last =
          times[1].last.add(Duration(microseconds: now.microsecondsSinceEpoch));
    }
    return times;
  }

  static Future<List<XmlDay>> _getcurrentdays() async {
    XmlDay startday = (await XmlDay.async(null))!;
    List<String> freedaysStrings = [];
    startday.xml.findAllElements("ft").forEach((node) {
      freedaysStrings.add(node.text);
    });
    var freedates = freedays(startday.xml);
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

  List<String> _getelementsorted(String elementname) {
    HashSet<String> roomset = HashSet();
    var roomiter = xml.findAllElements(elementname);
    for (var element in roomiter) {
      if (!roomset.contains(element.innerText) && element.innerText != "") {
        roomset.add(element.innerText);
      }
    }
    return List.from(roomset)..sort();
  }

  List<String> getrooms() {
    return _getelementsorted("Ra");
  }

  List<String> getclasses() {
    HashSet<String> roomset = HashSet();
    var roomiter = xml.findAllElements("Kurz");
    for (var element in roomiter) {
      if (!roomset.contains(element.innerText) &&
          element.innerText.startsWith("0")) {
        roomset.add(element.innerText.substring(1));
      }
    }
    return List.from(roomset)..sort();
  }
}

DateTime trim(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<Lesson?> roomallocation(XmlDay plan, String room) {
  var rooms = plan.xml.findAllElements("Ra");
  List<XmlNode> filteredrooms = [];
  for (var node in rooms) {
    node.text == room ? filteredrooms.add(node.ancestors.first) : 0;
  }
  List<Lesson?> lessons = [];
  for (int i = 0; i < maxHoursPerDay; i++) {
    lessons.add(null);
  }
  for (var node in filteredrooms) {
    lessons[int.parse(node.getElement("St")!.text.toString()) - 1] =
        Lesson.fromxmlnode(node);
  }

  return lessons;
}

List<Lesson?> classalocation(XmlDay plan, String level) {
  var levels = plan.xml.findAllElements("Kurz");
  XmlNode? levelnode;
  for (var node in levels) {
    //print(node.text);
    node.text == level ? levelnode = (node.ancestors.first) : 0;
  }
  //print(levelnode);
  List<Lesson?> lessons = [];
  for (int i = 0; i < maxHoursPerDay; i++) {
    lessons.add(null);
  }
  //for (var node in filteredrooms) {
  //st is the hour in which the lesson takes place
  //  lessons[int.parse(node.getElement("St")!.text.toString()) - 1] =
  //      Lesson.fromxmlnode(node);
  //}
  for (var node in levelnode!.findAllElements("Std")) {
    //print(node);
    lessons[int.parse(node.getElement("St")!.text.toString()) - 1] =
        (Lesson.fromxmlnode(node));
  }
  return lessons;
}

List<DateTime> freedays(XmlDocument xml) {
  //get all free days
  List<String> freedaysStrings = [];
  xml.findAllElements("ft").forEach((node) {
    freedaysStrings.add(node.text);
  });
  DateTime freetodate(String strdate) {
    return DateTime(int.parse(strdate.substring(0, 2)) + 2000,
        int.parse(strdate.substring(2, 4)), int.parse(strdate.substring(4, 6)));
  }

  List<DateTime> dates = [];

  for (var i in freedaysStrings) {
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
      continue;
    }
    if (freedates.contains(currentday)) {
      continue;
    }
    return currentday;
  }
  return null;
}

/* RoomResevation/component.dart - RoomResevation to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:helperpaper/httpserver.dart' as req;

class RoomResevation extends Component<RoomResevationConfig> {
  RoomResevation(
      {required Key key,
      required GeneralConfig gconfig,
      required RoomResevationConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  RoomResevation.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: RoomResevationConfig.fromJson(json['cconfig']));
  @override
  State<RoomResevation> createState() => RoomResevationState();
}

class RoomResevationState extends ComponentState<RoomResevation> {
  @override
  popup() async {
    await popupdialog(
        RoomResevationPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {
      updatefuture();
    });
  }

  late Future _future;
  @override
  void initState() {
    super.initState();
    updatefuture();
  }

  updatefuture() async {
    _future = Future.microtask(() async {
      //print(DateTime.tryParse(jsonDecode(body)[1]['start']));
      return (await req.reqGetEventRangeCurrentdayOffset(widget.cconfig.room))
          .body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.none:
            return componentbuild(Container(
                //color: Colors.amberAccent,
                width: 200,
                height: 200,
                child: const Center(
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          strokeWidth: 20,
                        )))));
          case ConnectionState.done:
            try {
              List<Map<String, dynamic>> events = [];
              for (var event in jsonDecode(snapshot.data)) {
                events.add(event);
              }
              List<TableRow> tablerow = [];
              tablerow.add(TableRow(children: [
                Text(
                  "Generelle Informationen:",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if ((widget.cconfig as RoomResevationConfig).showDescription)
                  Text("Beschreibung:",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium)
              ]));
              print("events:$events");
              for (var event in events) {
                var name = event['headline'];
                DateTime startTime = DateTime.tryParse(event['start']!)!;
                var start = "${startTime.hour}:${startTime.minute}";
                DateTime stopTime = DateTime.tryParse(event['stop']!)!;
                var stop = "${stopTime.hour}:${stopTime.minute}";

                tablerow.add(TableRow(children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Text(
                        "Name: $name\nStart:  $start\nStop:  $stop",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                  if ((widget.cconfig as RoomResevationConfig).showDescription)
                    Center(child: Text(event['description'] ?? ""))
                ]));
              }
              return componentbuild(Table(
                textDirection: TextDirection.ltr,
                border: TableBorder.all(width: 1.0, color: Colors.black),
                children: tablerow,
              ));
            } catch (_) {
              debugPrint("creating roomReservation failed: $_");
              return componentbuild(Container(
                  //color: Colors.amberAccent,
                  ));
            }
        }
      },
    );
  }
}

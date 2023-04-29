/* RoomResevation/popup.dart - popup menu of RoomResevation component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:helperpaper/httpserver.dart' as req;
import 'package:intl/intl.dart';

class RoomResevationPopup extends Popup<RoomResevationConfig> {
  const RoomResevationPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<RoomResevationPopup> createState() => _RoomResevationPopupState();
}

class _RoomResevationPopupState extends PopupState<RoomResevationPopup> {
  late TextEditingController roomtextcontroller;
  late TextEditingController roomnametextcontroller;
  late TextEditingController roomdescriptiontextcontroller;
  final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  List<String> rooms = [];
  var _startTime = TimeOfDay.now();
  var _removeTime = TimeOfDay.now();
  var _stopTime = TimeOfDay.now();
  Widget firstpage(BuildContext context) {
    () async {
      var request = await req.req_resource("/user/get_rooms");
      if (request.body != "") {
        rooms = request.body.split("\n")..removeLast();
      }
    }();
    return Row(children: [
      RoomResevation(
        key: UniqueKey(),
        gconfig: widget.gconfig,
        cconfig: widget.cconfig,
        inpopup: true,
      ),
      Expanded(
        flex: widget.gconfig.flex,
        child: ListView(children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: // just a autocomplete textfield for room/lesson
                Autocomplete<String>(fieldViewBuilder: (BuildContext context,
                    TextEditingController textcontroller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
              roomtextcontroller = textcontroller;
              textcontroller.text = widget.cconfig.room;
              return TextField(
                controller: textcontroller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Raum',
                ),
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            }, optionsBuilder: (TextEditingValue textEditingValue) {
              var optionlist = rooms;
              return optionlist.where((String option) {
                return (option.toLowerCase())
                    .contains(textEditingValue.text.toLowerCase());
              });
            }, onSelected: (String value) {
              widget.cconfig.room = value;
              roomtextcontroller.text = value;
              setState(() {
                widget.cconfig.room = value;
              });
            }),
          ),
          ListTile(
              leading: Text("Zeige Beschreibung"),
              title: Switch(
                  value: widget.cconfig.showDescription,
                  onChanged: (val) => setState(() {
                        widget.cconfig.showDescription = val;
                      }))),
          ExpansionTile(title: Text("Event hinzufügen"), children: [
            ListTile(
                title: TextField(
              controller: roomnametextcontroller,
              decoration: const InputDecoration(labelText: "Name"),
            )),
            ListTile(
                title: TextField(
              controller: roomdescriptiontextcontroller,
              decoration: const InputDecoration(labelText: "Beschreibung"),
            )),
            ListTile(
                title: Text("start: ${_startTime.hour}:${_startTime.minute}"),
                onTap: () {
                  showTimePicker(context: context, initialTime: _startTime)
                      .then((value) => setState(() {
                            _startTime = value ?? _startTime;
                          }));
                }),
            ListTile(
                title: Text("stop: ${_stopTime.hour}:${_stopTime.minute}"),
                onTap: () {
                  showTimePicker(context: context, initialTime: _stopTime)
                      .then((value) => setState(() {
                            _stopTime = value ?? _stopTime;
                          }));
                }),
            ListTile(
                title: const Text("Event erstellen"),
                onTap: () {
                  DateTime date = DateTime.now();

                  date = date.subtract(Duration(
                      microseconds: date.microsecond,
                      milliseconds: date.millisecond,
                      hours: date.hour,
                      minutes: date.minute));
                  DateTime startDate = date.add(Duration(
                      hours: _startTime.hour, minutes: _startTime.minute));
                  DateTime stopDate = date.add(Duration(
                      hours: _stopTime.hour, minutes: _stopTime.minute));

                  //final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

                  Map<String, String> form = {
                    'room_name': widget.cconfig.room,
                    'description': roomdescriptiontextcontroller.text,
                    'headline': roomnametextcontroller.text,
                    'start': formatter.format(startDate),
                    'stop': formatter.format(stopDate),
                  };
                  req
                      .req_resource("/room/add_event", bodyWithUsername: form)
                      .then((value) => setState(() {}));
                })
          ]),
          ExpansionTile(
            title: Text("Event entfernen"),
            children: [
              ListTile(
                  title: Text(
                      "Zeitpunkt: ${_removeTime.hour}:${_removeTime.minute}"),
                  onTap: () {
                    showTimePicker(context: context, initialTime: _removeTime)
                        .then((value) => setState(() {
                              _removeTime = value ?? _removeTime;
                            }));
                  }),
              ListTile(
                  title: const Text("Event entfernen"),
                  onTap: () {
                    DateTime date = DateTime.now();

                    date = date.subtract(Duration(
                        microseconds: date.microsecond,
                        milliseconds: date.millisecond,
                        hours: date.hour,
                        minutes: date.minute));
                    DateTime removeDate = date.add(Duration(
                        hours: _removeTime.hour, minutes: _removeTime.minute));

                    //final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

                    Map<String, String> form = {
                      'room_name': widget.cconfig.room,
                      'remove_datetime': formatter.format(removeDate)
                    };
                    req
                        .req_resource("/room/remove_event",
                            bodyWithUsername: form)
                        .then((value) => setState(() {}));
                  })
            ],
          )
        ]),
      )
    ]);
  }

  @override
  void initState() {
    //oldcconfig = widget.cconfig;
    oldcconfig = RoomResevationConfig();
    tabs = [firstpage];
    super.initState();
    roomnametextcontroller = TextEditingController();
    roomdescriptiontextcontroller = TextEditingController();
  }
}

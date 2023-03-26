/* vertretungsplan/popup.dart - config menu for Vertretungsplan 
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:helperpaper/vpmobil.dart' as vp;

class VertretungsplanPopup extends Popup<VertretungsplanConfig> {
  const VertretungsplanPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<VertretungsplanPopup> createState() => _VertretungsplanPopupState();
}

enum _Roomlesson { room, lesson }

class _VertretungsplanPopupState extends PopupState<VertretungsplanPopup> {
  late TextEditingController roomtextcontroller;
  List<String> rooms = [];
  List<String> classes = [];
  late _Roomlesson roomlesson;
  Widget firstpage(BuildContext context) {
    return Row(children: [
      SubstitutionPlan(
        key: UniqueKey(),
        gconfig: widget.gconfig,
        cconfig: widget.cconfig,
        inpopup: true,
      ),
      Expanded(
          flex: widget.gconfig.flex,
          child: ListView(children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: SelectableRadio<_Roomlesson>(
                      value: _Roomlesson.lesson,
                      groupvalue: roomlesson,
                      onPressed: () {
                        setState(() {
                          roomtextcontroller.text = widget.cconfig.lesson;
                          roomlesson = _Roomlesson.lesson;
                          widget.cconfig.islesson = true;
                        });
                      },
                      text: 'Vertretungsplan',
                    )),
                Expanded(
                    flex: 1,
                    child: SelectableRadio<_Roomlesson>(
                      value: _Roomlesson.room,
                      groupvalue: roomlesson,
                      onPressed: () {
                        setState(() {
                          roomtextcontroller.text = widget.cconfig.room;
                          roomlesson = _Roomlesson.room;
                          widget.cconfig.islesson = false;
                        });
                      },
                      text: 'Belegungsplan',
                    ))
              ],
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: // just a autocomplete textfield for room/lesson
                  Autocomplete<String>(
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textcontroller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  roomtextcontroller = textcontroller;
                  textcontroller.text = widget.cconfig.islesson
                      ? widget.cconfig.lesson
                      : widget.cconfig.room;
                  return TextField(
                    controller: textcontroller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: widget.cconfig.islesson ? 'Klasse' : 'Raum',
                    ),
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                  );
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  var optionlist = widget.cconfig.islesson ? classes : rooms;
                  return optionlist.where((String option) {
                    return (option.toLowerCase())
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String value) {
                  setState(() {
                    if (widget.cconfig.islesson) {
                      widget.cconfig.lesson = value;
                    } else {
                      widget.cconfig.room = value;
                    }
                    roomtextcontroller.text = value;
                  });
                },
              ),
            )
          ]))
    ]);
  }

  @override
  void initState() {
    roomlesson =
        widget.cconfig.islesson ? _Roomlesson.lesson : _Roomlesson.room;
    vp.addvplandirectcallback((p0) {
      if (mounted) {
        setState(() {
          rooms = p0[0].getrooms();
          classes = p0[0].getclasses();
        });
      }
    });
    oldcconfig = VertretungsplanConfig('', '', false);
    tabs = [firstpage];
    super.initState();
  }
}

/* Note - Note to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class Note extends Component {
  @override
  Note(
      {required Key key,
      required GeneralConfig gconfig,
      required NoteConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  String? name = "Note";
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> tmpconf = super.toJson();
    return tmpconf;
  }

  Note.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: NoteConfig.fromJson(json['cconfig']));

  @override
  State<Note> createState() => NoteState();
}

class NoteState extends ComponentState<Note> {
  late DateTime now;
  bool timeupdatective = false;
  @override
  popup() async {
    await popupdialog(
        NotePopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(FittedBox(
      fit: BoxFit.contain,
      child: Text(
        widget.cconfig.text,
      ),
    ));
  }
}

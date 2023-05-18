/* note/component.dart - a Widget that can show custom text as selected in popup
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';

class Note extends Component<NoteConfig> {
  Note(
      {required Key key,
      required GeneralConfig gconfig,
      required NoteConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

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
    super.popup();
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(FittedBox(
      fit: BoxFit.contain,
      child: Text(
        widget.cconfig.text,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }
}

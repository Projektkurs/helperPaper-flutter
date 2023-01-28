/* Note - Note to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:flutter/services.dart';
import 'package:helperpaper/main_header.dart';

class NotePopup extends Popup<NoteConfig> {
  const NotePopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<NotePopup> createState() => _NotePopupState();
}

class _NotePopupState extends PopupState<NotePopup> {
  late TextEditingController _textctrl;
  String text = "";

  /// lambda function cannot be used as they are compiled before getters are
  int step = 0;
  Widget firstpage(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        child: TextField(
          maxLines: null,
          controller: _textctrl,
          onChanged: (value) => widget.cconfig.text = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '',
          ),
        ));
  }

  @override
  void initState() {
    _textctrl = TextEditingController(text: widget.cconfig.text);
    oldcconfig = NoteConfig();
    tabs = [firstpage, firstpage];
    super.initState();
  }
}

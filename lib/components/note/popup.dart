/* Note - Note to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class NotePopup extends Popup<NoteConfig> {
  const NotePopup({super.key, required super.gconfig, required super.cconfig});

  @override
  State<NotePopup> createState() => _NotePopupState();
}

class _NotePopupState extends PopupState<NotePopup> {
  /// lambda function cannot be used as they are compiled before getters are

  int step = 0;
  Widget firstpage(BuildContext context) {
    switch (step) {
      case 1:
        return Container();
      default:
        return const SizedBox.expand();
    }
    ;
  }

  @override
  void initState() {
    oldcconfig = NoteConfig();
    tabs = [firstpage, firstpage];
    super.initState();
  }
}

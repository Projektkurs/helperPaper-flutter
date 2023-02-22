/* example/popup.dart - popup menu of example component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class ExamplePopup extends Popup<ExampleConfig> {
  const ExamplePopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<ExamplePopup> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends PopupState<ExamplePopup> {
  Widget firstpage(BuildContext context) {
    return const SizedBox.expand();
  }

  @override
  void initState() {
    oldcconfig = ExampleConfig();
    tabs = [firstpage];
    super.initState();
  }
}

/* example - example to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class ExamplePopup extends Popup<ExampleConfig> {
  const ExamplePopup(
      {super.key, required super.gconfig, required super.cconfig});

  @override
  State<ExamplePopup> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends PopupState<ExamplePopup> {
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
    oldcconfig = ExampleConfig();
    tabs = [firstpage, firstpage];
    super.initState();
  }
}

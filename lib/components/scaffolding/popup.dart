/* componentconfig.dart - universal config for all components
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class ScaffoldingPopup extends Popup<ScaffoldingConfig> {
  const ScaffoldingPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<ScaffoldingPopup> createState() => _ScaffoldingPopupState();
}

class _ScaffoldingPopupState extends PopupState<ScaffoldingPopup> {
  /// lambda function cannot be used as they are compiled before getters are
  int step = 0;
  Widget firstpage(BuildContext context) {
    return const SizedBox.expand();
  }

  @override
  void initState() {
    oldcconfig = ScaffoldingConfig();
    tabs = [firstpage];
    super.initState();
  }
}

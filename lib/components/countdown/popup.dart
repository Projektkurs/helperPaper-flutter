/* Countdown
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class CountdownPopup extends Popup<CountdownConfig> {
  const CountdownPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<CountdownPopup> createState() => _CountdownPopupState();
}

class _CountdownPopupState extends PopupState<CountdownPopup> {
  /// lambda function cannot be used as they are compiled before getters are
  int step = 0;
  Widget firstpage(BuildContext context) {
    return const SizedBox.expand();
  }

  @override
  void initState() {
    oldcconfig = CountdownConfig();
    tabs = [firstpage];
    super.initState();
  }
}

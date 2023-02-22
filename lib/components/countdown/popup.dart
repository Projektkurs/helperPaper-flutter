/* countdown/config.dart - popup menu for countdown component
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
  Widget firstpage(BuildContext context) {
    return Row(children: [
      Countdown(
        key: UniqueKey(),
        gconfig: widget.gconfig,
        cconfig: widget.cconfig,
        inpopup: true,
      ),
      Expanded(
          flex: widget.gconfig.flex,
          child: ListView(children: [
            ListTile(
                leading: const Text("Verbleibende Zeit als Leiste"),
                title: Switch(
                    value: widget.cconfig.showbar,
                    onChanged: (val) => setState(() {
                          widget.cconfig.showbar = val;
                        })))
          ]))
    ]);
  }

  @override
  void initState() {
    oldcconfig = CountdownConfig();
    tabs = [firstpage];
    super.initState();
  }
}

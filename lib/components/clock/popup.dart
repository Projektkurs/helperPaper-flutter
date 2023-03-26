/* clock/popup.dart - popup menu for clock component 
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/header.dart';

class ClockPopup extends Popup<ClockConfig> {
  const ClockPopup({
    super.key,
    required super.gconfig,
    required super.cconfig,
    super.byempty,
  });

  @override
  State<ClockPopup> createState() => _ClockPopupState();
}

class _ClockPopupState extends PopupState<ClockPopup> {
  /// current translationtable
  var ctr = tr['pop_clk']!;
  late final List<DropdownMenuItem<String>> _numberface =
      [ctr['clockface1']!, ctr['clockface2']!, ctr['clockface3']!]
          .map((dynamic e) => e.toString().split('.').last)
          .toList()
          .map((String e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList();

  Widget firstpage(BuildContext context) {
    late List<Widget> configmenu;
    if (widget.cconfig.isdigital == true) {
      configmenu = [
        Tooltip(
            waitDuration: msgdur,
            message: tr['generic']!['d_fontwidth']!,
            child: ListTile(
                leading: SizedBox(
                    width: (Theme.of(context).textTheme.titleSmall!.fontSize ??
                            16) *
                        6,
                    child: Text(tr['generic']!['fontwidth']!,
                        style: Theme.of(context).textTheme.titleSmall)),
                trailing: SizedBox(
                    width: (Theme.of(context).textTheme.titleSmall!.fontSize ??
                            16) *
                        2.5,
                    child: Text((widget.cconfig.fontweight.index.toString()))),
                title: Slider(
                    value: (widget.cconfig.fontweight.index).toDouble(),
                    onChanged: (double value) {
                      setState(() {
                        widget.cconfig.fontweight =
                            fontweights[value.round().toInt()];
                      });
                    },
                    min: 0.0,
                    max: 8.0))),
      ];
    } else {
      List<Widget> clockhands = [
        Tooltip(
            waitDuration: msgdur,
            message: ctr['d_hour_hand']!,
            child: ListTile(
              enabled: true,
              leading: Text(ctr['hour_hand']!,
                  style: Theme.of(context).textTheme.titleSmall),
              //replace at some point with relative size
              title: Icon(Icons.color_lens,
                  color: widget.cconfig.hourColor, size: 45),
              onTap: () {
                colorDialog(context, widget.cconfig.hourColor, setState)
                    .then((value) => setState(() {
                          widget.cconfig.hourColor = value;
                        }));
              },
            )),
        Tooltip(
            waitDuration: msgdur,
            message: ctr['d_minute_hand']!,
            child: ListTile(
              enabled: true,
              leading: Text(ctr['minute_hand']!,
                  style: Theme.of(context).textTheme.titleSmall),
              //replace at some point with relative size
              title: Icon(Icons.color_lens,
                  color: widget.cconfig.minuteColor, size: 45),
              onTap: () {
                colorDialog(context, widget.cconfig.minuteColor, setState)
                    .then((value) => setState(() {
                          widget.cconfig.minuteColor = value;
                        }));
              },
            )),
        Tooltip(
            waitDuration: msgdur,
            message: ctr['d_second_hand']!,
            child: ListTile(
              enabled: true,
              leading: Text(ctr['second_hand']!,
                  style: Theme.of(context).textTheme.titleSmall),
              //replace at some point with relative size
              title: Icon(Icons.color_lens,
                  color: widget.cconfig.secondColor, size: 45),
              onTap: () {
                colorDialog(context, widget.cconfig.secondColor, setState)
                    .then((value) => setState(() {
                          widget.cconfig.secondColor = value;
                        }));
              },
            )),
      ];
      configmenu = [
        ExpansionTile(
          title: Text(ctr['clockhands']!),
          initiallyExpanded: true,
          children: clockhands,
        ),
        ExpansionTile(
          title: Text(ctr['buildin_digitalclock']!),
          initiallyExpanded: true,
          children: [
            ListTile(
                leading: SizedBox(
                    width: (Theme.of(context).textTheme.titleSmall!.fontSize ??
                            16) *
                        6,
                    child: Text(tr['generic']!['fontsize']!,
                        style: Theme.of(context).textTheme.titleSmall)),
                trailing: SizedBox(
                    width: (Theme.of(context).textTheme.titleSmall!.fontSize ??
                            16) *
                        2.5,
                    child: Text(
                        (widget.cconfig.textScaleFactor.toStringAsFixed(2)))),
                title: Slider(
                    value: (widget.cconfig.textScaleFactor).toDouble(),
                    onChanged: (double value) {
                      setState(() {
                        widget.cconfig.textScaleFactor = value;
                      });
                    },
                    min: 0.4,
                    max: 3.0)),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: ListTile(
                        leading: Text(tr['generic']!['active']!),
                        title: Switch(
                            value: widget.cconfig.showDigitalClock,
                            onChanged: (val) => setState(() {
                                  widget.cconfig.showDigitalClock = val;
                                })))),
                Expanded(
                    flex: 1,
                    child: ListTile(
                        leading: Text(tr['generic']!['color']!),
                        title: GestureDetector(
                            child: Icon(Icons.color_lens,
                                color: widget.cconfig.digitalClockColor,
                                size: 45),
                            onTap: () {
                              colorDialog(
                                      context,
                                      widget.cconfig.digitalClockColor,
                                      setState)
                                  .then((value) => setState(() {
                                        widget.cconfig.digitalClockColor =
                                            value;
                                      }));
                            }))),
              ],
            )
          ],
        ),
        ExpansionTile(
            title: Text(ctr['clockface']!),
            initiallyExpanded: true,
            children: [
              ListTile(
                  leading: Text(ctr['hands_numbers']!,
                      style: Theme.of(context).textTheme.titleSmall),
                  title: DropdownButton<String>(
                      value: _numberface[!widget.cconfig.showNumbers
                              ? 0
                              : widget.cconfig.showAllNumbers
                                  ? 2
                                  : 1]
                          .value,
                      items: _numberface,
                      onChanged: (e) {
                        setState(() {
                          if (e == _numberface[0].value) {
                            widget.cconfig.showNumbers = false;
                          } else {
                            widget.cconfig.showNumbers = true;
                            if (e == _numberface[1].value) {
                              widget.cconfig.showAllNumbers = false;
                            } else {
                              widget.cconfig.showAllNumbers = true;
                            }
                          }
                        });
                      })),
              ListTile(
                  leading: Text(tr['generic']!['color']!),
                  title: GestureDetector(
                      child: Icon(Icons.color_lens,
                          color: widget.cconfig.numberColor, size: 45),
                      onTap: () {
                        colorDialog(
                                context, widget.cconfig.numberColor, setState)
                            .then((value) => setState(() {
                                  widget.cconfig.numberColor = value;
                                }));
                      }))
            ])
      ];
    }
    return Row(
      children: [
        Clock(
          key: UniqueKey(),
          gconfig: widget.gconfig,
          cconfig: widget.cconfig,
        ),
        Expanded(
            flex: widget.gconfig.flex,
            child: Container(
                margin: const EdgeInsets.all(8),
                child: ListView(children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: SelectableRadio<bool>(
                              value: false,
                              groupvalue: widget.cconfig.isdigital,
                              onPressed: () => setState(() {
                                    widget.cconfig.isdigital = false;
                                  }),
                              text: 'analog')),
                      Expanded(
                          flex: 1,
                          child: SelectableRadio<bool>(
                              value: true,
                              groupvalue: widget.cconfig.isdigital,
                              onPressed: () => setState(() {
                                    widget.cconfig.isdigital = true;
                                  }),
                              text: 'digital')),
                    ],
                  ),
                  ...configmenu
                ])))
      ],
    );
  }

  @override
  void initState() {
    tabs = [
      firstpage,
    ];
    oldcconfig = ClockConfig();
    super.initState();
  }
}

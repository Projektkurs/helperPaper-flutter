/* empty/popup.dart - popup menu for empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class EmptyPopup extends StatefulWidget {
  final GeneralConfig gconfig;
  final EmptyPopupRef popupref;
  const EmptyPopup({super.key, required this.gconfig, required this.popupref});

  @override
  State<EmptyPopup> createState() => _EmptyPopupState();
}

class EmptyPopupRef {
  Componentenum components = Componentenum.defaultcase;
  Widget? replacement;
  GeneralConfig? gconfig;
  dynamic cconfig;
  int scaffoldingchilds = 2;
  EmptyPopupRef();
}

class _EmptyPopupState extends State<EmptyPopup> {
  /// used by the second page to know wether the a mediaquery.pop should be vetoed.
  bool blockscope = false;
  //lambda function cannot be used as they are compiled before getters are
  late List<Widget? Function(BuildContext context)> tabs;
  bool blocknext = false;
  dynamic cconfig;

  Widget firstpage(BuildContext context) {
    blocknext = widget.popupref.components == Componentenum.defaultcase;
    void setenum(Componentenum val) {
      setState(() {
        if (val == widget.popupref.components) {
          widget.popupref.components = Componentenum.defaultcase;
        } else {
          widget.popupref.components = val;
        }
      });
    }

    return Row(children: [
      const Spacer(flex: 1),
      Expanded(
          //start Component Radio
          flex: 10,
          child: ListView(children: [
            SelectableRadio<Componentenum>(
                value: Componentenum.horizontal,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setenum(Componentenum.horizontal);
                },
                text: 'Spalte',
                leading: const Icon(Icons.view_column_rounded)),
            SelectableRadio<Componentenum>(
                value: Componentenum.vertical,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setenum(Componentenum.vertical);
                },
                text: 'Zeile',
                leading: const Icon(Icons.table_rows)),
            widget.popupref.components == Componentenum.vertical ||
                    widget.popupref.components == Componentenum.horizontal
                ? ListTile(
                    leading: SizedBox(
                        width: (Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize ??
                                16) *
                            4,
                        child: Text("Containeranzahl",
                            style: Theme.of(context).textTheme.titleMedium)),
                    trailing: SizedBox(
                        width: (Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize ??
                                16) *
                            2.5,
                        child: Text((widget.popupref.scaffoldingchilds)
                            .toStringAsFixed(0))),
                    title: Slider(
                        value: widget.popupref.scaffoldingchilds.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            widget.popupref.scaffoldingchilds =
                                value.round().toInt();
                          });
                        },
                        min: 2,
                        max: 8))
                : const SizedBox.shrink(),
            SelectableRadio<Componentenum>(
              value: Componentenum.clock,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.clock);
              },
              text: 'Uhr',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.countdown,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.countdown);
              },
              text: 'Countdown',
              leading: const Icon(Icons.timelapse),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.note,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.note);
              },
              text: 'Notiz',
              leading: const Icon(Icons.text_snippet),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.vertretungsplan,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.vertretungsplan);
              },
              text: 'Vertretungsplan',
              //leading: const Icon(Icons.calendar_month),
              leading: const Icon(Icons.event_note),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.example,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.example);
              },
              text: 'Beispiel Widget',
              //leading: const Icon(Icons.poin)
            ),
          ])),
      const Spacer(flex: 1)
    ]);
  }

  int step = 0;
  // for any reason, the programm crashes if a function which returns Widget
  // that is used by build calls Navigator.pop, meaning that it will return null
  // if the context is needed to be poped and Navigator.pop is called in build
  Widget? secondpage(BuildContext context) {
    late Popup popup;
    switch (widget.popupref.components) {
      case (Componentenum.clock):
        widget.popupref.cconfig = ClockConfig();
        popup = ClockPopup(
            gconfig: widget.gconfig,
            cconfig: widget.popupref.cconfig,
            byempty: true);
        break;
      case (Componentenum.countdown):
        widget.popupref.cconfig = CountdownConfig();
        popup = CountdownPopup(
            gconfig: widget.gconfig,
            cconfig: widget.popupref.cconfig,
            byempty: true);
        break;
      case (Componentenum.empty):
      case (Componentenum.note):
        widget.popupref.cconfig = NoteConfig();
        popup = NotePopup(
            gconfig: widget.gconfig,
            cconfig: widget.popupref.cconfig,
            byempty: true);
        break;
      case (Componentenum.example):
        widget.popupref.cconfig = ExampleConfig();
        popup = ExamplePopup(
            gconfig: widget.gconfig,
            cconfig: widget.popupref.cconfig,
            byempty: true);
        break;
      case (Componentenum.vertretungsplan):
        widget.popupref.cconfig = VertretungsplanConfig("007", "5a", false);
        popup = VertretungsplanPopup(
            gconfig: widget.gconfig,
            cconfig: widget.popupref.cconfig,
            byempty: true);
        break;
      case (Componentenum.vertical):
        widget.popupref.cconfig = ScaffoldingConfig();
        return null;
      case (Componentenum.horizontal):
        widget.popupref.cconfig = ScaffoldingConfig();
        return null;
      default:
        break;
    }
    return WillPopScope(
        child: popup,
        onWillPop: () async {
          setState(() {
            step--;
          });
          return false;
        });
  }

  @override
  void initState() {
    tabs = [
      firstpage,
      secondpage,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //pregenerate widget as blocknext is dependent on it being generated
    Widget? tab = tabs[step](context);
    List<Widget> indicatorbar = [];
    if (tab == null) {
      Navigator.pop(context);
      return const SizedBox();
    }
    if (step == 1) {
      return tabs[1](context)!;
    }
    for (int i = 0; i <= tabs.length - 1; i++) {
      indicatorbar.add(Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(
                left: i == 0 ? 30 : 3,
                right: i == tabs.length - 1 ? 30 : 3,
                bottom: 2),
            decoration: BoxDecoration(
                color: i <= step ? Colors.blue : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            height: 20,
          )));
    }

    return Defaultdialog(
        applybutton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .006),
            backgroundColor: blocknext == true
                ? Colors.grey
                : const Color.fromARGB(255, 101, 184, 90),
          ),
          onPressed: () => blocknext == true
              ? null
              : step == tabs.length - 1
                  ? Navigator.pop(context)
                  : setState(() {
                      step++;
                    }),
          child: Text(step == tabs.length - 1 ? 'Anwenden' : 'Weiter',
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineLarge!.fontSize!)),
        ),
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .006),
              backgroundColor: step == 0
                  ? const Color.fromARGB(255, 184, 90, 90)
                  : const Color.fromARGB(255, 184, 183, 90),
            ),
            onPressed: () => step == 0
                ? () {
                    widget.popupref.replacement = null;
                    Navigator.pop(context);
                  }()
                : setState(() {
                    step--;
                  }),
            child: Text(step == 0 ? 'Zurück' : 'Weiter',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge!.fontSize!)),
          ),
          body: Column(
              children: [Expanded(child: tab!), Row(children: indicatorbar)]),
        ));
  }
}

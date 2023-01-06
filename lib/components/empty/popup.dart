/* empty_menu.dart - config menu for Empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/components/scaffholding/config.dart';
import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/component/menu.dart';
import 'package:progress_stepper/progress_stepper.dart';

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
  int scaffoldingchilds = 2;
  EmptyPopupRef();
}

class _EmptyPopupState extends State<EmptyPopup> {
  //lambda function cannot be used as they are compiled before getters are
  late List<Widget Function(BuildContext context)> tabs;
  bool blocknext = false;

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
            ListTile(
                leading: SizedBox(
                    width: (Theme.of(context).textTheme.titleMedium!.fontSize ??
                            16) *
                        4,
                    child: Text("Width",
                        style: Theme.of(context).textTheme.titleMedium)),
                trailing: SizedBox(
                    width: (Theme.of(context).textTheme.titleMedium!.fontSize ??
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
                    max: 8)),
            SelectableRadio<Componentenum>(
                value: Componentenum.horizontal,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setenum(Componentenum.horizontal);
                },
                text: 'Column',
                leading: const Icon(Icons.view_column_rounded)),
            SelectableRadio<Componentenum>(
                value: Componentenum.vertical,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setenum(Componentenum.vertical);
                },
                text: 'Row',
                leading: const Icon(Icons.table_rows)),
            SelectableRadio<Componentenum>(
              value: Componentenum.clock,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.clock);
              },
              text: 'Clock',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.vertretungsplan,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setenum(Componentenum.vertretungsplan);
              },
              text: 'Vertretungsplan',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
                value: Componentenum.example,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setenum(Componentenum.example);
                },
                text: 'Column',
                leading: const Icon(Icons.view_column_rounded)),
            //componentTile(widget.gconfig, context, setState)
          ]) //end Component Radio
          ),
      const Spacer(flex: 1)
    ]);
  }

  int step = 0;
  Widget secondpage(BuildContext context) {
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
    tabs = [firstpage, secondpage, secondpage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //pregenerate widget as blocknext is dependent on it being generated
    Widget tab = tabs[step](context);
    List<Widget> indicatorbar = [];
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
          child: Text(step == tabs.length - 1 ? 'Apply' : 'Next',
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
            child: Text(step == 0 ? 'Cancle' : 'Previous',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge!.fontSize!)),
          ),
          body: Column(
              children: [Expanded(child: tab), Row(children: indicatorbar)]),
        ));
  }
}

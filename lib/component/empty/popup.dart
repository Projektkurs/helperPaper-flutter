/* empty_menu.dart - config menu for Empty component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/component/componentconfig.dart';
import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/component/menu.dart';

class EmptyPopup extends StatefulWidget {
  final GeneralConfig gconfig;
  final EmptyPopupRef popupref;
  const EmptyPopup({super.key, required this.gconfig, required this.popupref});

  @override
  State<EmptyPopup> createState() => _EmptyPopupState();
}

class EmptyPopupRef {
  Componentenum components = Componentenum.defaultcase;
  int scaffoldingchilds = 2;
  EmptyPopupRef();
}

class _EmptyPopupState extends State<EmptyPopup> {
  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    widget.popupref.components = Componentenum.horizontal;
                  });
                },
                text: 'Column',
                leading: const Icon(Icons.view_column_rounded)),
            SelectableRadio<Componentenum>(
                value: Componentenum.vertical,
                groupvalue: widget.popupref.components,
                onPressed: () {
                  setState(() {
                    widget.popupref.components = Componentenum.vertical;
                  });
                },
                text: 'Row',
                leading: const Icon(Icons.table_rows)),
            SelectableRadio<Componentenum>(
              value: Componentenum.clock,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setState(() {
                  widget.popupref.components = Componentenum.clock;
                });
              },
              text: 'Clock',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.vertretungsplan,
              groupvalue: widget.popupref.components,
              onPressed: () {
                setState(() {
                  widget.popupref.components = Componentenum.vertretungsplan;
                });
              },
              text: 'Vertretungsplan',
              leading: const Icon(Icons.query_builder),
            ),
            componentTile(widget.gconfig, context, setState)
          ]) //end Component Radio
          ),
      const Spacer(flex: 1)
    ]);
  }
}
/*extension Popup on EmptyState
{
  //start declaration
  //Popup get widget;
  //bool get emptyVal;
  //bool testVal = false;
  //Componentenum components = Componentenum.defaultcase;
  //dynamic handleOnPressed(int enable);
  //void setState(VoidCallback fn);
  //end declaration
  //int scaffoldingchilds=2;
  @override
  popup()async {
    print("openmenu");
    Componentenum components = Componentenum.defaultcase;
    int scaffoldingchilds=2;
    await popupdialog(context, setState,
    Row(children: [
      const Spacer(flex: 1),
      Expanded(
          //start Component Radio
          flex: 10,
          child: ListView(children: [
                    ListTile(
          leading:SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*4,
            child:Text("Width",style: Theme.of(context).textTheme.titleMedium)
          ),
          trailing: SizedBox(
            width: (Theme.of(context).textTheme.titleMedium!.fontSize ?? 16 )*2.5,
            child: Text((scaffoldingchilds).toStringAsFixed(0))),
            title: Slider(value: scaffoldingchilds.toDouble() , onChanged: (double value){setState((){scaffoldingchilds=value.round().toInt();});},
            min:2,
            max:8)
            ),
            SelectableRadio<Componentenum>(
                value: Componentenum.horizontal,
                groupvalue: components,
                onPressed: () {
                  setState(() {
                    components = Componentenum.horizontal;
                  });
                },
                text: 'Column',
                leading: const Icon(Icons.view_column_rounded)),
            SelectableRadio<Componentenum>(
                value: Componentenum.vertical,
                groupvalue: components,
                onPressed: () {
                  setState(() {
                    components = Componentenum.vertical;
                  });
                },
                text: 'Row',
                leading: const Icon(Icons.table_rows)),
            SelectableRadio<Componentenum>(
              value: Componentenum.clock,
              groupvalue: components,
              onPressed: () {
                setState(() {
                  components = Componentenum.clock;
                });
              },
              text: 'Clock',
              leading: const Icon(Icons.query_builder),
            ),
            SelectableRadio<Componentenum>(
              value: Componentenum.vertretungsplan,
              groupvalue: components,
              onPressed: () {
                setState(() {
                  components = Componentenum.vertretungsplan;
                });
              },
              text: 'Vertretungsplan',
              leading: const Icon(Icons.query_builder),
            ),
            componentTile(widget.gconfig,context,setState)
          ]) //end Component Radio
          ),
      const Spacer(flex: 1)
    ]));
    callback() {
    switch (components) {
      case Componentenum.horizontal:
        widget.gconfig.cconfig.replacement =
            Scaffolding(
                key: widget.gconfig.cconfig.key,
                direction: true,
                showlines: false,
                subcontainers: 2,
                gconfig: GeneralConfig(
                    widget.gconfig.flex, ScaffoldingConfig()));
        widget.gconfig.cconfig.apply = true;
        widget.gconfig.cconfig.replace!();
        break;
      case Componentenum.vertical:
        widget.gconfig.cconfig.replacement =
            Scaffolding(
                key: widget.gconfig.cconfig.key,
                direction: false,
                showlines: false,
                subcontainers: scaffoldingchilds,
                gconfig: GeneralConfig(
                    widget.gconfig.flex, ScaffoldingConfig()));
        widget.gconfig.cconfig.apply = true;
        widget.gconfig.cconfig.replace!();
        break;
      case Componentenum.clock:
        widget.gconfig.cconfig.replacement = Clock(
            key: (widget.gconfig.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(
                widget.gconfig.flex, const ClockConfig()));
        (widget.gconfig.cconfig as EmptyComponentConfig).apply = true;
        (widget.gconfig.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.vertretungsplan:
        widget.gconfig.cconfig.replacement =
            Vertretungsplan(
                key: (widget.gconfig.cconfig as EmptyComponentConfig)
                    .key,
                gconfig: GeneralConfig(
                    widget.gconfig.flex, VertretungsplanConfig("007")));
        (widget.gconfig.cconfig as EmptyComponentConfig).apply = true;
        (widget.gconfig.cconfig as EmptyComponentConfig).replace!();
        break;
      default:
        break;
    }
    components=Componentenum.defaultcase;
    setState(() {});
  }
}

  }
*/
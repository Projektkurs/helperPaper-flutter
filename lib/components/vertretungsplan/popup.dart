/* vertretungsplan.dart - config menu for Vertretungsplan 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';
/*
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
  /// lambda function cannot be used as they are compiled before getters are
  int step = 0;
  Widget firstpage(BuildContext context) {
    switch (step) {
      case 1:
        return Container();
      default:
        return const SizedBox.expand();
    }
  }

  @override
  void initState() {
    oldcconfig = ExampleConfig();
    tabs = [firstpage];
    super.initState();
  }
}*/

/*extension PopupVplan on State<Vertretungsplan> 
{
  //start declaration
  /*Popup get widget;
  bool get emptyVal;
  bool testVal = false;
  Componentenum components = Componentenum.defaultcase;
  dynamic handleOnPressed(int enable);
  void setState(VoidCallback fn);
  //end declaration
  late TextEditingController _roomtextcontroller;*/
  popup() async {
    TextEditingController roomtextcontroller= TextEditingController(text: widget.gconfig.cconfig.raum);
    await popupdialog(
    Row(children:[ Vertretungsplan( 
        key:GlobalKey(),
        //key:const Key("0"),
        gconfig: widget.gconfig),
        Expanded(flex: widget.gconfig.flex,child:
          ListView(
          children:[Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
            keyboardType: TextInputType.number,
            controller: roomtextcontroller,
            onSubmitted: (String value){
                widget.gconfig.cconfig.raum= value;
            },  
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              
              labelText: 'Raum',),)
        )]))]));

    (widget.gconfig.cconfig as VertretungsplanConfig).neuerplan=true;
    setState((){});
  }
}*/
  /*vertretungsplanmenuapplycallback() {
    _roomtextcontroller= TextEditingController(text: widget.gconfig.cconfig.raum);
    if (widget.configsetState != null) {
      (widget.gconfig.cconfig as VertretungsplanConfig).neuerplan=true;
      widget.configsetState!(() {});
    }
    handleOnPressed(-1);
  }/
}*/

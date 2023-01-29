/* vertretungsplan.dart - config menu for Vertretungsplan 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

class VertretungsplanPopup extends Popup<VertretungsplanConfig> {
  const VertretungsplanPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<VertretungsplanPopup> createState() => _VertretungsplanPopupState();
}

class _VertretungsplanPopupState extends PopupState<VertretungsplanPopup> {
  late TextEditingController roomtextcontroller;

  /// lambda function cannot be used as they are compiled before getters are
  int step = 0;
  Widget firstpage(BuildContext context) {
    return Row(children: [
      Vertretungsplan(
        key: UniqueKey(),
        //key:const Key("0"),
        gconfig: widget.gconfig,
        cconfig: widget.cconfig,
        inpopup: true,
      ),
      Expanded(
          flex: widget.gconfig.flex,
          child: ListView(children: [
            Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: roomtextcontroller,
                  onSubmitted: (String value) {
                    setState(() {
                      widget.cconfig.raum = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Raum',
                  ),
                ))
          ]))
    ]);
  }

  @override
  void initState() {
    roomtextcontroller = TextEditingController(text: widget.cconfig.raum);
    oldcconfig = VertretungsplanConfig("");
    tabs = [firstpage];
    super.initState();
  }
}
/*
extension PopupVplan on State<Vertretungsplan> 
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

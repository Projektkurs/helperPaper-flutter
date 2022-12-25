/* clock_menu.dart - config menu for Clock component 
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/main_header.dart';
import 'package:helperpaper/component/menu.dart';

extension ClockPopup on ClockState
{
  //start declaration
  //Popup get widget;
  //bool get emptyVal;
  //bool testVal=false;
  //Componentenum components=Componentenum.defaultcase;
  //dynamic handleOnPressed(int enable);
  //void setState(VoidCallback fn);
  //end declaration
  popup()async {
    bool darkmode=false;
    bool digital=false;
    await popupdialog(
  Row(children:[ Clock( 
        key:GlobalKey(),
        //key:const Key("0"),
        gconfig: widget.gconfig),
        Expanded(flex: widget.gconfig.flex,child:
        
          ListView(
          children:[
            ListTile(
            leading: Text("digital",style: Theme.of(context).textTheme.titleMedium),
            title:Switch(
            onChanged: (bool value) {
              setState(()  {digital = value;
              if(digital && widget.gconfig.cconfig.runtimeType==ClockConfig){
                widget.gconfig.cconfig=const ClockConfig.digital();
              }else{
                widget.gconfig.cconfig=const ClockConfig();
              }
              });
            },
            value: digital,
          )
            ),
            ListTile(
            leading: Text("darkmode",style: Theme.of(context).textTheme.titleMedium),
            title:Switch(
            onChanged: (bool value) {
              setState(()  {darkmode = value;
              if(darkmode && widget.gconfig.cconfig.runtimeType==ClockConfig){
                widget.gconfig.cconfig=const ClockConfig.dark();
              }else{
                widget.gconfig.cconfig=const ClockConfig();
              }
              });
            },
            value: darkmode,
          )
            ),
            componentTile(widget.gconfig,context,setState)]))])
    );
    setState(() {});
  }
}

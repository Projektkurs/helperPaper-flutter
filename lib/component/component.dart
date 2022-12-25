/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/main_header.dart';

abstract class Component extends StatefulWidget {
  Component({
    required Key key,
    required this.gconfig,
  }) : super(key: key);
  //todo: configMenu should be final
  GeneralConfig gconfig;
  bool built = false;
  Function? setState;

  Map<String, dynamic> toJson() => {
        'gconfig': gconfig,
      };

  //@override
  //State<Component> createState() => ComponentState();
}

abstract class ComponentState<T extends Component> extends State<T> {
  @override
  void initState() {
    SchedulerBinding.instance.scheduleFrameCallback((Duration duration) {
      widget.built = true;
      widget.setState = setState;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.gconfig.flex,
        child: Container(
          alignment: Alignment.center,
          // 5px and 20px should be changed to a value relative to screen size
          // and relative position
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  width: widget.gconfig.borderWidth ?? globalgconf.borderWidth!,
                  color: const Color.fromARGB(255, 73, 73, 73))),
          child: SizedBox.expand(child: Container()),
        ));
  }

  void popup();
  bool unitedborder = false;
  Widget componentbuild(Widget child) {
    return Expanded(
        flex: widget.gconfig.flex,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onDoubleTap:
                //isepaper? (){} : (){configmenu([widget.key!],widget.gconfig,constraints.maxWidth,constraints.maxHeight,setState);},
                isepaper
                    ? () {}
                    : () {
                        print("doubletab");
                        popup();
                      },

            /*popupdialog(ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.9,
                              /*decoration: BoxDecoration(
                                  //color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                      width: 4.0,
                                      color: const Color.fromARGB(
                                          255, 73, 73, 73))),*/
                              child: Text("test"),
                            )));
                      },*/
            /*singleMenu(Scaffold(

            floatingActionButton: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * .006),
                backgroundColor: const Color.fromARGB(255, 101, 184, 90),
                //backgroundColor: Theme.of(context).colorScheme.primary,
              ), //.copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () => (){},
              child: Text('Apply',
                  style: TextStyle(
                      fontSize: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .fontSize!)),
            ),
            body: Text("test"))));},*/

            child: Container(
                alignment: Alignment.center,
                // 5px and 20px should be changed to a value relative to screen size
                // and relative position
                margin: unitedborder
                    ? const EdgeInsets.symmetric(vertical: 5)
                    : const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                decoration: unitedborder
                    ? BoxDecoration(
                        border: Border.symmetric(
                            vertical: BorderSide(
                                width: widget.gconfig.borderWidth ??
                                    globalgconf.borderWidth! / 2,
                                color: const Color.fromARGB(255, 73, 73, 73)),
                            horizontal: BorderSide(
                                width: widget.gconfig.borderWidth ??
                                    globalgconf.borderWidth!,
                                color: const Color.fromARGB(255, 73, 73, 73))))
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            widget.gconfig.borderRadius ??
                                globalgconf.borderRadius!)),
                        border: Border.all(
                            width: widget.gconfig.borderWidth ??
                                globalgconf.borderWidth!,
                            color: widget.gconfig.borderColor ??
                                const Color.fromARGB(255, 73, 73, 73))),
                child: SizedBox.expand(child: child)),
          );
        }));
  }

  Widget singleMenu(child) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .07,
            vertical: MediaQuery.of(context).size.height * .07),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
        alignment: Alignment.center,
        child: child);
  }

  Future<void> popupdialog(Widget widget) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        print("newdialog");
        return AlertDialog(
            key: UniqueKey(),
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            scrollable: true,
            content: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        width: 4.0,
                        color: const Color.fromARGB(255, 73, 73, 73))),
                child: widget));
      },
    );
  }
}
/*mixin ComponentBuild<T extends State>
{
  //constructor cannot be used as setState will not have been declared at that time
  late Function popup; 
  Parent get widget;
  BuildContext get context;
  bool unitedborder=false;
  void setState(VoidCallback fn);
  Widget componentbuild(Widget child) {
    return Expanded(
      flex: widget.gconfig.flex,
      child:LayoutBuilder(builder:(BuildContext context, BoxConstraints constraints)
      {
        return GestureDetector(
          onDoubleTap:
          //isepaper? (){} : (){configmenu([widget.key!],widget.gconfig,constraints.maxWidth,constraints.maxHeight,setState);},
          isepaper? (){} : (){print("doubletab");popup();},
          child:Container(
          alignment: Alignment.center,
          // 5px and 20px should be changed to a value relative to screen size 
          // and relative position
          margin: unitedborder ? 
            const EdgeInsets.symmetric(vertical: 5) 
          : const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: 
            unitedborder ? 
            BoxDecoration(
              border:Border.symmetric(vertical: BorderSide(width: widget.gconfig.borderWidth?? globalgconf.borderWidth!/2,color: const Color.fromARGB(255, 73, 73, 73)),horizontal: BorderSide(width: widget.gconfig.borderWidth?? globalgconf.borderWidth!,color: const Color.fromARGB(255, 73, 73, 73)))


            )
            : 
            BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(widget.gconfig.borderRadius?? globalgconf.borderRadius!)),
              border:Border.all(width: widget.gconfig.borderWidth?? globalgconf.borderWidth!, color: widget.gconfig.borderColor ?? const Color.fromARGB(255, 73, 73, 73))),
          child: SizedBox.expand(child:child)),
      );})
    );
  }
}
void testdialog(BuildContext context) async{
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: MediaQuery.of(context).orientation == Orientation.portrait
            ? const BorderRadius.vertical(
            top: Radius.circular(500),
            bottom: Radius.circular(100),
          )
          //right radius should be as large as possible
          : const BorderRadius.horizontal(right: Radius.circular(9999),left: Radius.circular(400)),
        ),
        content:SingleChildScrollView(
          child: Text("test")
        ),
      );
    },
  );
}*/

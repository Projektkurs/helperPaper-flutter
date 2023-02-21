/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/main_header.dart';

abstract class Component extends StatefulWidget {
  Component(
      {Key? key,
      required this.gconfig,
      required this.cconfig,
      this.inpopup = false})
      : super(key: key);
  var cconfig;
  bool inpopup;
  //String? name;
  GeneralConfig gconfig;
  bool built = false;
  Function? setState;

  Map<String, dynamic> toJson() =>
      {'gconfig': gconfig, 'cconfig': cconfig, 'type': runtimeType.toString()};
}

class ComponentState<T extends Component> extends State<T> {
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

  void popup() {
    setState(() {});
  }

  bool unitedborder = false;
  Widget componentbuild(Widget child) {
    return Expanded(
        flex: widget.gconfig.flex,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onDoubleTap: isepaper | widget.inpopup
                ? () {}
                : () {
                    popup();
                  },
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

  /*Widget singleMenu(child) {
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
  }*/

  Future<void> popupdialog(Widget widget) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              key: UniqueKey(),
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              scrollable: false,
              content: widget);
        });
  }
}

class Defaultdialog extends StatefulWidget {
  const Defaultdialog(
      {Key? key, this.appBar, required this.child, this.applybutton})
      : super(key: key);
  final Widget? applybutton;
  final Widget child;
  final PreferredSize? appBar;
  @override
  _DefaultdialogState createState() => _DefaultdialogState();
}

class _DefaultdialogState extends State<Defaultdialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                width: 4.0, color: const Color.fromARGB(255, 73, 73, 73))),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Scaffold(
                floatingActionButton: widget.applybutton ??
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * .006),
                        backgroundColor:
                            const Color.fromARGB(255, 101, 184, 90),
                        //backgroundColor: Theme.of(context).colorScheme.primary,
                      ), //.copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Apply',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize!)),
                    ),
                appBar: widget.appBar,
                body: widget.child)));
  }
}

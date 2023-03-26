/* component.dart - wraper for widgets to apply uniform configs, positioning 
 * and updating
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/header.dart';

abstract class Component extends StatefulWidget {
  Component(
      {Key? key,
      required this.gconfig,
      required this.cconfig,
      this.inpopup = false})
      : super(key: key);

  /// saves the configuration that is specific for a specific implementation of Component
  final dynamic cconfig;

  /// if true, the Component cannot be double clicked to open the popup
  /// this is used by the empty popup to not open the popup recursively
  final bool inpopup;

  /// saves general information about the Component
  final GeneralConfig gconfig;

  /// will be set to true as soon as the state is mounted
  bool built = false;

  /// setState of the Widget
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

  /// opens the given Widget in a menu that overlays the rest of the Layout
  /// the widget has a fixed size and rounded corners
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

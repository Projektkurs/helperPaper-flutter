import 'package:helperpaper/main_header.dart';

abstract class Popup<T> extends StatefulWidget {
  final GeneralConfig gconfig;
  final T cconfig;

  ///disables the buttons as they are provided by
  final bool byempty;
  const Popup(
      {super.key,
      required this.gconfig,
      required this.cconfig,
      this.byempty = false});
}

abstract class PopupState<T extends Popup> extends State<T> {
  late List<Widget Function(BuildContext context)> tabs;
  bool blocknext = false;
  late GeneralConfig oldgconfig;
  late dynamic oldcconfig;
  void initState() {
    oldgconfig = GeneralConfig(0);
    oldgconfig.takeFrom(widget.gconfig);
    oldcconfig.copyFrom(widget.cconfig);
    super.initState();
  }

  int step = 0;
  @override
  Widget build(BuildContext context) {
    //pregenerate widget as blocknext is dependent on it being generated
    Widget tab = tabs[step](context);
    List<Widget> indicatorbar = [];
    int totaltabs = tabs.length - (widget.byempty ? 0 : 1);
    if (widget.byempty) {}
    for (int i = 0; i <= totaltabs; i++) {
      indicatorbar.add(Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(
                left: i == 0 ? 30 : 3,
                right: i == totaltabs ? 30 : 3,
                bottom: 2),
            decoration: BoxDecoration(
                color: i <= step + (widget.byempty ? 1 : 0)
                    ? Colors.blue
                    : Colors.grey,
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
          onPressed: () => step == totaltabs
              ? Navigator.pop(context)
              : setState(() {
                  debugPrint("nextstep");
                  step++;
                }),
          child: Text(step == totaltabs ? 'Apply' : 'Next',
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize!)),
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
                    widget.gconfig.takeFrom(oldgconfig);
                    widget.cconfig.copyFrom(oldcconfig);
                    Navigator.pop(context);
                  }()
                : setState(() {
                    step--;
                  }),
            child: Text(step == 0 ? 'Cancel' : 'Previous',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize!)),
          ),
          body: Column(
              children: [Expanded(child: tab), Row(children: indicatorbar)]),
        ));
  }
}

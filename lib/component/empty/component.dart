/* empty.dart - initial component used which config can be used to replace itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/component/componentconfig.dart';
import 'package:helperpaper/main_header.dart';

class Empty extends Component {
  Empty({
    required Key key,
    required GeneralConfig gconfig,
    required this.resizeWidget,
    required this.replaceChildren,
  }) : super(key: key, gconfig: gconfig);
  final Function resizeWidget;
  final Function replaceChildren;

  Empty.fromJson(
      Map<String, dynamic> json, this.resizeWidget, this.replaceChildren)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromjson(json['gconfig'],
                EmptyComponentConfig.fromJson(json["gconfig"]["cconfig"]))) {
    debugPrint("Emptyfromjson:$gconfig");
  }

  @override
  EmptyState createState() => EmptyState();
}

class EmptyState extends ComponentState<Empty> {
  @override
  popup() async {
    print("openmenu");

    EmptyPopupRef popupref = EmptyPopupRef();
    await popupdialog(EmptyPopup(gconfig: widget.gconfig, popupref: popupref));
    print("await");
    switch (popupref.components) {
      case Componentenum.horizontal:
        widget.gconfig.cconfig.replacement = Scaffolding(
            key: widget.gconfig.cconfig.key,
            direction: true,
            showlines: false,
            subcontainers: 2,
            gconfig: GeneralConfig(widget.gconfig.flex, ScaffoldingConfig()));
        widget.gconfig.cconfig.apply = true;
        widget.gconfig.cconfig.replace!();
        break;
      case Componentenum.vertical:
        widget.gconfig.cconfig.replacement = Scaffolding(
            key: widget.gconfig.cconfig.key,
            direction: false,
            showlines: false,
            subcontainers: popupref.scaffoldingchilds,
            gconfig: GeneralConfig(widget.gconfig.flex, ScaffoldingConfig()));
        widget.gconfig.cconfig.apply = true;
        widget.gconfig.cconfig.replace!();
        break;
      case Componentenum.clock:
        widget.gconfig.cconfig.replacement = Clock(
            key: (widget.gconfig.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex, const ClockConfig()));
        (widget.gconfig.cconfig as EmptyComponentConfig).apply = true;
        (widget.gconfig.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.vertretungsplan:
        widget.gconfig.cconfig.replacement = Vertretungsplan(
            key: (widget.gconfig.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(
                widget.gconfig.flex, VertretungsplanConfig("007")));
        (widget.gconfig.cconfig as EmptyComponentConfig).apply = true;
        (widget.gconfig.cconfig as EmptyComponentConfig).replace!();
        break;
      default:
        break;
    }
    if (widget.gconfig.cconfig.replacement != null) {
      replace();
    }
    //components = Componentenum.defaultcase;
    setState(() {});
  }

  replace() {
    widget.replaceChildren(widget.key, widget.gconfig.cconfig.replacement);
  }

  @override
  void initState() {
    widget.gconfig.cconfig.replace = replace;
    widget.gconfig.cconfig.key = widget.key!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gconfig.cconfig.apply) {
      debugPrint("apply");
    }
    return componentbuild(const SizedBox.expand());
  }
}

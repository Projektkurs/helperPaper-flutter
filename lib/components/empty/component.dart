/* empty.dart - initial component used which config can be used to replace itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/components/scaffholding/config.dart';
import 'package:helperpaper/main_header.dart';

class Empty extends Component {
  Empty({
    required Key key,
    required GeneralConfig gconfig,
    required EmptyComponentConfig cconfig,
    required this.resizeWidget,
    required this.replaceChildren,
  }) : super(key: key, gconfig: gconfig, cconfig: cconfig);

  final Function resizeWidget;
  final Function replaceChildren;

  Empty.fromJson(
      Map<String, dynamic> json, this.resizeWidget, this.replaceChildren)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: EmptyComponentConfig.fromJson(json['cconfig']));

  @override
  EmptyState createState() => EmptyState();
}

class EmptyState extends ComponentState<Empty> {
  Type a = EmptyState;
  @override
  popup() async {
    EmptyPopupRef popupref = EmptyPopupRef();
    await popupdialog(EmptyPopup(gconfig: widget.gconfig, popupref: popupref));

    //replace current widget if one was selected;
    switch (popupref.components) {
      case Componentenum.horizontal:
        widget.cconfig.replacement = Scaffolding(
            key: widget.cconfig.key,
            direction: true,
            showlines: false,
            subcontainers: 2,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: ScaffoldingConfig());
        widget.cconfig.apply = true;
        widget.cconfig.replace!();
        break;
      case Componentenum.vertical:
        widget.cconfig.replacement = Scaffolding(
            key: widget.cconfig.key,
            direction: false,
            showlines: false,
            subcontainers: popupref.scaffoldingchilds,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: ScaffoldingConfig());
        widget.cconfig.apply = true;
        widget.cconfig.replace!();
        break;
      case Componentenum.clock:
        widget.cconfig.replacement = Clock(
          key: (widget.cconfig as EmptyComponentConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: ClockConfig(),
        );
        (widget.cconfig as EmptyComponentConfig).apply = true;
        (widget.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.note:
        widget.cconfig.replacement = Note(
          key: (widget.cconfig as EmptyComponentConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: NoteConfig(),
        );
        (widget.cconfig as EmptyComponentConfig).apply = true;
        (widget.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.vertretungsplan:
        widget.cconfig.replacement = Vertretungsplan(
            key: (widget.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: VertretungsplanConfig("007"));
        (widget.cconfig as EmptyComponentConfig).apply = true;
        (widget.cconfig as EmptyComponentConfig).replace!();
        break;
      case Componentenum.example:
        widget.cconfig.replacement = Example(
            key: (widget.cconfig as EmptyComponentConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: ExampleConfig());
        (widget.cconfig as EmptyComponentConfig).apply = true;
        (widget.cconfig as EmptyComponentConfig).replace!();
        break;
      default:
        break;
    }
    if (widget.cconfig.replacement != null) {}
    debugPrint("widget got replaced");
    setState(() {});
  }

  _replace() {
    widget.replaceChildren(
      widget.key,
      widget.cconfig.replacement,
    );
  }

  @override
  void initState() {
    widget.cconfig.replace = _replace;
    widget.cconfig.key = widget.key!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cconfig.apply) {
      debugPrint("apply");
    }
    return componentbuild(const SizedBox.expand());
  }
}

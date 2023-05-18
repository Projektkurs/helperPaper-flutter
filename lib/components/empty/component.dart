/* empty/component.dart - initial component used which config can be used to replace itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/header.dart';

class Empty extends Component<EmptyConfig> {
  Empty({
    required Key key,
    required GeneralConfig gconfig,
    required EmptyConfig cconfig,
    required this.resizeWidget,
    required this.replaceChildren,
  }) : super(key: key, gconfig: gconfig, cconfig: cconfig);

  final Function resizeWidget;
  final void Function(Key?, Widget) replaceChildren;

  Empty.fromJson(
      Map<String, dynamic> json, this.resizeWidget, this.replaceChildren)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: EmptyConfig.fromJson(json['cconfig']));

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
            subcontainers: popupref.scaffoldingchilds,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: ScaffoldingConfig());
        // even though it is clear trough the constructor of Empty
        // that cconfig is of type EmptyConfig the rust compiler does not
        // recognice this optimization option, which is why
        // it is explicitly type casted here
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.vertical:
        widget.cconfig.replacement = Scaffolding(
            key: widget.cconfig.key,
            direction: false,
            showlines: false,
            subcontainers: popupref.scaffoldingchilds,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: popupref.cconfig);
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.clock:
        widget.cconfig.replacement = Clock(
          key: (widget.cconfig as EmptyConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: popupref.cconfig,
        );
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.countdown:
        widget.cconfig.replacement = Countdown(
          key: (widget.cconfig as EmptyConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: popupref.cconfig,
        );
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.note:
        widget.cconfig.replacement = Note(
          key: (widget.cconfig as EmptyConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: popupref.cconfig,
        );
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.image:
        widget.cconfig.replacement = ImageComponent(
          key: (widget.cconfig as EmptyConfig).key,
          gconfig: GeneralConfig(widget.gconfig.flex),
          cconfig: popupref.cconfig,
        );
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.substitutionPlan:
        widget.cconfig.replacement = SubstitutionPlan(
            key: (widget.cconfig as EmptyConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: popupref.cconfig);
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.roomReservation:
        widget.cconfig.replacement = RoomResevation(
            key: (widget.cconfig as EmptyConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: popupref.cconfig);
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.example:
        widget.cconfig.replacement = Example(
            key: (widget.cconfig as EmptyConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: popupref.cconfig);
        (widget.cconfig as EmptyConfig).replace!();
        break;
      case Componentenum.userInformation:
        widget.cconfig.replacement = UserInformation(
            key: (widget.cconfig as EmptyConfig).key,
            gconfig: GeneralConfig(widget.gconfig.flex),
            cconfig: popupref.cconfig);
        (widget.cconfig as EmptyConfig).replace!();
        break;
      default:
        break;
    }
  }

  _replace() {
    widget.replaceChildren(
      widget.key,
      widget.cconfig.replacement!,
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
    return componentbuild(const SizedBox.expand());
  }
}

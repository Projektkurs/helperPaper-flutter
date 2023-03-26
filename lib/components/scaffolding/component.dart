/* scaffolding/component.dart - wraper for components or itself
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/header.dart';

import 'callbacks.dart';
import 'resizeline.dart';

class Scaffolding extends Component {
  Scaffolding(
      {required Key key,
      required gconfig,
      required ScaffoldingConfig cconfig,
      required this.direction, //false=vertical, true=horizontal
      required this.showlines,
      required this.subcontainers}) //number of subcontainers
      : super(key: key, gconfig: gconfig, cconfig: cconfig);
  bool showlines;
  final bool direction;
  int subcontainers;
  var state = ScaffoldingState();
  @override
  ScaffoldingState createState() => state;
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> retval = {
      'direction': direction,
      'subcontainers': ((state.childs.length + 1) / 2).floor(),
      'gconfig': gconfig,
      'cconfig': cconfig,
      'type': 'Scaffolding'
    };
    if (state.childs.isNotEmpty) {
      for (int i = 0; i < (state.childs.length + 1) / 2; i++) {
        retval['Child$i'] = state.childs[i * 2];
      }
    }
    return retval;
  }

  Map<String, dynamic>? jsonconf;
  bool updatejson = false;
  Scaffolding.fromJson(Map<String, dynamic> json, {Key? key})
      : direction = json['direction'],
        subcontainers = json['subcontainers'],
        showlines = false,
        jsonconf = json,
        updatejson = false,
        super(
            key: key ?? GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: ScaffoldingConfig.fromJson(json['cconfig'])) {
    if (subcontainers != 0) {
      if (state.mounted) {
        state.setState(() {
          updatejson = true;
        });
      } else {
        state.updatejson = true;
      }
    } else {
      subcontainers = 1;
    }
  }
}

class ScaffoldingState extends State<Scaffolding> with callbacks {
  bool updatejson = false;
  @override
  final double resizelineWidth = 8.0;
  @override
  List<Widget> childs = [];
  @override
  List<int> width = [];
  @override
  BoxConstraints callconstraints = const BoxConstraints();

  @override
  Widget build(BuildContext context) {
    widget.setState = setState;
    widget.state = this;
    return Expanded(
        flex: widget.gconfig.flex,
        child: Container(
            alignment: Alignment.center,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              callconstraints = constraints;
              //must be before any constructor of Widthline to ensure the children are
              //already appended to the DOM
              for (int i = 0; i < childs.length; i++) {
                if (childs[i].runtimeType == ResizeLine &&
                    (childs[i] as ResizeLine).built) {
                  (childs[i] as ResizeLine).child.setState(() {
                    (childs[i] as ResizeLine).length = widget.direction
                        ? constraints.maxHeight
                        : constraints.maxWidth;
                    (childs[i] as ResizeLine).enabled = widget.showlines;
                  });
                }
                //todo: built does currently include deleted nodes
                else if (childs[i].runtimeType == Scaffolding &&
                    (childs[i] as Scaffolding).built) {
                  (childs[i] as Scaffolding).setState!(() {
                    (childs[i] as Scaffolding).showlines = widget.showlines;
                  });
                }
              }

              for (int i = 0;
                  widget.subcontainers * 2 - 1 > childs.length;
                  i++) {
                if (childs.isNotEmpty) {
                  childs.add(ResizeLine(
                      key: GlobalKey(),
                      color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0),
                      transparency: 1.0,
                      enabled: widget.showlines,
                      length: widget.direction
                          ? constraints.maxHeight
                          : constraints.maxWidth,
                      width: resizelineWidth,
                      direction: widget.direction,
                      resizefromline: resizefromline));
                }
                Component? tmpcomp;
                if (updatejson) {
                  tmpcomp = jsontoComp(widget.jsonconf!['Child$i'],
                      resizeWidget, replaceChildren);
                }
                tmpcomp ??= Empty(
                  gconfig: GeneralConfig(widget.gconfig.flex),
                  cconfig: EmptyConfig(),
                  key: GlobalKey(),
                  resizeWidget: resizeWidget,
                  replaceChildren: replaceChildren,
                );
                childs.add(tmpcomp);
              }
              updatejson = false;
              if (widget.subcontainers * 2 - 1 < childs.length) {
                childs.removeRange(
                    max(widget.subcontainers * 2 - 1, 0), childs.length);
              }

              //immitation start componentbuild
              SchedulerBinding.instance.scheduleFrameCallback((Duration d) {
                widget.built = true;
              });
              //widget.built=true;

              if (widget.direction) {
                return Row(children: childs);
              } else {
                return Column(children: childs);
              }
            })));
  }
}

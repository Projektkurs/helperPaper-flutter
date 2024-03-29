/* resizeline.dart - interactive way to resize Widgets inside of scaffholding
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';

class ResizeLine extends StatefulWidget {
  ResizeLine(
      {required Key key,
      this.color = Colors.blue,
      this.transparency = 1,
      required this.enabled,
      this.direction = false,
      required this.length,
      required this.width,
      required this.resizefromline})
      : super(key: key);

  final Color color;
  final double transparency;
  bool enabled;
  final bool direction;
  double length;
  final double width;
  final Function resizefromline;
  bool built = false;
  ResizeLineState child = ResizeLineState();
  // TODO: implement getter
  enable(bool val) {
    enabled = val;
  }

  @override
  State<ResizeLine> createState() => ResizeLineState();
}

class ResizeLineState extends State<ResizeLine> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.scheduleFrameCallback((Duration duration) {
      widget.child = this;
      widget.built = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              widget.resizefromline(
                  widget.key,
                  //gives delta on mainaxis
                  widget.direction ? details.delta.dx : details.delta.dy);
            });
          },
          child: Container(
              color: widget.color,
              // TODO: math function that scales .9 dependent on proportion
              width: widget.direction ? widget.width : widget.length * .9,
              height: widget.direction ? widget.length * .9 : widget.width,
              child: const SizedBox.shrink()));
    } else {
      return Container();
    }
  }
}

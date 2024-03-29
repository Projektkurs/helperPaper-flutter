/* example/component.dart - example to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';

class Example extends Component<ExampleConfig> {
  Example(
      {required Key key,
      required GeneralConfig gconfig,
      required ExampleConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  Example.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: ExampleConfig.fromJson(json['cconfig']));

  @override
  State<Example> createState() => ExampleState();
}

class ExampleState extends ComponentState<Example> {
  @override
  popup() async {
    await popupdialog(
        ExamplePopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(Container(
      color: Colors.amberAccent,
    ));
  }
}

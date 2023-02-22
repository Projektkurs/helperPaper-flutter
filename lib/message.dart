/* message.dart - framework to communicate between epaper and device
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/main_header.dart';

mixin message {
  File fifo = File('../updatefifo');
  void setState(void Function() fn);
  late String jsonsave;
  late int maincontainers;
  late bool scafffromjson;

  epaperUpdateInterrupt() async {
    Future<String> fifocontent = fifo.readAsString();
    fifocontent.then((message) {
      setState(() {
        jsonsave = File('./configs/defaultconfig').readAsStringSync();
        maincontainers = jsonDecode(jsonsave)['subcontainers'];
        (this as AppState).mainscreenkey = GlobalKey();
        scafffromjson = true;
        File('config').writeAsString(jsonEncode(jsonconfig));
      });
      epaperUpdateInterrupt();
    });
  }
}

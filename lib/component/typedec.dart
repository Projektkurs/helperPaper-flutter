/* misc.dart -  miscellaneous functions and enums
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/components/scaffholding/config.dart';
import 'package:helperpaper/components/vertretungsplan/component.dart';
import 'package:helperpaper/main_header.dart';

enum Componentenum {
  horizontal,
  vertical,
  clock,
  defaultcase,
  empty,
  example,
  vertretungsplan
}

//used by most Components to open the config menu if they are pressed.
//assigned to configMenuMainParse in main.dart
typedef Configmenut = void Function(List<Key> key, GeneralConfig config,
    double width, double height, void Function(VoidCallback fn) configsetState);

Configmenut configmenu = (List<Key> key, GeneralConfig config, double width,
    double height, void Function(VoidCallback fn) configsetState) {};
typedef PopupCallback = void Function(Component widget, Function setState);
//returns Type of Component, must be exactly what runtimetype.toString returns
Type stringtoType(String type) {
  switch (type) {
    case ("Scaffolding"):
      return Scaffolding;
    case ("Empty"):
      return Empty;
    case ("Clock"):
      return Clock;
    case ("Example"):
      return Example;
    case ("Vertretungsplan"):
      return Vertretungsplan;
    default:
      return Component;
  }
}

Component? jsontoComp(Map<String, dynamic> json, Function resizeWidget,
    Function replaceChildren) {
  //switch(json['gconfig']["cconfig"]['type']){
  switch (stringtoType(json['type'])) {
    case (Scaffolding):
      return Scaffolding.fromJson(json);
    case (Empty):
      return Empty.fromJson(json, resizeWidget, replaceChildren);
    case (Clock):
      return Clock.fromJson(json);
    case (Vertretungsplan):
      return Vertretungsplan.fromJson(json);
    case (Example):
      return Example.fromJson(json);
    //case("ExampleComponent"):return ExampleComponent;
    default:
      debugPrint("Warning: jsontoComp from Scaffolding returned null");
      return null;
  }
}

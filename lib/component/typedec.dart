/* typedec.dart -  miscellaneous functions and enums
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:helperpaper/header.dart';

enum Componentenum {
  horizontal,
  vertical,
  clock,
  countdown,
  defaultcase,
  empty,
  example,
  note,
  substitutionPlan,
  image,
  roomReservation,
  userInformation
}

///used by most Components to open the config menu if they are pressed.
///assigned to configMenuMainParse in main.dart
typedef Configmenut = void Function(List<Key> key, GeneralConfig config,
    double width, double height, void Function(VoidCallback fn) configsetState);

Configmenut configmenu = (List<Key> key, GeneralConfig config, double width,
    double height, void Function(VoidCallback fn) configsetState) {};
typedef PopupCallback = void Function(Component widget, Function setState);

/// returns Type of Component, must be exactly what runtimetype.toString returns
Component? jsontoComp(Map<String, dynamic> json, resizeWidget,
    void Function(Key?, Widget) replaceChildren) {
  switch ((json['type'])) {
    case ('Scaffolding'):
      return Scaffolding.fromJson(json);
    case ('Empty'):
      return Empty.fromJson(json, resizeWidget, replaceChildren);
    case ('Clock'):
      return Clock.fromJson(json);
    case ('Countdown'):
      return Countdown.fromJson(json);
    case ('Note'):
      return Note.fromJson(json);
    case ('SubstitutionPlan'):
      return SubstitutionPlan.fromJson(json);
    case ('Example'):
      return Example.fromJson(json);
    case ('ImageComponent'):
      return ImageComponent.fromJson(json);
    case ('RoomResevation'):
      return RoomResevation.fromJson(json);
    case ('UserInformation'):
      return UserInformation.fromJson(json);
    default:
      debugPrint('Warning: jsontoComp from Scaffolding returned null');
      return null;
  }
}

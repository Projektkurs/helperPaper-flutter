/* RoomResevation/config.dart - config of RoomResevation component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
class RoomResevationConfig {
  String room = "";
  bool showDescription = false;
  void copyFrom(RoomResevationConfig config) {}

  RoomResevationConfig();

  Map<String, dynamic> toJson() =>
      {'room': room, 'showDescription': showDescription};

  RoomResevationConfig.fromJson(Map<String, dynamic> json)
      : room = json['room'] ?? "",
        showDescription = json['showDescription'] ?? false;
}

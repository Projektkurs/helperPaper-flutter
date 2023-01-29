import 'package:helperpaper/main_header.dart';

class VertretungsplanConfig {
  late String raum;
  void copyFrom(VertretungsplanConfig config) {
    raum = config.raum;
  }

  VertretungsplanConfig(this.raum);

  Map<String, dynamic> toJson() => {"raum": raum};

  VertretungsplanConfig.fromJson(Map<String, dynamic> json)
      : raum = json["raum"];
}

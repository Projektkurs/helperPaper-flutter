/* countdown/config.dart - config of countdown component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
*/
class CountdownConfig {
  bool showbar = true;
  void copyFrom(CountdownConfig config) {
    showbar = config.showbar;
  }

  CountdownConfig();

  Map<String, dynamic> toJson() => {'showbar': showbar};

  CountdownConfig.fromJson(Map<String, dynamic> json)
      : showbar = json['showbar'] ?? true;
}

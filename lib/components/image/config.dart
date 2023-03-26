/* Image/config.dart - config of Image component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
class ImageConfig {
  String name = 'logo.jpg';
  void copyFrom(ImageConfig config) {
    name = config.name;
  }

  ImageConfig();

  Map<String, dynamic> toJson() => {'name': name};

  ImageConfig.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? 'logo.jpg';
}

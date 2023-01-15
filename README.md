# helperpaper

Die grafische Applikation des helper:Papers.
Sie läuft sowohl auf dem Endgerät des Nutzers, als auch auf dem helper:Paper

## Einführung

Um diese Applikation zu kompilieren wird, das [Framework Flutter](https://docs.flutter.dev/get-started/install) benötigt.

### Ausführung
Auf dem Computer, auf dem Flutter installiert ist, kann die App mit `flutter run` im debug Modus ausgeführt werden.
Mit `flutter build linux` kann des Weiteren die App auch kompiliert werden, was die Performance maßgeblich verbessert. Um die App im Modus für das E-Paper zu bauen, muss an diesen Befehl noch `--dart-define=isepaper=true` angehängt werden. Wenn Sie die APP auf einem anderen Gerät laufen lassen möchten, so können Sie mit `flutter help build` die anderen Optionen aufgeführt bekommen.
## Benutzung

Wenn die App zum erstem Mal geöffnet wird, so ist der Bildschirm leer. Über den Knopf in der unteren linken Ecke lässt sich das Sidemenü öffnen, in dem neue Plätze für Widgets hinzugefügt werden können, sowie Layouts gespeichert und geladen werden können. Durch doppeltes Klicken auf ein leeres Widget öffnet sich ein Popup-Menü, in welchem ausgewählt werden kann, wodurch das leere Widget ersetzt werden soll.

## Übersicht
Der Entry Point befindet sich in [main.dart](/lib/main.dart).
In diesem wird die Applikation gestartet. Dafür wird erst die Datei "config" in dem vom Betriebssystem zugewiesenem Platz gelesen (im Fall von Linux ist dies meist `/home/$USER/.local/share/com.example.helperpaper/config`). Falls diese nicht existiert, wird ein neues leeres Layout erstellt. 

Wenn sie existiert, wird das gespeicherte Layout ausgelesen und von [main_screen.dart](/lib/screens/main_screen.dart) gebaut. MainScreen ist ebenfalls für das Sidemenü zuständig, über welches sich [settings_screen.dart](/lib/screens/settings_screen.dart) öffnen lässt. 

Im Ordner [components](/lib/components/) befinden sich die einzelnen Widgets. Die meisten Widgets besitzen drei Dateien: 
- [component.dart](/lib/components/example/component.dart) beinhaltet das Widget selbst. Das Widget vererbt von [Component](/lib/component/component.dart, wodurch die Kommunikation mit den Widgets einheitlich ist, da alle Widgets eine generelle Konfiguration, sowie eine spezielle besitzen. Des Weiteren wird dadurch garantiert, dass die Methoden, die für das JSON format benötigt werden, implementiert sind.
- [config.dart](/lib/components/example/config.dart) ist die spezielle Konfiguration des Widgets. Während diese nicht von irgendeiner Klasse erbt, so wird erwartet, dass die Funktionen toJson und fromJson vorhanden sind
- [popup.dart](/lib/components/example/popup.dart) beinhaltet das Popup-Menü für die Konfiguration des Widgets. Es wird durch ein AlertDialog geöffnet.

In [translation.dart](/lib/translation.dart) ist eine HashMap, welche die Sprachausgabe speichert, sowie eine Get-Funktion, um auf diese Zuzugreifen.
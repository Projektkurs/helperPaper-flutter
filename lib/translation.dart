/* translation.dart - framework to communicate between epaper and device
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

var currentLanguage = 'de';

/// the delay of Tooltip messages
const Duration msgdur = Duration(milliseconds: 300);

/// a global translation table
///
/// it will return the translation considering currentLanguage
Map<String, Map<String, String>> get tr {
  switch (currentLanguage) {
    case ('de'):
      return de;
    default:
      return de;
  }
}

/// The german translation
///
///
Map<String, Map<String, String>> get de => {
      'layout': {
        'add_container': 'Feld hinzufügen',
        'remove_container': 'Feld entfernen',
        'settings': 'Einstellungen',
      },
      'generic': {
        'save': 'Speichern',
        'load': 'Laden',
        'sync': 'Synchronisieren',
        'reset': 'Zurücksetzen',
        'active': 'Aktiv',
        'color': 'Farbe',
        'fontwidth': 'Schriftdicke',
        'd_fontwidth':
            'Die Schriftbreite beschreibt die Dicke der Linien von einzelnen Buchstaben',
        'fontsize': 'Schriftgröße'
      },
      'sidebar': {
        'addcontainer': 'Widget hinzufügen',
        'removecontainer': 'Widget Entfernen',
        'editmode': 'Editiermodus',
        'settings': 'Einstellungen',
        'save': 'Layout Speichern',
        'load': 'Layout Laden',
        'resetlayout': 'Layout Zurücksetzen',
      },
      'widgets': {
        'clock': 'Uhr',
        'countdown': 'Countdown',
        'empty': 'Leeres Widget',
        'note': 'Notiz',
        'subschedule': 'Vertretungsplan',
        'scaffolding': 'Gerüst'
      },
      'settings': {},
      'pop_clk': {
        'clockhands': 'Uhrzeiger',
        'hour_hand': 'Stundenzeiger',
        'd_hour_hand': 'setzt die Farbe des Stundenzeigers der Analogen Uhr',
        'minute_hand': 'Minutenzeiger',
        'd_minute_hand': 'setzt die Farbe des Minutenzeigers der Analogen Uhr',
        'second_hand': 'Sekundenzeiger',
        'd_second_hand': 'setzt die Farbe des Sekundenzeigers der Analogen Uhr',
        'border': 'Umrandung',
        'buildin_digitalclock': 'eingebaute Digitaluhr',
        'digitalclock': 'Digitaluhr:',
        'hands_numbers': 'Ziffern',
        'clockface': 'Ziffernblatt',
        'clockface1': 'keine',
        'clockface2': 'reduziert',
        'clockface3': 'erweitert',
        'marks': 'Marken'
      },
      'countdown': {
        'before_start': 'Die erste Stunde\nhat noch nicht begonnen.',
        'after_last': 'die letzte Stunde\nist vorbei.',
        'break': 'Es ist die Pause\n vor der % Stunde.',
        'lesson': 'Es ist die % Stunde.'
      }
    };

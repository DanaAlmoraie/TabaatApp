import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class WeatherTranslator {
  static String translate(String condition, AppLocalizations tr) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return tr.sunny;

      case 'partly cloudy':
        return tr.partlyCloudy;

      case 'cloudy':
        return tr.cloudy;

      case 'overcast':
        return tr.overcast;

      case 'mist':
        return tr.mist;

      case 'patchy rain possible':
        return tr.lightRainPossible;

      case 'light rain':
        return tr.lightRain;

      case 'moderate rain':
        return tr.moderateRain;

      case 'heavy rain':
        return tr.heavyRain;

      case 'thunderstorm':
        return tr.thunderstorm;

      default:
        return condition;
    }
  }

  static IconData icon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny_rounded;

      case 'partly cloudy':
        return Icons.wb_cloudy_rounded;

      case 'cloudy':
      case 'overcast':
        return Icons.cloud_circle_rounded;

      case 'mist':
        return Icons.foggy;

      case 'light rain':
      case 'moderate rain':
        return Icons.grain_rounded;

      case 'heavy rain':
        return Icons.thunderstorm_rounded;

      case 'thunderstorm':
        return Icons.flash_on_rounded;

      default:
        return Icons.cloud_queue_rounded;
    }
  }

  static List<Color> gradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return [const Color(0xFFFFA726), const Color(0xFFFF7043)];

      case 'partly cloudy':
        return [const Color(0xFF90CAF9), const Color(0xFF42A5F5)];

      case 'cloudy':
      case 'overcast':
        return [const Color(0xFFB0BEC5), const Color(0xFF78909C)];

      case 'light rain':
      case 'moderate rain':
      case 'heavy rain':
        return [const Color(0xFF5C6BC0), const Color(0xFF3949AB)];

      case 'thunderstorm':
        return [const Color(0xFF7E57C2), const Color(0xFF512DA8)];

      default:
        return [const Color(0xFF42A5F5), const Color(0xFF1E88E5)];
    }
  }
}

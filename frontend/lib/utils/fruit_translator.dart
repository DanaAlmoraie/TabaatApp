import '../l10n/app_localizations.dart';

class FruitTranslator {
  static String translate(String fruit, AppLocalizations tr) {
    switch (fruit.toLowerCase()) {
      case 'apple':
        return tr.apple;
      case 'banana':
        return tr.banana;
      case 'orange':
        return tr.orange;
      case 'kiwi':
        return tr.kiwi;
      case 'grapes':
        return tr.grapes;
      case 'strawberry':
        return tr.strawberry;
      case 'lemon':
        return tr.lemon;
      case 'majdool dates':
        return tr.majdoolDates;
      case 'asil dates':
        return tr.asilDates;
      case 'sukary dates':
        return tr.sukaryDates;
      default:
        return fruit;
    }
  }
}

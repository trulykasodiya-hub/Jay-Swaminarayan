import 'package:swaminarayancounter/main.dart';

class UserPreferences {
  Future<bool> saveMantraJap(mantraJap) async {
    prefs.setString(mantraJapKey, mantraJap);
    return true;
  }

  void remove() async {
    prefs.remove(mantraJapKey);
  }
}

// list of key
const mantraJapKey = "mantraJap";

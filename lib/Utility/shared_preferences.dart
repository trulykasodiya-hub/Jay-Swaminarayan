import 'package:swaminarayancounter/main.dart';

class UserPreferences {
  Future<bool> saveMantraJap(mantraJap) async {
    prefs.setString(mantraJapKey, mantraJap);
    return true;
  }

  Future<bool> saveSwaminarayanLastId(swaminarayanLastId) async {
    prefs.setString(swaminarayanLastIdKey, swaminarayanLastId);
    return true;
  }

  Future<bool> saveHanumanStatusLastId(hanumanStatusLastId) async {
    prefs.setString(hanumanStatusLastIdKey, hanumanStatusLastId);
    return true;
  }

  Future<bool> saveMahadevStatusLastId(mahadevStatusLastId) async {
    prefs.setString(mahadevStatusLastIdKey, mahadevStatusLastId);
    return true;
  }

  Future<bool> saveRadhaKrishnaStatusLastId(radhaKrishnaStatusLastId) async {
    prefs.setString(radhaKrishnaStatusLastIdKey, radhaKrishnaStatusLastId);
    return true;
  }

  Future<bool> saveGanpatiStatusLastId(ganpatiStatusLastId) async {
    prefs.setString(ganpatiStatusLastIdKey, ganpatiStatusLastId);
    return true;
  }

  void remove() async {
    prefs.remove(mantraJapKey);
    prefs.remove(swaminarayanLastIdKey);
    prefs.remove(hanumanStatusLastIdKey);
    prefs.remove(mahadevStatusLastIdKey);
    prefs.remove(radhaKrishnaStatusLastIdKey);
    prefs.remove(ganpatiStatusLastIdKey);
  }
}

// list of key
const mantraJapKey = "mantraJap";
const swaminarayanLastIdKey = "swaminarayanLastId";
const hanumanStatusLastIdKey = "hanumanStatusLastIdKey";
const mahadevStatusLastIdKey = "mahadevStatusLastIdKey";
const radhaKrishnaStatusLastIdKey = "radhaKrishnaStatusLastIdKey";
const ganpatiStatusLastIdKey = "ganpatiStatusLastIdKey";

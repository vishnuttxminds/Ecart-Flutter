import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCustom {
  String favorites = 'favorites';
  saveFavoritesLocal(String favoritesData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(favorites, favoritesData);
  }

  getFavoritesLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(favorites);
  }

}

import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCustom {
 static String showcaseFirst = 'showcase_first';

 static Future<void> saveShowcaseFirstLocal(bool showcaseData) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setBool(showcaseFirst, showcaseData);
 }

 static Future<bool> getShowcaseFirstLocal() async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.getBool(showcaseFirst) ?? false;
 }

}

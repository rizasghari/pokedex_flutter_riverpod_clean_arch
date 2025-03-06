import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  Future<bool?> saveList(String key, List<String> list) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(key, list);
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<List<String>?> getList(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? list = prefs.getStringList(key);
      return list;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

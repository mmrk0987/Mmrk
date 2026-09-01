import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip.dart';
import '../models/settings.dart';

class StorageService {
  static const _tripsKey = 'trips';
  static const _settingsKey = 'settings';
  static const _roleKey = 'role';

  // Trips
  static Future<List<Trip>> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_tripsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Trip.fromJson(e)).toList();
  }

  static Future<void> saveTrips(List<Trip> trips) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(trips.map((e) => e.toJson()).toList());
    await prefs.setString(_tripsKey, jsonString);
  }

  // Settings
  static Future<Settings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_settingsKey);
    if (jsonString == null) return Settings.defaultSettings();
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Settings.fromJson(json);
  }

  static Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);
  }

  // Role
  static Future<String> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey) ?? 'owner'; // default owner
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }
}

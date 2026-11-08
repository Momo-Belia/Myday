import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _username = '用户';
  String? _wallpaperPath;
  String? _avatarPath;

  String get username => _username;
  String? get wallpaperPath => _wallpaperPath;
  String? get avatarPath => _avatarPath;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '用户';
    _wallpaperPath = prefs.getString('wallpaperPath');
    _avatarPath = prefs.getString('avatarPath');
    notifyListeners();
  }

  Future<void> setUsername(String name) async {
    _username = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    notifyListeners();
  }

  Future<void> setWallpaper(String? path) async {
    _wallpaperPath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('wallpaperPath', path);
    } else {
      await prefs.remove('wallpaperPath');
    }
    notifyListeners();
  }

  Future<void> setAvatar(String? path) async {
    _avatarPath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('avatarPath', path);
    } else {
      await prefs.remove('avatarPath');
    }
    notifyListeners();
  }
}
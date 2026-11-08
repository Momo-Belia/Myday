import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/todo.dart';

class LocalStorage {
  static const String _fileName = 'todos.json';

  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _fileName);
  }

  static Future<List<Todo>> loadTodos() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final path = await _getFilePath();
    final file = File(path);
    final List<Map<String, dynamic>> jsonList = todos.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
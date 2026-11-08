import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../storage/local_storage.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  List<Todo> get dailyTodos =>
      _todos.where((t) => t.type == TodoType.daily).toList();

  List<Todo> get specialTodos =>
      _todos.where((t) => t.type == TodoType.special).toList();

  List<Todo> get activeTodos =>
      _todos.where((t) => !t.isCompleted).toList();

  List<Todo> get completedTodos =>
      _todos.where((t) => t.isCompleted).toList();

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    _todos = await LocalStorage.loadTodos();
    _resetDailyIfNeeded();
    notifyListeners();
  }

  void _resetDailyIfNeeded() {
    final today = DateTime.now();
    final hasOldDaily = _todos.any((t) => t.type == TodoType.daily && !_isSameDay(t.createdAt, today));
    if (hasOldDaily) {
      _todos = _todos.map((t) {
        if (t.type == TodoType.daily) {
          return t.copyWith(isCompleted: false);
        }
        return t;
      }).toList();
      LocalStorage.saveTodos(_todos);
      notifyListeners();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> addTodo(String title, TodoType type, {DateTime? dueDate}) async {
    final targetMinutes = Todo.parseDurationFromTitle(title);
    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      type: type,
      dueDate: type == TodoType.special ? dueDate : null,
      createdAt: DateTime.now(),
      targetMinutes: targetMinutes,
    );
    _todos.insert(0, todo);
    await LocalStorage.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final updated = todo.copyWith(isCompleted: !todo.isCompleted);
      _todos[index] = updated;

      if (updated.type == TodoType.special && updated.isCompleted) {
        _todos.removeWhere((t) => t.id == updated.id);
      }
      await LocalStorage.saveTodos(_todos);
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      await LocalStorage.saveTodos(_todos);
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await LocalStorage.saveTodos(_todos);
    notifyListeners();
  }

  Future<void> resetDailyTodos() async {
    _todos = _todos.map((t) {
      if (t.type == TodoType.daily) {
        return t.copyWith(isCompleted: false);
      }
      return t;
    }).toList();
    await LocalStorage.saveTodos(_todos);
    notifyListeners();
  }

  Todo? getTodoById(String id) {
    try {
      return _todos.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
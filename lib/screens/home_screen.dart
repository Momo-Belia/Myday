import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/todo_card.dart';
import '../theme.dart';
import 'focus_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final settings = context.watch<SettingsProvider>();

    return Container(
      decoration: BoxDecoration(
        image: settings.wallpaperPath != null
            ? DecorationImage(
                image: FileImage(
                  File(settings.wallpaperPath!),
                ),
                fit: BoxFit.cover,
              )
            : null,
        color: settings.wallpaperPath == null
            ? AppTheme.backgroundColor
            : null,
      ),
      child: settings.wallpaperPath != null
          ? Container(
              color: Colors.white.withOpacity(0.85),
              child: _buildContent(context, todoProvider),
            )
          : _buildContent(context, todoProvider),
    );
  }

  Widget _buildContent(BuildContext context, TodoProvider todoProvider) {
    final activeTodos = todoProvider.activeTodos;
    final completedTodos = todoProvider.completedTodos;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '今日待办',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (activeTodos.isEmpty && completedTodos.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '暂无待办事项',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '点击Me页面添加新代办',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (activeTodos.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 10),
                child: Text(
                  '进行中 (${activeTodos.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = activeTodos[index];
                  return TodoCard(
                    todo: todo,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              FocusScreen(todoId: todo.id),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: AppTheme.animationDuration,
                        ),
                      );
                    },
                    onToggleComplete: () {
                      todoProvider.toggleComplete(todo.id);
                    },
                    onDelete: () => todoProvider.deleteTodo(todo.id),
                  );
                },
                childCount: activeTodos.length,
              ),
            ),
          ),
        ],
        if (completedTodos.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 20),
                child: Text(
                  '已完成 (${completedTodos.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = completedTodos[index];
                  return TodoCard(
                    todo: todo,
                    onTap: () {},
                    onToggleComplete: () {
                      todoProvider.toggleComplete(todo.id);
                    },
                    onDelete: () => todoProvider.deleteTodo(todo.id),
                  );
                },
                childCount: completedTodos.length,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '早上好';
    if (hour < 18) return '下午好';
    return '晚上好';
  }
}
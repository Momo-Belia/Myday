import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import '../theme.dart';

class FocusScreen extends StatefulWidget {
  final String todoId;

  const FocusScreen({super.key, required this.todoId});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _progressController.repeat();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
    _progressController.stop();
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final todo = todoProvider.getTodoById(widget.todoId);

    if (todo == null) {
      return const Scaffold(
        body: Center(child: Text('代办不存在')),
      );
    }

    final targetSeconds = todo.targetMinutes != null ? todo.targetMinutes! * 60 : null;
    final progress = targetSeconds != null
        ? (_elapsedSeconds / targetSeconds).clamp(0.0, 1.0)
        : null;
    final isCompleted = targetSeconds != null && _elapsedSeconds >= targetSeconds;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
                  ),
                  const Spacer(),
                  Text(
                    todo.type == TodoType.daily ? '日常代办' : '特殊代办',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (todo.targetMinutes != null)
                    Text(
                      '目标: ${todo.targetMinutes} 分钟',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 60),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: progress != null
                            ? AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 12,
                                    backgroundColor: AppTheme.dividerColor,
                                    valueColor: AlwaysStoppedAnimation(
                                      isCompleted
                                          ? AppTheme.successColor
                                          : AppTheme.primaryColor,
                                    ),
                                  );
                                },
                              )
                            : CircularProgressIndicator(
                                value: 0,
                                strokeWidth: 12,
                                backgroundColor: AppTheme.dividerColor,
                                valueColor: const AlwaysStoppedAnimation(
                                  AppTheme.primaryColor,
                                ),
                              ),
                      ),
                      Column(
                        children: [
                          Text(
                            _formatTime(_elapsedSeconds),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimary,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          if (isCompleted)
                            const Text(
                              '目标达成!',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      if (_isRunning) {
                        _stopTimer();
                        if (isCompleted || progress == null) {
                          todoProvider.toggleComplete(todo.id);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) Navigator.pop(context);
                          });
                        }
                      } else {
                        _startTimer();
                      }
                    },
                    child: AnimatedContainer(
                      duration: AppTheme.quickAnimation,
                      width: 160,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _isRunning
                            ? (isCompleted || progress == null
                                ? AppTheme.successColor
                                : Colors.red)
                            : AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: (_isRunning
                                    ? (isCompleted || progress == null
                                        ? AppTheme.successColor
                                        : Colors.red)
                                    : AppTheme.primaryColor)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isRunning
                              ? (isCompleted || progress == null ? '完成' : '结束')
                              : '开始',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
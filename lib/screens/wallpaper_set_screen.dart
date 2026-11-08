import 'dart:io';
import 'package:flutter/material.dart';
import '../theme.dart';

class WallpaperSetScreen extends StatefulWidget {
  final String imagePath;

  const WallpaperSetScreen({super.key, required this.imagePath});

  @override
  State<WallpaperSetScreen> createState() => _WallpaperSetScreenState();
}

class _WallpaperSetScreenState extends State<WallpaperSetScreen> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '设置壁纸',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, {'path': widget.imagePath, 'opacity': _opacity});
                    },
                    child: const Text(
                      '完成',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                        Opacity(
                          opacity: _opacity,
                          child: Image.file(
                            File(widget.imagePath),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text(
                    '壁纸透明度',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.opacity,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                      Expanded(
                        child: Slider(
                          value: _opacity,
                          min: 0.1,
                          max: 1.0,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _opacity = value;
                            });
                          },
                        ),
                      ),
                      const Icon(
                        Icons.opacity,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    '${(_opacity * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
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
flutter pub get# MyDay App 规格文档

## 1. 项目概述

- **项目名称**: MyDay
- **类型**: Android每日代办应用
- **核心功能**: 仿iOS风格的日常/特殊代办管理，支持专注模式和智能时间识别

## 2. 技术栈

- **框架**: Flutter 3.41.9
- **语言**: Dart 3.11.5
- **本地存储**: shared_preferences + sqflite
- **状态管理**: Provider
- **最低SDK**: Android API 21

## 3. UI/UX 规格

### 3.1 整体风格
- 仿iOS设计语言
- 大圆角卡片 (border-radius: 20-24px)
- 丝滑过渡动画 (300ms ease-in-out)
- 毛玻璃效果

### 3.2 颜色方案
- **主色**: #007AFF (iOS蓝)
- **背景**: #F2F2F7 (iOS浅灰)
- **卡片**: #FFFFFF
- **成功**: #34C759 (iOS绿)
- **文字**: #000000 (主), #8E8E93 (次)

### 3.3 导航结构
- 底部Tab导航: Home | Me
- Home: 显示代办列表
- Me: 头像、设置、添加代办入口

### 3.4 Home页面
- 每条代办右侧有圆形按钮
- 点击变为绿色✅表示完成
- 点击卡片进入专注模式

### 3.5 Me页面
- 方形头像 (80x80, 圆角12px)
- 用户名显示在头像右侧
- 头像下设置入口 (带图标)
- 设置下方➕按钮添加代办

### 3.6 代办类型
- **日常代办**: 每天自动刷新
- **特殊代办**: 可选日期，完成后永久消除

## 4. 功能规格

### 4.1 代办管理
- 添加/编辑/删除代办
- 日常/特殊类型切换
- 日期选择 (特殊代办)
- 完成状态切换

### 4.2 专注模式
- 点击代办卡片进入
- Start/Stop按钮控制
- 计时器显示
- 智能识别时间 (如"学习英语3小时"识别3小时)
- 超过预设时间自动标记完成

### 4.3 设置功能
- 壁纸设置 (用户上传图片)
- 用户名设置

## 5. 动画规格

- 页面切换: 300ms fade + slide
- 卡片状态变化: 200ms scale + opacity
- Tab切换: smooth transition
- 专注模式: circular progress animation

## 6. 数据模型

### Todo
```
- id: String (UUID)
- title: String
- type: enum (daily, special)
- dueDate: DateTime? (特殊代办)
- isCompleted: bool
- createdAt: DateTime
- targetDuration: int? (分钟)
```

### Settings
```
- username: String
- wallpaperPath: String?
```

## 7. 本地存储

- SQLite: 代办数据
- SharedPreferences: 用户设置、壁纸路径
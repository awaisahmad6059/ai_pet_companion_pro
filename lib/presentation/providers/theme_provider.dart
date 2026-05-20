import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/theme/app_theme.dart';
import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final LocalDataSource _dataSource;

  ThemeNotifier(this._dataSource)
      : super(_dataSource.loadThemeMode() ? ThemeMode.dark : ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _dataSource.saveThemeMode(state == ThemeMode.dark);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _dataSource.saveThemeMode(mode == ThemeMode.dark);
  }

  ThemeData get currentTheme =>
      state == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return ThemeNotifier(dataSource);
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

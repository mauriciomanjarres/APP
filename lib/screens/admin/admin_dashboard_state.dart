import 'package:flutter/material.dart';

typedef ReloadStatsCallback = Future<void> Function();

class AdminDashboardState extends ChangeNotifier {
  static final AdminDashboardState _instance = AdminDashboardState._internal();
  
  ReloadStatsCallback? _reloadStatsCallback;

  factory AdminDashboardState() => _instance;

  AdminDashboardState._internal();

  void setReloadStatsCallback(ReloadStatsCallback callback) {
    _reloadStatsCallback = callback;
  }

  Future<void> reloadStats() async {
    if (_reloadStatsCallback != null) {
      await _reloadStatsCallback!();
    }
  }
}
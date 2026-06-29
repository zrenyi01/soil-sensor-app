import 'package:flutter/material.dart';

class SensorDataModel extends ChangeNotifier {
  List<SensorReading> _readings = [];
  bool _isConnected = false;
  String _deviceName = '未连接';

  List<SensorReading> get readings => _readings;
  bool get isConnected => _isConnected;
  String get deviceName => _deviceName;

  // 模拟数据（实际使用时替换为蓝牙数据）
  void addReading(Map<String, double> data) {
    _readings.add(SensorReading(
      timestamp: DateTime.now(),
      moisture: data['moisture'] ?? 0.0,
      temperature: data['temperature'] ?? 0.0,
      ph: data['ph'] ?? 0.0,
      conductivity: data['conductivity'] ?? 0.0,
    ));
    
    // 保留最近100条数据
    if (_readings.length > 100) {
      _readings.removeAt(0);
    }
    notifyListeners();
  }

  void connectDevice(String name) {
    _deviceName = name;
    _isConnected = true;
    notifyListeners();
  }

  void disconnectDevice() {
    _isConnected = false;
    _deviceName = '未连接';
    notifyListeners();
  }
}

class SensorReading {
  final DateTime timestamp;
  final double moisture;
  final double temperature;
  final double ph;
  final double conductivity;

  SensorReading({
    required this.timestamp,
    required this.moisture,
    required this.temperature,
    required this.ph,
    required this.conductivity,
  });
}
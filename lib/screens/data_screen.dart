import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sensor_data.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SensorDataModel>(context);
    
    return Scaffold(
      body: model.readings.isEmpty
          ? const Center(child: Text('暂无数据'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: model.readings.length,
              itemBuilder: (context, index) {
                final reading = model.readings.reversed.toList()[index];
                return Card(
                  child: ListTile(
                    title: Text('时间: ${_formatTime(reading.timestamp)}'),
                    subtitle: Text(
                      '湿度: ${reading.moisture.toStringAsFixed(1)}% | '
                      '温度: ${reading.temperature.toStringAsFixed(1)}°C | '
                      'pH: ${reading.ph.toStringAsFixed(1)}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showDetailDialog(context, reading);
                    },
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  void _showDetailDialog(BuildContext context, SensorReading reading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('详细数据'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('时间: ${_formatTime(reading.timestamp)}'),
            const SizedBox(height: 8),
            Text('土壤湿度: ${reading.moisture.toStringAsFixed(1)}%'),
            Text('温度: ${reading.temperature.toStringAsFixed(1)}°C'),
            Text('pH值: ${reading.ph.toStringAsFixed(1)}'),
            Text('电导率: ${reading.conductivity.toStringAsFixed(2)} mS/cm'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
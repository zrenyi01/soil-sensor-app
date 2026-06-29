import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_data.dart';
import '../widgets/sensor_card.dart';
import '../widgets/chart_widget.dart';
import 'data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('土壤传感器监测'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: _showDeviceList,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '仪表盘',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '数据',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardView();
      case 1:
        return const DataScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _showDeviceList() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('蓝牙设备', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.bluetooth_connected),
              title: const Text('ESP32 Sensor'),
              onTap: () {
                Provider.of<SensorDataModel>(context, listen: false).connectDevice('ESP32 Sensor');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已连接 ESP32 Sensor')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text('Arduino Sensor'),
              onTap: () {
                Provider.of<SensorDataModel>(context, listen: false).connectDevice('Arduino Sensor');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已连接 Arduino Sensor')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _refreshData() {
    final model = Provider.of<SensorDataModel>(context, listen: false);
    // 模拟数据更新
    model.addReading({
      'moisture': 45.0 + (DateTime.now().millisecond % 20).toDouble(),
      'temperature': 22.0 + (DateTime.now().millisecond % 10).toDouble(),
      'ph': 6.5 + (DateTime.now().millisecond % 5) / 10,
      'conductivity': 1.2 + (DateTime.now().millisecond % 8) / 10,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据已刷新')),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SensorDataModel>(context);
    final latest = model.readings.isNotEmpty ? model.readings.last : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 连接状态
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    model.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: model.isConnected ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    model.isConnected ? '已连接: ${model.deviceName}' : '未连接设备',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 传感器数据卡片
          if (latest != null) ...[
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: '土壤湿度',
                    value: '${latest.moisture.toStringAsFixed(1)}%',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SensorCard(
                    title: '温度',
                    value: '${latest.temperature.toStringAsFixed(1)}°C',
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'pH值',
                    value: latest.ph.toStringAsFixed(1),
                    icon: Icons.science,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SensorCard(
                    title: '电导率',
                    value: '${latest.conductivity.toStringAsFixed(2)} mS/cm',
                    icon: Icons.flash_on,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('暂无数据，请刷新或连接设备'),
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          const Text('土壤湿度趋势', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ChartWidget(data: model.readings.map((r) => r.moisture).toList()),
          ),
        ],
      ),
    );
  }
}
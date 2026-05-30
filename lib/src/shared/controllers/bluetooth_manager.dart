import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

class BluetoothManager extends ChangeNotifier {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

  bool _isConnected = false;
  String? _connectedAddress;
  String? _connectedName;

  bool get isConnected => _isConnected;
  String? get connectedAddress => _connectedAddress;
  String? get connectedName => _connectedName;

  Future<bool> connect(String address, {String? name}) async {
    try {
      bool success = await _bluetooth.connect(address);
      if (success) {
        _isConnected = true;
        _connectedAddress = address;
        _connectedName = name;
        notifyListeners();
      }
      return success;
    } catch (e) {
      debugPrint('BluetoothManager.connect error: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _bluetooth.disconnect();
      debugPrint('BluetoothManager: Successfully disconnected');
    } catch (e) {
      debugPrint('BluetoothManager.disconnect error: $e');
    }
    _isConnected = false;
    _connectedAddress = null;
    _connectedName = null;
    notifyListeners();
  }
  Future<void> send(String data) async {
    if (!_isConnected) {
      debugPrint('BluetoothManager.send(): not connected, unsending copmmand: $data');
      return;
    }
    try {
      await _bluetooth.sendString(data);
      debugPrint('BluetoothManager.send(): Sent "$data"');
    } catch (e) {
      debugPrint('BluetoothManager.send error: $e');
      _isConnected = false;
      notifyListeners();
    }
  }
}
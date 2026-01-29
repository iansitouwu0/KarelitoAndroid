import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothScanner {
  static final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  static Future<List<BluetoothDevice>> getBondedDevices() async {
    return await _bluetooth.getBondedDevices();
  }

  static Future<BluetoothConnection> connectToDevice(String address) async {
    return await BluetoothConnection.toAddress(address);
  }

  static Future<bool?> isBluetoothEnabled() async {
    return await _bluetooth.isEnabled;
  }
}
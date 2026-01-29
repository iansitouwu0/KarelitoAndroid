
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothReceiver {
  // Escucha los datos entrantes y ejecuta un callback cuando recibe algo
  static void listenToData(BluetoothConnection? connection, Function(String) onDataReceived) {
    if (connection != null && connection.isConnected) {
      connection.input?.listen((data) {
        String message = String.fromCharCodes(data);
        onDataReceived(message);
      }).onDone(() {
        print("Conexión cerrada por el dispositivo remoto");
      });
    }
  }
}
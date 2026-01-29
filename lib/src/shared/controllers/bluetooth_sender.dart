import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothSender {
  // Envía una cadena de texto convertida a bytes (ASCII)
  static void sendData(BluetoothConnection? connection, String data) {
    if (connection != null && connection.isConnected) {
      connection.output.add(ascii.encode(data));
      connection.output.allSent; // Asegura que se envíe antes de continuar
    } else {
      print("No se pudo enviar: No hay conexión activa.");
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:karelito/src/shared/views/views.dart';
import 'package:permission_handler/permission_handler.dart';


import '../controllers/controllers.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const BluetoothScanPage(),
    );
  }
}

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _connectedDevice;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _requestPermissions() async {
    await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }


  void _handleConnect(BluetoothDevice device) async {
    setState(() => _isConnecting = true);
    try {
      _connection = await BluetoothScanner.connectToDevice(device.address);
      setState(() {
        _connectedDevice = device;
        _isConnecting = false;
        _devices = []; 
      });
/*
      BluetoothReceiver.listenToData(_connection, (data) {
        if (data.contains("p")) {
          setState(() => _counter++);
        }
      });
 */
    } catch (e) {
      print("Error de conexión: $e");
      setState(() => _isConnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AdaptativeScreen(
        backgroundImage:'home/homeBg.jpg',
        titleImage: 'configuracion/bluetoothScanner.png',
        height:height,
        children: 
          [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: 
                    BoxDecoration(
                      color: Color.fromARGB(232, 255, 248, 248)
                    ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent, 
                      width: 4.0, 
                    ),
                  ),
                  child:Column(
                    children: [
                      
                    ListTile(
                      title: Text("Conectado a: ${_connectedDevice?.name ?? 'Ninguno'}"),
                      trailing: IconButton(
                        icon:  ImageIcon(
                          AssetImage("../assets/configuracion/refresh.png"),
                          size: 24.0,
                        ),
                        onPressed: () async {
                        var list = await BluetoothScanner.getBondedDevices();
                        setState(() => _devices = list);
                        },
                      ),
                    ),

                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _isConnecting 
                        ? [const Center(child: CircularProgressIndicator())]
                        : [ListView.builder(
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            final dev = _devices[index];
                            return ListTile(
                              title: Text(dev.name ?? "Desconocido"),
                              subtitle: Text(dev.address),
                              onTap: () => _handleConnect(dev),
                            );
                          },
                        ),]
                      ),
                  
                    ],
                  )
                ),
              ],
            ),
          ],
          
    );    
    

  }
}
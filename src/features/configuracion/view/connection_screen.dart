  import 'package:flutter/material.dart';
  import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';
  import 'package:go_router/go_router.dart';
  import '../../../shared/controllers/controllers.dart';

  class ConnectionScreen extends StatefulWidget {
    const ConnectionScreen({super.key});

    @override
    State<ConnectionScreen> createState() => _ConnectionScreenState();
  }

  class _ConnectionScreenState extends State<ConnectionScreen> {
    final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

    bool _bluetoothState = false;
    List<BluetoothDevice> _devices = [];
    bool _isConnecting = false;
    String? _connectingAddress;
    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      _checkPermissions();
    }

    Future<void> _checkPermissions() async {
      setState(() => _isLoading = true);
      bool isEnabled = await _bluetooth.isBluetoothEnabled();
      List<BluetoothDevice> pairedDevices = await _bluetooth.getPairedDevices();
      setState(() {
        _bluetoothState = isEnabled;
        _devices = pairedDevices;
        _isLoading = false;
      });
    }

    Future<void> _connectToDevice(BluetoothDevice device) async {
      setState(() {
        _isConnecting = true;
        _connectingAddress = device.address;
      });

      bool success = await BluetoothManager().connect(device.address);

      setState(() {
        _isConnecting = false;
        _connectingAddress = null;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(success
                  ? 'Conectado a ${device.name ?? device.address}'
                  : 'Error al conectar'),
            ],
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final isConnected = BluetoothManager().isConnected;

      return Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16213E),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/settings'),
          ),
          title: const Text(
            'Conexión Bluetooth',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Actualizar',
              onPressed: _checkPermissions,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            : Column(
                children: [
                  // ── Estado Bluetooth + Conexión ──
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _bluetoothState
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.bluetooth,
                                color: _bluetoothState
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bluetooth',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _bluetoothState ? 'Activado' : 'Desactivado',
                                    style: TextStyle(
                                      color: _bluetoothState
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _bluetoothState,
                              activeThumbColor: Colors.blueAccent,
                              onChanged: (_) => _checkPermissions(),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isConnected
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isConnected ? Icons.link : Icons.link_off,
                                color:
                                    isConnected ? Colors.greenAccent : Colors.redAccent,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Estado de conexión',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  isConnected ? 'Dispositivo conectado' : 'Sin conexión',
                                  style: TextStyle(
                                    color: isConnected
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Lista de dispositivos ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          'Dispositivos vinculados',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_devices.length}',
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: _devices.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bluetooth_searching,
                                    size: 60, color: Colors.white24),
                                const SizedBox(height: 12),
                                const Text(
                                  'No hay dispositivos vinculados',
                                  style: TextStyle(color: Colors.white38),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                              final device = _devices[index];
                              final isThisConnecting =
                                  _connectingAddress == device.address;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16213E),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.bluetooth_audio,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  title: Text(
                                    device.name ?? 'Dispositivo desconocido',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    device.address,
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 12),
                                  ),
                                  trailing: SizedBox(
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isThisConnecting
                                            ? Colors.grey
                                            : Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ),
                                      onPressed: _isConnecting
                                          ? null
                                          : () => _connectToDevice(device),
                                      child: isThisConnecting
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text('Conectar'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      );
    }
  }
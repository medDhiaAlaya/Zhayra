import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'ESP32Car') {
          setState(() {
            device = r.device;
          });
          connectToDevice();
          flutterBlue.stopScan();
          break;
        }
      }
    });
  }

  void connectToDevice() async {
    if (device == null) return;
    await device!.connect();
    List<BluetoothService> services = await device!.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((charac) {
        if (charac.properties.write) {
          setState(() {
            characteristic = charac;
          });
        }
      });
    });
  }

  void sendCommand(String command) async {
    if (characteristic == null) return;
    await characteristic!.write(utf8.encode(command));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32 Car Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => sendCommand('F'),
                  child: Text('Forward'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sendCommand('B'),
                  child: Text('Backward'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => sendCommand('L'),
                  child: Text('Left'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sendCommand('R'),
                  child: Text('Right'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => sendCommand('S'),
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}

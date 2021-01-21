import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/state/provider_ble.dart';
import 'dart:convert' show LineSplitter, utf8;

import 'http_post.dart';

class BlueUtil {
  static final BlueUtil _blueUtil = new BlueUtil._internal();
  BlueUtil._internal();
  static BlueUtil get instance => _blueUtil;
  bool state = false;
  BluetoothDevice device;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothCharacteristic targetCharacteristic;
  List<BluetoothService> services;
  bool bluetoothConnectState = false;
  BuildContext context;
  void scan() {
    FlutterBlue.instance.startScan();
  }

  void connect() async {
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.device.name == "HMSoft") {
          device = r.device;
        }
      }
    });
  }

  void connectToDevice() async {
    if (device == null) {
      connect();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!bluetoothConnectState) {
        disconnectFromDevice();
      }
    });

    await device.connect();
    discoverService();
  }

  void disconnectFromDevice() {
    if (device == null) {
      connectToDevice();
    } else {
      device.disconnect();
      connectToDevice();
    }
  }

  discoverService() async {
    if (device == null) {
      connectToDevice();
      return;
    }

    services = await device.discoverServices();
    services.forEach((service) {
      // if (service.uuid.toString() == SERVICE_UUID) {
      service.characteristics.forEach((characteristic) {
        targetCharacteristic = characteristic;
        bluetoothConnectState = true;
        // if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
        characteristic.setNotifyValue(!characteristic.isNotifying);
        //  characteristic.setNotifyValue(true);
        characteristic.value.listen((value) {
          // print("value===$value");
          // _dataParser(value).replaceAll(new RegExp(r"\s+\b|\b\s"), "");
          print(
              "value===${_dataParser(value).replaceAll(new RegExp(r"\s+\b|\b\s"), "")}1   ${_dataParser(value).replaceAll(new RegExp(r"\s+\b|\b\s"), "") == "ok"}   ");
          // if (value.length > 0) {
            
            if (_dataParser(value).replaceAll(new RegExp(r"\s+\b|\b\s"), "") == "end" &&state) {
              state= false;
              Provider.of<BluetoothStatus>(context, listen: false)
                  .setBlueProgressValue(100);
              Provider.of<BluetoothStatus>(context, listen: false)
                  .setBlueProgressValueText(3);
              print("value===${_dataParser(value)}   ");
            }
          // }
        });
        bluetoothConnectState = true;
        // }
      });
      // }
    });

    if (!bluetoothConnectState) {
      connectToDevice();
    }
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  void writeBtn(String data) async {
    if (device == null) return;

    Provider.of<BluetoothStatus>(context, listen: false)
        .setBlueProgressValue(10);
    Provider.of<BluetoothStatus>(context, listen: false)
        .setBlueProgressValueText(1);

    //post http 得到gcode
    String gcode = await requestMethod(data);
    //String 每一行存成list
    LineSplitter ls = new LineSplitter();

    Provider.of<BluetoothStatus>(context, listen: false)
        .setBlueProgressValue(50);
    Provider.of<BluetoothStatus>(context, listen: false)
        .setBlueProgressValueText(2);
    //把gcode存起來
    var print_lines = ls.convert(gcode);
    //轉成bytes 藍芽傳過去
    // List<int> bytes = utf8.encode(print_lines[0]);
    //   await targetCharacteristic.write(bytes);

    state= true;
    for (var g in print_lines) {
      await Future.delayed(Duration(microseconds: 100));
      //  await Future.delayed(Duration(microseconds: 100));
      List<int> bytes = utf8.encode(g);
      targetCharacteristic.write(bytes);
      print("g===>$g");
    }
  }
}

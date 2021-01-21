import 'dart:async';
import 'dart:io';
import 'dart:convert' show LineSplitter, utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// import 'blue_status.dart';
import '../util/http_post.dart';

class BluetoothStatus extends ChangeNotifier {
  BluetoothDevice device;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothCharacteristic targetCharacteristic;
  List<BluetoothService> services;
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  Stream<List<int>> stream;
  List<String> print_lines = [];
  int startProgress = 0;
  int blueProgressValue = 0;
  int blueProgressValueText = 0;
  double progressValue = 0;

  bool getValueState = false;

  bool bluetoothWriteState = false;
  bool bluetoothConnectState = false;
  //寫入狀態
  bool get getBluetoothWriteState => bluetoothWriteState;
  int get getBlueProgressValue => blueProgressValue;
  int get getBlueProgressValueText => blueProgressValueText;
  BluetoothDevice get getDevice => device;

  void setBlueProgressValue(int value) {
    blueProgressValue = value;
    notifyListeners();
  }

  void setBlueProgressValueText(int value) {
    blueProgressValueText = value;
    notifyListeners();
  }

  void setBluetoothWriteState(bool state) {
    bluetoothWriteState = state;
    notifyListeners();
  }
  //須找到連線成功 跟斷線的地方判斷 讓他重連

  // void scan() {
  //   FlutterBlue.instance.startScan();
  // }

  // void connect() async {
  //   var subscription = flutterBlue.scanResults.listen((results) {
  //     // do something with scan results
  //     for (ScanResult r in results) {
  //       if (r.device.name == "HMSoft") {
  //         device = r.device;
  //         notifyListeners();
  //       }
  //     }
  //   });
  // }

  // void connectToDevice() async {
  //   if (device == null) {
  //     connect();
  //     return;
  //   }

  //   new Timer(const Duration(seconds: 15), () {
  //     if (!bluetoothConnectState) {
  //       disconnectFromDevice();
  //     }
  //   });

  //   await device.connect();
  //   discoverService();
  // }

  // void disconnectFromDevice() {
  //   if (device == null) {
  //     connectToDevice();
  //   } else {
  //     device.disconnect();
  //     connectToDevice();
  //   }
  // }

  // discoverService() async {
  //   if (device == null) {
  //     connectToDevice();
  //     return;
  //   }

  //   services = await device.discoverServices();
  //   services.forEach((service) {
  //     // if (service.uuid.toString() == SERVICE_UUID) {
  //     service.characteristics.forEach((characteristic) {
  //       targetCharacteristic = characteristic;
  //       bluetoothConnectState = true;
  //       // if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
  //       characteristic.setNotifyValue(!characteristic.isNotifying);
  //       //  characteristic.setNotifyValue(true);
  //       characteristic.value.listen((value) {
  //         // print("value===$value");
         
  //       if(getValueState){
  //         if (_dataParser(value) == "OK") {
  //            print(
  //             "value===${_dataParser(value)}  length==${print_lines.length} ");
  //           setBlueProgressValue(100);
  //           setBlueProgressValueText(3);
  //           getValueState ==false;
  //         }
          
  //       }
          

  //         // print("len==${print_lines.length}");
  //         // if (_dataParser(value) == "OK") {
  //         //   if (print_lines.length > 0) {
  //         //     index++;
  //         //     print("index===$index");

  //         //     // //最大行數/9
  //         //     if (print_lines[0] == "end") {
  //         //       setBlueProgressValue(100);
  //         //       setBlueProgressValueText(3);
  //         //       bluetoothWriteState = false;
  //         //       notifyListeners();
  //         //     } else {
  //         //       List<int> bytes = utf8.encode(print_lines[0]);
  //         //       targetCharacteristic.write(bytes);
  //         //     }
  //         //     // //把傳過去的資料 list 裡面刪除
  //         //     print_lines.removeAt(0);
  //         //   }
  //         // }
  //         // Timer(Duration(seconds: 1), () {
  //         //   print("open");
  //         //   getValueState = true;
  //         // });
  //         //轉成bytes 藍芽傳過去

  //         // if(print_lines.length==0){
  //         //   setBlueProgressValue(10);
  //         // }
  //       });
  //       // }
  //     });
  //     // }
  //   });

  //   if (!bluetoothConnectState) {
  //     connectToDevice();
  //   }
  // }

  // String _dataParser(List<int> dataFromDevice) {
  //   return utf8.decode(dataFromDevice);
  // }

  // void writeBtn(String data) async {
  //   bluetoothWriteState = true;
  //   notifyListeners();
  //   getValueState = true;

  //   if (device == null) return;
  //   setBlueProgressValue(10);
  //   setBlueProgressValueText(1);
  //   //post http 得到gcode
  //   String gcode = await requestMethod(data);
  //   LineSplitter ls = new LineSplitter();
  //   setBlueProgressValue(50);
  //   setBlueProgressValueText(2);
  //   //把gcode存起來
  //   print_lines = ls.convert(gcode);
  //   // print("gcode==$gcode");
  //   //轉成bytes 藍芽傳過去
  //   // List<int> bytes = utf8.encode(print_lines[0]);
  //   //   await targetCharacteristic.write(bytes);
  //   for (var g in print_lines) {
  //     List<int> bytes = utf8.encode(g);
  //     await targetCharacteristic.write(bytes);
  //     print("g===>$g");
  //   }

  //   //把傳過去的資料 list 裡面刪除
  //   // print_lines.removeAt(0);

  //   //唯一的狀態
  //   // var bleState = BlueStatus.instance;
  //   // bleState.write = true;
  // }
}

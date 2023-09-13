// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors, unnecessary_this

import 'dart:async';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  bool connected = false;
  List availableBluetoothDevices = [];
  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });
  }
  Future<void> setConnect(String mac) async {
    print('string ' + mac.toString());
    final String? result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");
    if (result == "true") {
      setState(() {
        connected = true;
      });
    }
  }
  Future<void> printReceipt() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getReceipt();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }
  Future<void> printGraphics() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print("hello " + isConnected.toString());
    if (isConnected == "true") {
      List<int> bytes = await getGraphicsTicket();
      var result = await BluetoothThermalPrinter.writeBytes(bytes);
      result = await BluetoothThermalPrinter.writeText("Bienvenu a Gyu-Kaku Montreal\n"
          "(514) 866-8808"
          "\n1255 Rue Crescent"
          "\nMontreal, QC H3G 2B1");
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }
  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    // Print QR Code using native function
    bytes += generator.qrcode('example.com');
    bytes += generator.hr();
    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> getReceipt() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.text("",styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    bytes += generator.text("Zoeya PPOB",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: true
      ),
    );
    bytes += generator.text(
      "Jl. Kapten Kasihin Gg.II No.11C\nKenayan - Tulungagung",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: true
      ),
    );

    bytes += generator.row([
      PosColumn(
        text: "================================",
        width: 12,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "13-09-2023 10:45:34",
        width: 12,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'No. Transaksi',
        width: 4,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "268207947",
        width: 7,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Status',
        width: 4,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "Success",
        width: 7,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'ID. Pel',
        width: 4,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "50220615921",
        width: 7,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Voucher ',
        width: 4,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: "hpln50000",
        width: 7,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Token',
        width: 12,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "4193-4391-4466-4814-2862|Sutrisno|R1M 900|34",
        width: 12,
        styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    
    bytes += generator.row([
      PosColumn(
        text: "================================",
        width: 12,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )
      ),
    ]);
    
    bytes += generator.text('Terima Kasih!',styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('Telah melakukan pembayaran',styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.text('di outlet kami.',styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cetak Struk'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Search Paired Bluetooth"),
              TextButton(
                onPressed: () {
                  this.getBluetooth();
                },
                child: Text("Search"),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: availableBluetoothDevices.isNotEmpty
                      ? availableBluetoothDevices.length
                      : 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        String select = availableBluetoothDevices[index];
                        List list = select.split("#");
                        // String name = list[0];
                        String mac = list[1];
                        this.setConnect(mac);
                      },
                      title: Text('${availableBluetoothDevices[index]}'),
                      subtitle: connected ? Text("Connected", style: TextStyle(color: Colors.green)) : Text("Click to connect", style: TextStyle(color: Colors.red)),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: connected ? this.printGraphics : null ,
                child: Text("Print"),
              ),
              TextButton(
                onPressed: connected ? this.printReceipt : null,
                child: Text("Print Receipt"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
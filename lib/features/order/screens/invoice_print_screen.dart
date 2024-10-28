import 'dart:async';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as i;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sixam_mart_store/features/order/widgets/invoice_dialog_widget.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class InVoicePrintScreen extends StatefulWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  final bool? isPrescriptionOrder;
  final double dmTips;
  const InVoicePrintScreen({super.key, required this.order, required this.orderDetails, this.isPrescriptionOrder = false, required this.dmTips});

  @override
  State<InVoicePrintScreen> createState() => _InVoicePrintScreenState();
}

class _InVoicePrintScreenState extends State<InVoicePrintScreen> {
  List<BluetoothInfo> _devices = [];

  bool _paper80MM = true;
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  BluetoothInfo? _selectedPrinter;
  bool _searchingMode = true;

  @override
  void initState() {
    super.initState();

    _scan();
  }

  @override
  void dispose() {
    _portController.dispose();
    _ipController.dispose();

    super.dispose();
  }

  /// method to scan devices according PrinterType
  void _scan() async {
    Permission.bluetooth.request();
    Permission.bluetoothScan.request();
    Permission.bluetoothConnect.request();
    _devices = [];
    _devices = await PrintBluetoothThermal.pairedBluetooths;
    print('-----=========>${_devices.length}');
    setState(() {});
  }

  void _selectDevice(BluetoothInfo device) async {
    if(_selectedPrinter != null) {
      await PrintBluetoothThermal.disconnect;
    }

    _selectedPrinter = device;
    await PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress);
    setState(() {});
  }

  Future<void> _printReceipt(i.Image image) async {
    i.Image resized = i.copyResize(image, width: _paper80MM ? 500 : 365);
    CapabilityProfile profile = await CapabilityProfile.load();
    Generator generator = Generator(_paper80MM ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += generator.image(resized);
    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    bool conecctionStatus = await PrintBluetoothThermal.connectionStatus;
    if(conecctionStatus) {
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      print("print result: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _searchingMode ? SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.fontSizeLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text('paper_size'.tr, style: robotoMedium),
          Row(children: [
            Expanded(child: RadioListTile(
              title: Text('80_mm'.tr),
              groupValue: _paper80MM,
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (bool? value) {
                _paper80MM = true;
                setState(() {});
              },
            )),
            Expanded(child: RadioListTile(
              title: Text('58_mm'.tr),
              groupValue: _paper80MM,
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: false,
              onChanged: (bool? value) {
                _paper80MM = false;
                setState(() {});
              },
            )),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            itemCount: _devices.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () {
                    _selectDevice(_devices[index]);
                    setState(() {
                      _searchingMode = false;
                    });
                  },
                  child: Stack(children: [

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(_devices[index].name),

                      Visibility(
                        visible: !Platform.isWindows,
                        child: Text(_devices[index].macAdress),
                      ),

                      index != _devices.length-1 ? Divider(color: Theme.of(context).disabledColor) : const SizedBox(),

                    ]),

                    (_selectedPrinter != null && _selectedPrinter!.macAdress == _devices[index].macAdress) ? const Positioned(
                      top: 5, right: 5,
                      child: Icon(Icons.check, color: Colors.green),
                    ) : const SizedBox(),

                  ]),
                ),
              );
            },
          ),
        ],
      ),
    ) : InvoiceDialog(
      order: widget.order, orderDetails: widget.orderDetails, isPrescriptionOrder: widget.isPrescriptionOrder,
      onPrint: (i.Image? image) => _printReceipt(image!), paper80MM: _paper80MM, dmTips: widget.dmTips,
    );
  }
}
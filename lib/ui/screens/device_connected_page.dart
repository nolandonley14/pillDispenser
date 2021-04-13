import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:senior_design_pd/ui/widgets/bluetoothWidgets.dart';
import 'package:senior_design_pd/ui/widgets/busy_button.dart';
import 'package:senior_design_pd/ui/shared/ui_helpers.dart';
import 'package:senior_design_pd/viewmodels/device_connected_view_model.dart';
import 'package:stacked/stacked.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {

  bool isOn = false;

  List<int> _toggleLight() {
    if (isOn) 
      return [0, 0, 0, 0];
    else
      return [1, 0, 0, 0];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_toggleLight(), withoutResponse: true);
                      isOn = !isOn;
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () {
                              print("Here");
                              d.write(_toggleLight());
                              isOn = !isOn;
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeviceConnectedViewModel>.reactive(
      viewModelBuilder: () => DeviceConnectedViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                                StreamBuilder<BluetoothDeviceState>(
                stream: widget.device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) {
                    return
                      Column(
                      children:  <Widget>[
                        Text('${widget.device.name} is ${snapshot.data.toString().split('.')[1]}.'),
                        verticalSpaceMedium,
                      ]
                    ); 
                }
              ),
                StreamBuilder<BluetoothDeviceState>(
                  stream: widget.device.state,
                  initialData: BluetoothDeviceState.connecting,
                  builder: (c, snapshot) {
                    VoidCallback onPressed;
                    String text;
                    switch (snapshot.data) {
                      case BluetoothDeviceState.connected:
                        onPressed = () => widget.device.disconnect();
                        text = 'Disconnect';
                        break;
                      case BluetoothDeviceState.disconnected:
                        onPressed = () => widget.device.connect();
                        text = 'Connect';
                        break;
                      default:
                        onPressed = null;
                        text = snapshot.data.toString().substring(21).toUpperCase();
                        break;
                    }
                    return Column(
                      children:  <Widget>[
                        BusyButton(
                          title: text,
                          onPressed: onPressed),
                        verticalSpaceSmall,
                        BusyButton(
                          title: "Save",
                          onPressed: () {
                            model.saveDevice(widget.device);
                            //model.navigateToHome();
                            widget.device.discoverServices();
                          }
                        )
                      ]
                    ); 
                  },
                ),
              StreamBuilder<List<BluetoothService>>(
                stream: widget.device.services,
                initialData: [],
                builder: (c, snapshot) {
                  return Column(
                    children: _buildServiceTiles(snapshot.data),
                  );
                },
              ),
              ],
            ),
          ),
      ),
    );
  }
}
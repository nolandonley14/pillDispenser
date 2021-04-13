import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:senior_design_pd/ui/widgets/bluetoothWidgets.dart';
import 'package:senior_design_pd/ui/screens/device_connected_page.dart';
import 'dart:math';

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {

  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Find Devices',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        onRefresh: () => flutterBlue.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                backgroundColor: Colors.green,
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

// class DeviceScreen extends StatefulWidget {
//   const DeviceScreen({Key key, this.device}) : super(key: key);

//   final BluetoothDevice device;

//   @override
//   _DeviceScreenState createState() => _DeviceScreenState();
// }

// class _DeviceScreenState extends State<DeviceScreen> {
//   bool isOn = false;

//   List<int> _toggleLight() {
//     if (isOn) 
//       return [0, 0, 0, 0];
//     else
//       return [1, 0, 0, 0];
//   }

//   List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//     return services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map(
//                   (c) => CharacteristicTile(
//                     characteristic: c,
//                     onReadPressed: () => c.read(),
//                     onWritePressed: () async {
//                       await c.write(_toggleLight(), withoutResponse: true);
//                       isOn = !isOn;
//                       await c.read();
//                     },
//                     onNotificationPressed: () async {
//                       await c.setNotifyValue(!c.isNotifying);
//                       await c.read();
//                     },
//                     descriptorTiles: c.descriptors
//                         .map(
//                           (d) => DescriptorTile(
//                             descriptor: d,
//                             onReadPressed: () => d.read(),
//                             onWritePressed: () {
//                               print("Here");
//                               d.write(_toggleLight());
//                               isOn = !isOn;
//                             },
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name),
//         actions: <Widget>[
//           StreamBuilder<BluetoothDeviceState>(
//             stream: widget.device.state,
//             initialData: BluetoothDeviceState.connecting,
//             builder: (c, snapshot) {
//               VoidCallback onPressed;
//               String text;
//               switch (snapshot.data) {
//                 case BluetoothDeviceState.connected:
//                   onPressed = () => widget.device.disconnect();
//                   text = 'DISCONNECT';
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   onPressed = () => widget.device.connect();
//                   text = 'CONNECT';
//                   break;
//                 default:
//                   onPressed = null;
//                   text = snapshot.data.toString().substring(21).toUpperCase();
//                   break;
//               }
//               return FlatButton(
//                   onPressed: onPressed,
//                   child: Text(
//                     text,
//                     style: Theme.of(context)
//                         .primaryTextTheme
//                         .button
//                         .copyWith(color: Colors.white),
//                   ));
//             },
//           )
//         ],
//       ),
//       body: Column(
//           children: <Widget>[
//             StreamBuilder<BluetoothDeviceState>(
//               stream: widget.device.state,
//               initialData: BluetoothDeviceState.connecting,
//               builder: (c, snapshot) => ListTile(
//                 leading: (snapshot.data == BluetoothDeviceState.connected)
//                     ? Icon(Icons.bluetooth_connected)
//                     : Icon(Icons.bluetooth_disabled),
//                 title: Text(
//                     'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                 subtitle: Text('${widget.device.id}'),
//                 trailing: StreamBuilder<bool>(
//                   stream: widget.device.isDiscoveringServices,
//                   initialData: false,
//                   builder: (c, snapshot) => IndexedStack(
//                     index: snapshot.data ? 1 : 0,
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.refresh),
//                         onPressed: () => widget.device.discoverServices(),
//                       ),
//                       IconButton(
//                         icon: SizedBox(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.grey),
//                           ),
//                           width: 18.0,
//                           height: 18.0,
//                         ),
//                         onPressed: null,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             StreamBuilder<int>(
//               stream: widget.device.mtu,
//               initialData: 0,
//               builder: (c, snapshot) => ListTile(
//                 title: Text('MTU Size'),
//                 subtitle: Text('${snapshot.data} bytes'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () => widget.device.requestMtu(223),
//                 ),
//               ),
//             ),
//             StreamBuilder<List<BluetoothService>>(
//               stream: widget.device.services,
//               initialData: [],
//               builder: (c, snapshot) {
//                 return Column(
//                   children: _buildServiceTiles(snapshot.data),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/models/user.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/firestore_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'package:senior_design_pd/ui/widgets/bluetoothWidgets.dart';

import 'base_model.dart';
class DeviceConnectedViewModel extends BaseModel {

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future saveDevice(BluetoothDevice d) async {
    UserDevice device = UserDevice(name: d.name, id: d.id.id, service: null);
    await _firestoreService.saveDevice(device, _authService.currentUser);
  }

    void navigateToHome() {
    _navigationService.navigateTo(HomeViewRoute);
  }

}
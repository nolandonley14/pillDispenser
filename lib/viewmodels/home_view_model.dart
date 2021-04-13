import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/models/user.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/dialog_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'package:senior_design_pd/services/notification_service.dart';

import 'base_model.dart';
class HomeViewModel extends BaseModel {

  final AuthenticationService _authService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final NotificationService _notificationService = locator<NotificationService>();

  Future signOut() async {
    await _authService.signOut();
  }

  String getId() {
    return _authService.currentUser.uid;
  }

  void handleHomeViewLogic() {
    _notificationService.initialize();
  }

  void showNotification() {
    _notificationService.instantNotification();
  }

  void navigateToLogin() {
    _navigationService.navigateTo(LoginViewRoute);
  }

  void navigateToFindDevices() {
    _navigationService.navigateTo(FindDevicesViewRoute);
  }

  String getName() {
    return _authService.currentUser.name;
  }

  void navigateToAddMed() {
    _navigationService.navigateTo(AddMedicationRoute);
  }
  
  bool hasDevice() {
    return _authService.currentUser.deviceConnected;
  }
}
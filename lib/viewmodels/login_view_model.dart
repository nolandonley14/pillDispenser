import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/dialog_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';

import 'base_model.dart';
class LoginViewModel extends BaseModel {

  final AuthenticationService _authService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signUp(String email, String password) async {
    setBusy(true);

    var result = await _authService.signInWithEmailAndPassword(email, password);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }

  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);

  }
  
}
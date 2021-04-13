import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/dialog_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'base_model.dart';

class SignUpViewModel extends BaseModel {

  final AuthenticationService _authService = locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signUp(String email, String password, String name) async {
    setBusy(true);

    var result = await _authService.registerWithEmailAndPassword(email, password, name);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }

  }

  void returnToHomeScreen() {
    _navigationService.navigateTo(LoginViewRoute);
  }

}
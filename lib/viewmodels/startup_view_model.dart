import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'package:senior_design_pd/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  
  final AuthenticationService _authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {

    var hasLoggedInUser = await _authService.isUserLoggedIn();

    if (hasLoggedInUser) {
      // if user has device connected go to home, else go to device set up
      _navigationService.navigateTo(HomeViewRoute);
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }

  }

}
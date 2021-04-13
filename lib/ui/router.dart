import 'package:senior_design_pd/ui/screens/add_medication.dart';
import 'package:senior_design_pd/ui/screens/bluetoothPage.dart';
import 'package:senior_design_pd/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/ui/screens/login_page.dart';
import 'package:senior_design_pd/ui/screens/sign_up.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginPage(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUp(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );
    case FindDevicesViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: FindDevicesScreen(),
      );
    case AddMedicationRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AddMedication(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}

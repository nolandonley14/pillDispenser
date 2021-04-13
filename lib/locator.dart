import 'package:get_it/get_it.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/firestore_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'package:senior_design_pd/services/dialog_service.dart';
import 'package:senior_design_pd/services/notification_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => NotificationService());
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_design_pd/constants/route_names.dart';
import 'package:senior_design_pd/locator.dart';
import 'package:senior_design_pd/services/authentication_service.dart';
import 'package:senior_design_pd/services/dialog_service.dart';
import 'package:senior_design_pd/services/firestore_service.dart';
import 'package:senior_design_pd/services/navigation_service.dart';
import 'package:senior_design_pd/services/notification_service.dart';
import 'base_model.dart';

class AddMedicationViewModel extends BaseModel {

  final FirestoreService _databaseService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final NotificationService _notificationService = locator<NotificationService>();

  Future addMedication(String name, String frequency) async {
    scheduleNotification(frequency, name);
    _navigationService.navigateTo(HomeViewRoute);
    print("successfly added " + name);
  }

  void scheduleNotification(String frequency, String name) {
    var date = DateTime.now();
    var addAMin = date.add(const Duration(minutes: 1));
    _notificationService.scheduledNotification(addAMin, frequency, name);
  }

  Future<TimeOfDay> pickTime(BuildContext context, TimeOfDay initialTime) async {
    return await showTimePicker(context: context, initialTime: initialTime);
  }

  void returnToHomeScreen() {
    _navigationService.navigateTo(HomeViewRoute);
  }

}
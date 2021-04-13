import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:senior_design_pd/models/timeZoneHelper.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ChangeNotifier {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("mvnLogo");

    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  //instant
  Future instantNotification() async {

    var android = AndroidNotificationDetails("id", "channel", "description");
    var ios = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    var platform = new NotificationDetails(android: android, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(0, "Demo instant notification", "Tap to do something", platform, payload: "Welcome to demo app");
  }


  //scheduled
  Future scheduledNotification(DateTime date, String frequency, String name) async {

    var interval = DateTimeComponents.dayOfWeekAndTime;
    var tzlocation = TimeZone();
    String tzName = await tzlocation.getTimeZoneName();
    final location = await tzlocation.getLocation(tzName);
    final scheduledDate = tz.TZDateTime.from(date, location);

    var android = AndroidNotificationDetails("id", "channel", "description");
    var ios = IOSNotificationDetails();

    var dateInterp = UILocalNotificationDateInterpretation.absoluteTime;

    var platform = new NotificationDetails(android: android, iOS: ios);

    switch (frequency) {
      case "Daily":
        interval = DateTimeComponents.time;
        break;
      case "Weekly":
        interval = DateTimeComponents.dayOfWeekAndTime;
        break;
      default:
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(0,
    "Time to take your " + name,
    "Tap to view your calendar and take your medication",
    scheduledDate,
    platform,
    androidAllowWhileIdle: true,
    matchDateTimeComponents: interval,
    payload: "",
    uiLocalNotificationDateInterpretation: dateInterp);
  }

  //Cancel Notificaiton
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

}
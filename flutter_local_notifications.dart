import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// first add
// flutter_local_notifications: ^8.2.0
// timezone: ^0.8.0
void fireAppNotifications() async {
  // local to put your place
  tz.initializeTimeZones();
  final location = tz.getLocation('Africa/Cairo');
  // setting
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // you must put app_icon7.png in ../{project}/android/app/src/main/res/drawable
  // you must put android:resource="@drawable/app_icon7" in ../{project}/android/app/src/main/AndroidManifest.xml
  // .. in application
  var initializationSettingsAndroid = const AndroidInitializationSettings(
      'app_icon7');
  var initializationSettingsIOS = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, onSelectNotification: null);
  // function of time and channel settings
  Future<void> scheduleNotification({
    required tz.TZDateTime time,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channelName',
      'channel_description',
      visibility: NotificationVisibility.public,
      color: Colors.green,
      autoCancel: true,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'title',
      'body',
      time,
      platformChannelSpecifics,
      payload: 'test',
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
  // convert hours , minutes and seconds to TZDateTime
  tz.TZDateTime converterTime(
      {required int hour, required int minute, int second = 0}) {
    final tz.TZDateTime now = tz.TZDateTime.now(location);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        second);
    // to run every day
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  // run the function with specified time
  scheduleNotification(time: converterTime(hour: 15, minute: 11));
}

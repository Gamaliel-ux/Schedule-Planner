import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Get device timezone
    final timezoneInfo =
        await FlutterTimezone.getLocalTimezone();

    // flutter_timezone 5.1.0
    // menggunakan property 'identifier'
    tz.setLocalLocation(
      tz.getLocation(
        timezoneInfo.identifier,
      ),
    );

    // Android
    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS
    const iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(
      settings: settings,
    );
  }

  // ==========================================================
  // REQUEST PERMISSION
  // ==========================================================

  Future<void> requestPermission() async {
    // Android
    final android =
        notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await android?.requestNotificationsPermission();

    // iOS
    final ios =
        notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

    await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ==========================================================
  // SCHEDULE NOTIFICATION
  // ==========================================================

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final notificationDate =
        tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    // Jangan jadwalkan notification
    // jika waktunya sudah lewat.
    if (notificationDate.isBefore(
      tz.TZDateTime.now(tz.local),
    )) {
      return;
    }

    const androidDetails =
        AndroidNotificationDetails(
      'schedule_planner_reminders',
      'Schedule Planner Reminders',
      channelDescription:
          'Reminder untuk Schedule Planner',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails =
        DarwinNotificationDetails();

    const notificationDetails =
        NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: notificationDate,
      notificationDetails:
          notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'schedule_planner',
    );
  }

  // ==========================================================
  // CANCEL NOTIFICATION
  // ==========================================================

  Future<void> cancelNotification(
    int id,
  ) async {
    await notifications.cancel(
      id: id,
    );
  }

  // ==========================================================
  // CANCEL ALL
  // ==========================================================

  Future<void> cancelAll() async {
    await notifications.cancelAll();
  }
}
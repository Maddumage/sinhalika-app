import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage msg) async {
  debugPrint('FCM background: ${msg.messageId}');
}

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  static const _channelId = 'sinhalika_main';
  static const _channelName = 'Sinhalika Notifications';

  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // On iOS, getToken() requires an APNs token first.
    // Simulators never get one, so we gate on its availability.
    if (Platform.isIOS) {
      final apns = await _fcm.getAPNSToken();
      if (apns == null) {
        debugPrint('FCM: no APNs token (simulator) — push skipped');
        return;
      }
    }

    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen(_showLocal);
    final token = await _fcm.getToken();
    debugPrint('FCM token: $token');
  }

  Future<void> _showLocal(RemoteMessage msg) async {
    final n = msg.notification;
    if (n == null) return;
    await _local.show(
      n.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

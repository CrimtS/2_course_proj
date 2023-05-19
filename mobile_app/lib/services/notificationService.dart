import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:mw_inside/services/authorizationService.dart';
import 'package:mw_inside/services/backgroundService.dart';
import 'package:mw_inside/services/storageService.dart';
import 'package:mw_inside/services/uiService.dart';
import 'backendCommunicationService.dart';
import 'package:mw_inside/services/geoService.dart';

FlutterLocalNotificationsPlugin localNotification;

class Notifier {
  Notifier() {
    var androidInitialize = new AndroidInitializationSettings('small_logo');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future showNotification({
    String title = "Notification title",
    String description = "Notification description",
    Importance importance = Importance.high,
  }) async {
    var androidDetails = new AndroidNotificationDetails(
      "channelId",
      "Local Notification",
      channelDescription: "This is a description",
      importance: Importance.high,
      priority: Priority.high,
    );
    var iOSDetails = new DarwinNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await localNotification.show(
        0, title, description, generalNotificationDetails);
  }
}

void checkNearbyObjectNotification(LocationData locationData) async {
  bool isLogged = await verify();
  if (!isLogged) return;
  if (!backgroundServiceRunning) {
    return;
  }
  Map requestData;
  List<String> filter = await buildFilterArray();
  if (filter.isNotEmpty && filter.length != 10) {
    requestData = {
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
      "filter": filter,
    };
  } else {
    requestData = {
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
    };
  }
  Map response = await serverRequest(
      'post', 'geo_objects/nearby_object_notification', requestData);
  double latitude = response['latitude'];
  double longitude = response['longitude'];
  bool isExplored=await serverRequest('get', '/user_stats/is_explored/${response['id']}', null);
  int dist = calculateDistance(
      latitude, longitude, locationData.latitude, locationData.longitude);
  int radius = await getNotificationsRadius();
  if (dist <= radius && isExplored==false) {
    Notifier notifier = Notifier();
    notifier.showNotification(
      title: "${response['name_ru']}",
      description: "Расстояние ${dist}м, "
          "${capitalize(getRussianCategory(response['category']))}",
      importance: Importance.high,
    );
  }
}

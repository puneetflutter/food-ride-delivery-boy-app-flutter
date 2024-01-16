import 'dart:io';

import 'package:efood_multivendor_driver/view/screens/request/order_request_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../view/screens/dashboard/widget/new_order_dilog.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    // bookingServiceChannel = const AndroidNotificationChannel(
    //   'foodride_delivery', // id
    //   'foodride_delivery name', // title
    //   description:
    //       'This channel is used for booking services important notifications.', // description
    //   importance: Importance.max,
    //   playSound: true,
    //   sound: RawResourceAndroidNotificationSound('notification'),
    // );
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(bookingServiceChannel);
    // bool isFlutterLocalNotificationsInitialized = true;
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    if (!GetPlatform.isIOS) {
      String? _title;
      String? _body;
      String? _orderID;
      String? _image;
      if (data) {
        _title = message.data['title'];
        _body = message.data['body'];
        _orderID = message.data['order_id'];
        _image = (message.data['image'] != null &&
                message.data['image'].isNotEmpty)
            ? message.data['image'].startsWith('http')
                ? message.data['image']
                : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}'
            : null;
      } else {
        _title = message.notification?.title;
        _body = message.notification?.body;
        _orderID = message.notification?.titleLocKey;
        if (GetPlatform.isAndroid) {
          _image = (message.notification?.android?.imageUrl != null &&
                  '${message.notification?.android?.imageUrl}'.isNotEmpty)
              ? message.notification?.android?.imageUrl?.startsWith('http') ?? false
                  ? message.notification?.android?.imageUrl
                  : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification?.android?.imageUrl}'
              : null;
        } else if (GetPlatform.isIOS) {
          _image = (message.notification?.apple?.imageUrl != null &&
                  '${message.notification?.apple?.imageUrl}'.isNotEmpty)
              ? message.notification?.apple?.imageUrl?.startsWith('http') ?? false
                  ? message.notification?.apple?.imageUrl
                  : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification?.apple?.imageUrl}'
              : null;
        }
      }

      if (_image != null && _image.isNotEmpty) {
        try {
          print(" try charvani in image noticicaiton");

          await showBigPictureNotificationHiddenLargeIcon(
              '$_title', '$_body', '$_orderID', _image, fln);
        } catch (e) {
          print(" cache charvani in  noticicaiton");

          await showBigTextNotification('$_title', '$_body', '$_orderID', fln);
        }
      } else {
        await showBigTextNotification('$_title', '$_body', '$_orderID', fln);
        print(" else charvani in  noticicaiton");
      }
    }
  }

  static Future<void> showTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'foodride_delivery',
      'foodride_delivery name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String body,
      String orderID, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'foodride_delivery channel id',
      'foodride_delivery name',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title,
      String body,
      String orderID,
      String image,
      FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'foodride_delivery',
      'foodride_delivery name',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Get.offAll(OrderRequestScreen(onTap: () {}));
  // Future<void> _launchApp() async {
  //   // Replace 'package_name' with the actual package name of the app you want to launch
  //   final String packageName = 'com.gaminigroup.foodride.deliveryapp';

  //   if (await canLaunch(packageName)) {
  //     await launch(packageName);
  //   } else {
  //     throw 'Could not launch $packageName';
  //   }
  // }
  // await FirebaseMessaging.instance.requestPermission();

  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
  // if (message != null) {
  //   String _type = message.notification.bodyLocKey;
  //   String _orderID = message.notification.titleLocKey;
  //   print("notification type...$_type");
  //   if (_type == 'new_order') {
  //     //_orderCount = _orderCount + 1;
  //     // Get.dialog(NewRequestDialog(
  //     //     isRequest: true, onTap: () => _navigateRequestPage()));
  //     Get.dialog(NewOrderDilog(
  //       orderId: int.parse(_orderID),
  //     ));
  //   }
  // }
}

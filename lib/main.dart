import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/controller/theme_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/data/repository/splash_repo.dart';
import 'package:efood_multivendor_driver/helper/notification_helper.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/theme/dark_theme.dart';
import 'package:efood_multivendor_driver/theme/light_theme.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'controller/auth_controller.dart';
import 'helper/get_di.dart' as di;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// charvani started working on this project 9-5-23, 1:20pm

late AndroidNotificationChannel bookingServiceChannel;
// late AndroidNotificationDetails notifictionDetails;
// late AndroidNotificationDetails notifictionDetails2;

bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bookingServiceChannel = const AndroidNotificationChannel(
    'foodridee', // idDe
    'Orders', // title
    description:
        'This channel is used for booking services important notifications.', // description
    importance: Importance.max,
    playSound: true,
    enableVibration: false,
    showBadge: true,
    enableLights: true,
    sound: RawResourceAndroidNotificationSound('noti'),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(bookingServiceChannel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
  // flutterLocalNotificationsPlugin
  //   .resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()
  //   ?.createBroadcastReceiver();

// flutterLocalNotificationsPlugin
//     .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//     ?.createNotificationReceiver();

// Listen for broadcast messages
// flutterLocalNotificationsPlugin
//     .didReceiveBroadcastStream()
//     .listen((ReceivedNotification notification) {
//   // Handle the received broadcast message here
// });
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
Future<void> main() async {


  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  ApiClient apiClient = ApiClient(appBaseUrl: 'https://web.foodride.in', sharedPreferences: sharedPreferences);

  // Registering SplashRepo using Get.put
  Get.put(SplashRepo(apiClient: apiClient, sharedPreferences: sharedPreferences));
  setPathUrlStrategy();


  await _firebaseMessaging.requestPermission(
    announcement: true,
    carPlay: true,
    criticalAlert: true,
  );
  await setupFlutterNotifications();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  Map<String, Map<String, String>> _languages = await di.init();

  try {
    if (GetPlatform.isMobile) {
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  runApp(MyApp(languages: _languages));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  MyApp({this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      _route();
    }
    // myFun() async {
    //   print('My Fun Method is Calling Start................');
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //   ApiClient apiClient = ApiClient(appBaseUrl: 'https://web.foodride.in', sharedPreferences: sharedPreferences);
    //
    //   // Registering SplashRepo using Get.put
    //   Get.put(SplashRepo(apiClient: apiClient, sharedPreferences: sharedPreferences));
    //
    //   // OR Registering SplashRepo lazily using Get.lazyPut
    //   // Get.lazyPut(() => SplashRepo(apiClient: apiClient, sharedPreferences: sharedPreferences));
    //
    //   print('My Fun Method is Calling End................');
    // }
    //
    // myFun();



    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<SplashController>(builder: (splashController ) {
        return GetBuilder<LocalizationController>(builder: (localizeController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.APP_NAME,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  theme: themeController.darkTheme ? dark : light,
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages ?? {}),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode ?? '',
                      AppConstants.languages[0].countryCode),
                  initialRoute: RouteHelper.getSplashRoute(),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

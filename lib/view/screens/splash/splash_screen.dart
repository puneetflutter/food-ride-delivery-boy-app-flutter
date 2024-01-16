import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/dashboard_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/order_controller.dart';
import '../../../helper/notification_helper.dart';
import '../../../util/app_constants.dart';
import '../dashboard/widget/new_order_dilog.dart';
import '../dashboard/widget/new_request_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  final SplashController _versionCheckController = Get.put(SplashController());
  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();

    versionCheck();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.notification != null) {
          String? _type = message.notification?.bodyLocKey;
          String? _orderID = message.notification?.titleLocKey;
          print("notification type...$_type");
          Timer(Duration(seconds: 5), () {
            if (_type == 'new_order') {
              //_orderCount = _orderCount + 1;
              // Get.dialog(NewRequestDialog(
              //     isRequest: true, onTap: () => _navigateRequestPage()));
              Get.dialog(NewOrderDilog(
                orderId: int.parse('$_orderID'),
              ));
            }
          });
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("charvani cheking notifications");
      print("notification data..${message.notification}");
      print("data of notification..${message.data}");
      // if(Get.find<OrderController>().latestOrderList != null) {
      //   _orderCount = Get.find<OrderController>().latestOrderList.length;
      // }
      print("onMessage: ${message.data}");
      String? _type = message.notification?.bodyLocKey;
      String? _orderID = message.notification?.titleLocKey;
      print("getting order id  is....${_orderID}");
      if (_type != 'assign' && _type != 'new_order') {
        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin, false);
      }
      Get.find<OrderController>().getCurrentOrders();
      Get.find<OrderController>().getLatestOrders();
      //Get.find<OrderController>().getAllOrders();
      if (_type == 'new_order') {
        //_orderCount = _orderCount + 1;
        // Get.dialog(NewRequestDialog(
        //     isRequest: true, onTap: () => _navigateRequestPage()));
        Get.dialog(
            NewOrderDilog(
              orderId: int.parse('$_orderID'),
            ),
            barrierDismissible: false);
      } else if (_type == 'assign' && _orderID != null && _orderID.isNotEmpty) {
        Get.dialog(NewRequestDialog(
            isRequest: false,
            onTap: () => Get.offAll(() => DashboardScreen(pageIndex: 0))));
      } else if (_type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });
//charvani---> App in minimize.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      String? _type = message.notification?.bodyLocKey;
      String? _orderID = message.notification?.titleLocKey;
      print("notification type...$_type");
      if (_type == 'new_order') {
        //_orderCount = _orderCount + 1;
        // Get.dialog(NewRequestDialog(
        //     isRequest: true, onTap: () => _navigateRequestPage()));
        Get.dialog(NewOrderDilog(
          orderId: int.parse('$_orderID'),
        ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  var deviceType;

  versionCheck() async {
    if (Platform.isAndroid) {
      deviceType = "android";
    } else if (Platform.isIOS) {
      deviceType = "ios";
    }
    Map<String, dynamic> mapdata = {
      "app_version": AppConstants.APP_VERSION,
      "device_type": deviceType,
      "type": "delivery_man"
    };
    dynamic res = await _versionCheckController.versionCheckFun(mapdata);
    print("getting res...${res['status']}");

    if (res['status'] == "invalid") {
      _route();
    } else {
      dynamic updatelink;
      if (deviceType == "android") {
        updatelink = res['data']['android_download_link'];
      }

      // ignore: use_build_context_synchronously
      versionDilog(context, res['data']['android_latest_version_note'],
          updatelink, res['data']['android_force_update_required']);
    }
  }

  versionDilog(context, String title, dynamic updateLink, String forfulUpdate) {
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter myState) {
              return AlertDialog(title: Text(title), actions: [
                TextButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse(updateLink),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: const Text(
                      "Update now",
                      style: TextStyle(color: Colors.orange),
                    )),
                if (forfulUpdate == "No")
                  TextButton(
                    child: const Text("Not now"),
                    onPressed: () {
                      Navigator.pop(context);
                      _route();
                    },
                  )
              ]);
            }));
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if (Get.find<SplashController>().configModel.maintenanceMode ??
              false) {
            Get.offNamed(RouteHelper.getUpdateRoute(false));
          } else {
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.find<AuthController>().updateToken();
              await Get.find<AuthController>().getProfile();
              Get.offNamed(RouteHelper.getInitialRoute());
            } else {
              Get.offNamed(RouteHelper.getSignInRoute());
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Images.splash,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

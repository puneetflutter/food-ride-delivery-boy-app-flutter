import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/helper/notification_helper.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/main.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/view/base/custom_alert_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/new_order_dilog.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/home/home_screen.dart';
import 'package:efood_multivendor_driver/view/screens/profile/profile_screen.dart';
import 'package:efood_multivendor_driver/view/screens/request/order_request_screen.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final _channel = const MethodChannel('com.sixamtech/app_retain');
  //Timer _timer;
  //int _orderCount;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      OrderRequestScreen(onTap: () => _setPage(0)),
      HomeScreen(),
      OrderScreen(),
      ProfileScreen(),
    ];
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  void _navigateRequestPage() {
    if (Get.find<AuthController>().profileModel != null &&
        Get.find<AuthController>().profileModel.active == 1 &&
        Get.find<OrderController>().currentOrderList != null &&
        Get.find<OrderController>().currentOrderList.length < 1) {
      _setPage(0);
    } else {
      if (Get.find<AuthController>().profileModel == null ||
          Get.find<AuthController>().profileModel.active == 0) {
        Get.dialog(CustomAlertDialog(
            description: 'you_are_offline_now'.tr,
            onOkPressed: () => Get.back()));
      } else {
        //Get.dialog(CustomAlertDialog(description: 'you_have_running_order'.tr, onOkPressed: () => Get.back()));
        _setPage(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (GetPlatform.isAndroid &&
              Get.find<AuthController>().profileModel.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child:
          //  MaterialApp(

          Scaffold(
        bottomNavigationBar: GetPlatform.isDesktop
            ? SizedBox()
            : BottomAppBar(
                elevation: 5,
                notchMargin: 5,
                shape: CircularNotchedRectangle(),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    BottomNavItem(
                        iconData: Icons.home,
                        isSelected: _pageIndex == 0,
                        onTap: () {
                          _navigateRequestPage();
                        }),
                    BottomNavItem(
                        iconData: Icons.currency_rupee,
                        isSelected: _pageIndex == 1,
                        onTap: () => _setPage(1)),
                    BottomNavItem(
                        iconData: Icons.shopping_bag,
                        isSelected: _pageIndex == 2,
                        onTap: () => _setPage(2)),
                    BottomNavItem(
                        iconData: Icons.person,
                        isSelected: _pageIndex == 3,
                        onTap: () => _setPage(3)),
                  ]),
                ),
              ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
      // ),
    );
  }

  void _setPage(int pageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          _pageController.jumpToPage(pageIndex);
          _pageIndex = pageIndex;
        });
      }
    });
  }
}

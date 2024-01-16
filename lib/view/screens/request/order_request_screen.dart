import 'dart:async';

import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/screens/dashboard/dashboard_screen.dart';
import 'package:efood_multivendor_driver/view/screens/request/widget/order_requset_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';
import '../../base/custom_button.dart';
import '../dashboard/widget/new_order_dilog.dart';

class OrderRequestScreen extends StatefulWidget {
  final Function onTap;
  final String? from, orderId;
  const OrderRequestScreen({required this.onTap, this.from, this.orderId});

  @override
  _OrderRequestScreenState createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen>
    with WidgetsBindingObserver {
  late Timer _timer;
  final OrderController _ordController = Get.put(OrderController());
  ScrollController _scrollController = ScrollController();
  bool orderStatus = false;
  List<String> orderIds = [];
  timerRepeateFun() async {
    dynamic res = await Get.find<OrderController>().getLatestOrders();
    print("init page res...$res");
    if (res != null) {
      if (res.runtimeType.toString() == "List<dynamic>") {
        orderIds.clear();
        for (int i = 0; i < res.length; i++) {
          if (mounted) {
            setState(() {
              orderIds.add(res[i]['id'].toString());
            });
          }
        }
        print(orderIds);
        print(widget.orderId);
        if (orderIds.contains(widget.orderId.toString())) {
          print("i am");
          if (mounted) {
            setState(() {
              orderStatus = false;
            });
          }
        } else {
          print("there is no oreder any more .....");
          if (mounted) {
            setState(() {
              orderStatus = true;
            });
          }
        }
      } else {
        print("there is no oreder any more oooooooo");
        if (mounted) {
          setState(() {
            orderStatus = true;
          });
        }
      }
    } else {
      print("empty latest orders");
    }
  }

  dataFun() async {
    // dynamic res = await _ordController.getLatestOrders();
    // if (widget.from != "noti") {
    // if (_timer == null) {
    //   _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //     print("mmmmmmmmmm");
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       timerRepeateFun();
    //     });
    //   });
    // }

    // } else {
    //   _timer?.cancel();
    // }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timerRepeateFun();
    });
  }

  @override
  initState() {
    super.initState();
    print("in order request screen.....${widget.from}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dataFun();
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      print("timer in disposeee");

      if (!mounted) {
        _timer?.cancel();
      }
    }

    _scrollController.dispose();

    super.dispose();
  }

  @override
  void deactivate() {
    print("i am at deactivate fun");
    if (_timer != null) {
      if (!mounted) {
        _timer.cancel();

      }
    }

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_request'.tr, isBackButtonExist: false),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return orderStatus == true && widget.from == "noti"
            ? Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor),

//                     borderA: Border(
//
//                     ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(Images.notification_in,
                            height: 60, color: Theme.of(context).primaryColor),
                        SizedBox(
                          height: 30,
                        ),
                        Text("ORDER ID: #${widget.orderId}"),
                        SizedBox(
                          height: 10,
                        ),
                        Text("This order already accepted by others."),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 250,
                    child: CustomButton(
                        height: 40,
                        buttonText: 'Back to home'.tr,
                        onPressed: () {
                          Get.offAll(DashboardScreen(pageIndex: 0));
                        }),
                  ),
                ],
              ))
            : orderController.latestOrderList != null
                ? orderController.latestOrderList.length > 0
                    ? RefreshIndicator(
                        onRefresh: () async {
                          await Get.find<OrderController>().getLatestOrders();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: orderController.latestOrderList.length,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: widget.from == "noti"
                              ? const NeverScrollableScrollPhysics()
                              : const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if ((widget.from == "noti") &&
                                (widget.orderId.toString() ==
                                    orderController.latestOrderList[index].id
                                        .toString())) {
                              _scrollController.animateTo(
                                (double.parse(index.toString()) * 50),
                                // Assuming each item has a fixed height
                                duration: const Duration(
                                    milliseconds:
                                        500), // Duration of the scroll animation
                                curve: Curves.easeInOut, // Animation curve
                              );
                            }

                            return (widget.from == "noti") &&
                                    (widget.orderId.toString() ==
                                        orderController
                                            .latestOrderList[index].id
                                            .toString())
                                ? Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.85,
                                    alignment: Alignment.topCenter,
                                    child: OrderRequestWidget(
                                        from: widget.from ??'',
                                        orderModel: orderController
                                            .latestOrderList[index],
                                        index: index,
                                        onTap: widget.onTap),
                                  )
                                : (widget.from != "noti")
                                    ? OrderRequestWidget(
                                        from: widget.from ??'',
                                        orderModel: orderController
                                            .latestOrderList[index],
                                        index: index,
                                        onTap: widget.onTap)
                                    : Text("");
                          },
                        ),
                      )
                    : Center(child: Text('no_order_request_available'.tr))
                : Center(child: CircularProgressIndicator());
      }),
    );
  }
}

import 'dart:async';

import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/my_text_field.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/info_card.dart';
import 'package:efood_multivendor_driver/view/screens/order/widget/slider_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final from;

  final OrderModel orderModel;
  final bool isRunningOrder;

  final int orderIndex;

  OrderDetailsScreen(
      {required this.orderModel,
      required this.from,
      required this.isRunningOrder,
      required this.orderIndex});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Timer _timer;
  final TextEditingController _reasoncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<OrderController>().setOrder(widget.orderModel);
    Get.find<OrderController>()
        .getOrderDetails(Get.find<OrderController>().orderModel.id ??0);
    if (widget.from != "noti") {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        Get.find<OrderController>()
            .getOrderWithId(Get.find<OrderController>().orderModel.id ??0);
      });
    } else {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool? _cancelPermission =
        Get.find<SplashController>().configModel.canceledByDeliveryman;
    bool _selfDelivery =
        Get.find<AuthController>().profileModel.type != 'zone_wise';

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBar(
          title: 'order_details'.tr,
          onBackPressed: () {
            print("winget coming isss....${widget.from}");
            if (widget.from == "noti") {
              print("in notification");
              Get.offAll(() => DashboardScreen(
                    pageIndex: 0,
                  ));
            } else {
              print("in else condition");
              // Get.back();
              Navigator.pop(context);
            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<OrderController>(builder: (orderController) {
            OrderModel controllerOrderModel = orderController.orderModel;

            bool _restConfModel = Get.find<SplashController>()
                    .configModel
                    .orderConfirmationModel !=
                'deliveryman';
            bool _showBottomView =
                controllerOrderModel.orderStatus == 'accepted' ||
                    controllerOrderModel.orderStatus == 'confirmed' ||
                    controllerOrderModel.orderStatus == 'processing' ||
                    controllerOrderModel.orderStatus == 'handover' ||
                    controllerOrderModel.orderStatus == 'picked_up' ||
                    widget.isRunningOrder;
            bool _showSlider =
                (controllerOrderModel.paymentMethod == 'cash_on_delivery' &&
                        controllerOrderModel.orderStatus == 'accepted' &&
                        !_restConfModel &&
                        !_selfDelivery) ||
                    controllerOrderModel.orderStatus == 'handover' ||
                    controllerOrderModel.orderStatus == 'picked_up';
            return orderController.orderDetailsModel != null
                ? Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(children: [
                        DateConverter.isBeforeTime(
                                controllerOrderModel.scheduleAt ??'')
                            ? (controllerOrderModel.orderStatus !=
                                        'delivered' &&
                                    controllerOrderModel.orderStatus !=
                                        'failed' &&
                                    controllerOrderModel.orderStatus !=
                                        'canceled')
                                ? Column(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                            Images.animate_delivery_man,
                                            fit: BoxFit.contain)),
                                    SizedBox(
                                        height:
                                            Dimensions.PADDING_SIZE_DEFAULT),
                                    Text('food_need_to_deliver_within'.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: Theme.of(context)
                                                .disabledColor)),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Center(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateConverter.differenceInMinute(
                                                          controllerOrderModel
                                                              .restaurantDeliveryTime ??'',
                                                          controllerOrderModel
                                                              .createdAt ??'',
                                                          controllerOrderModel
                                                              .processingTime ??0,
                                                          controllerOrderModel
                                                              .scheduleAt ??'') <
                                                      5
                                                  ? '1 - 5'
                                                  : '${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime ??'', controllerOrderModel.createdAt ??'', controllerOrderModel.processingTime ??0, controllerOrderModel.scheduleAt ??'') - 5} '
                                                      '- ${DateConverter.differenceInMinute(controllerOrderModel.restaurantDeliveryTime ??'', controllerOrderModel.createdAt ??'', controllerOrderModel.processingTime ??0, controllerOrderModel.scheduleAt ??'')}',
                                              style: robotoBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_LARGE),
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            Text('min'.tr,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ]),
                                    ),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_LARGE),
                                  ])
                                : SizedBox()
                            : SizedBox(),
                        Row(children: [
                          Text('${'order_id'.tr}:', style: robotoRegular),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(controllerOrderModel.id.toString(),
                              style: robotoMedium),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Expanded(child: SizedBox()),
                          Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green)),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text(
                            controllerOrderModel.orderStatus?.tr ??'',
                            style: robotoRegular,
                          ),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        controllerOrderModel.orderStatus
                                        .toString() ==
                                    'picked_up' &&
                                controllerOrderModel
                                        .awt_return_order_status ==
                                    0 &&
                                controllerOrderModel
                                        .awt_return_order_reason ==
                                    "n/a"
                            ? CustomButton(
                                height: 40,
                                backgroundColor: Colors.red,
                                buttonText: 'return_order'.tr,
                                onPressed: () => {
                                      showDialog(
                                        // barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
                                        // backgroundColor: widget.backgroundColor ?? Colors.transparent,
                                        context: context,
                                        builder: (context) => Center(
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxHeight: 600, maxWidth: 400),
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL)),
                                              //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Image.asset(Images., height: 60, color: Theme.of(context).primaryColor),

                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            Dimensions
                                                                .PADDING_SIZE_LARGE),
                                                        child: Text(
                                                          'return_order_request'
                                                              .tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: robotoRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_EXTRA_LARGE),
                                                        ),
                                                      ),
                                                      MyTextField(
                                                        hintText:
                                                            'Enter Reason',
                                                        controller:
                                                            _reasoncontroller,
                                                      ),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE),

                                                      CustomButton(
                                                        height: 40,
                                                        buttonText: 'submit'.tr,
                                                        onPressed: () {
                                                          // if(!widget.isRequest) {
                                                          //   _timer?.cancel();
                                                          // }
                                                          // Get.back();
                                                          // widget.onTap();

                                                          orderController.ReturnOrderRequest(
                                                                  controllerOrderModel
                                                                      .id
                                                                      .toString(),
                                                                  controllerOrderModel
                                                                      .deliveryManId
                                                                      .toString(),
                                                                  _reasoncontroller
                                                                      .text
                                                                      .toString())
                                                              .then(
                                                                  (isSuccess) {
                                                            if (isSuccess) {
                                                              // onTap();
                                                              // orderModel.orderStatus = (orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'confirmed')
                                                              //     ? 'accepted' : orderModel.orderStatus;
                                                              // Get.toNamed(
                                                              //   RouteHelper.getOrderDetailsRoute(orderModel.id),
                                                              //   arguments: OrderDetailsScreen(
                                                              //     orderModel: orderModel, isRunningOrder: true, orderIndex: orderController.currentOrderList.length-1,
                                                              //   ),
                                                              // );
                                                              Get.dialog(
                                                                  ConfirmationDialog(
                                                                    icon: Images
                                                                        .location_permission,
                                                                    iconSize:
                                                                        100,
                                                                    hasCancel:
                                                                        false,
                                                                    description:
                                                                        'Return Order Requested, Wait for Approval',
                                                                    onYesPressed:
                                                                        () {
                                                                      Get.back();
                                                                      Get.find<
                                                                              AuthController>()
                                                                          .getProfile();
                                                                      Get.find<
                                                                              OrderController>()
                                                                          .getCurrentOrders();
                                                                      //_checkPermission(() => startLocationRecord());
                                                                    },
                                                                  ),
                                                                  barrierDismissible:
                                                                      false);
                                                            } else {
                                                              // Get.find<OrderController>().getLatestOrders();
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    })
                            : controllerOrderModel.orderStatus
                                            .toString() ==
                                        'picked_up' &&
                                    controllerOrderModel
                                            .awt_return_order_status ==
                                        0 &&
                                    controllerOrderModel
                                            .awt_return_order_reason !=
                                        "n/a"
                                ? Text(
                                    'Return Requested',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic),
                                  )
                                : controllerOrderModel.orderStatus.toString() ==
                                            'picked_up' &&
                                        controllerOrderModel
                                                .awt_return_order_status ==
                                            1
                                    ? Text(
                                        'Return Order Approved',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontStyle: FontStyle.italic),
                                      )
                                    : SizedBox(),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        InfoCard(
                          title: 'restaurant_details'.tr,
                          addressModel: DeliveryAddress(
                              address: controllerOrderModel.restaurantAddress),
                          image:
                              '${Get.find<SplashController>().configModel.baseUrls?.restaurantImageUrl}/${controllerOrderModel.restaurantLogo}',
                          name: controllerOrderModel.restaurantName ??"",
                          phone: controllerOrderModel.restaurantPhone ??'',
                          latitude: controllerOrderModel.restaurantLat ??'',
                          longitude: controllerOrderModel.restaurantLng ??'',
                          showButton:
                              controllerOrderModel.orderStatus != 'delivered',
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        InfoCard(
                          title: 'customer_contact_details'.tr,
                          addressModel: controllerOrderModel.deliveryAddress,
                          isDelivery: true,
                          image: controllerOrderModel.customer != null
                              ? '${Get.find<SplashController>().configModel.baseUrls?.customerImageUrl}/${controllerOrderModel.customer?.image}'
                              : '',
                          name: controllerOrderModel
                              .deliveryAddress?.contactPersonName ??'',
                          phone: controllerOrderModel
                              .deliveryAddress?.contactPersonNumber ??'',
                          latitude:
                              controllerOrderModel.deliveryAddress?.latitude ??'',
                          longitude:
                              controllerOrderModel.deliveryAddress?.longitude ??'',
                          showButton:
                              controllerOrderModel.orderStatus != 'delivered',
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Row(children: [
                                  Text('${'item'.tr}:', style: robotoRegular),
                                  SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    orderController.orderDetailsModel.length
                                        .toString(),
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL,
                                        vertical: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      controllerOrderModel.paymentMethod ==
                                              'cash_on_delivery'
                                          ? 'cod'.tr
                                          : controllerOrderModel
                                                      .paymentMethod ==
                                                  'wallet'
                                              ? 'wallet_payment'.tr
                                              : 'digitally_paid'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: Theme.of(context).cardColor),
                                    ),
                                  ),
                                ]),
                              ),
                              if (controllerOrderModel.paymentMethod ==
                                  "cash_on_delivery")
                                Text(
                                  (controllerOrderModel.walletAmount != "0" &&
                                          controllerOrderModel.walletAmount !=
                                              "0.00" &&
                                          controllerOrderModel.walletAmount !=
                                              "" &&
                                          controllerOrderModel.paymentMethod
                                                  ?.toLowerCase() !=
                                              "wallet")
                                      ? "Amount to be collect: ₹${(double.parse('${controllerOrderModel.orderAmount}') - num.parse('${controllerOrderModel.walletAmount}')).toString()}"
                                      : "Amount to be collect: ₹ ${controllerOrderModel.orderAmount}",
                                ),
                              Divider(height: Dimensions.PADDING_SIZE_LARGE),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    orderController.orderDetailsModel.length,
                                itemBuilder: (context, index) {
                                  return OrderProductWidget(
                                      order: controllerOrderModel,
                                      orderDetails: orderController
                                          .orderDetailsModel[index]);
                                },
                              ),
                              (controllerOrderModel.orderNote != null)?
                              (controllerOrderModel.orderNote!.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text('additional_note'.tr,
                                              style: robotoRegular),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Container(
                                            width: 1170,
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                            child: Text(
                                              controllerOrderModel.orderNote ??'',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                        ])
                                  : SizedBox():SizedBox(),
                            ]),
                      ]),
                    )),
                    _showBottomView
                        ? ((controllerOrderModel.orderStatus == 'accepted' &&
                                    (controllerOrderModel.paymentMethod !=
                                            'cash_on_delivery' ||
                                        _restConfModel ||
                                        _selfDelivery)) ||
                                controllerOrderModel.orderStatus ==
                                    'processing' ||
                                controllerOrderModel.orderStatus == 'confirmed')
                            ? Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  border: Border.all(width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controllerOrderModel.orderStatus ==
                                          'processing'
                                      ? 'food_is_preparing'.tr
                                      : 'food_waiting_for_cook'.tr,
                                  style: robotoMedium,
                                ),
                              )
                            : _showSlider
                                ? (controllerOrderModel.paymentMethod ==
                                            'cash_on_delivery' &&
                                        controllerOrderModel.orderStatus ==
                                            'accepted' &&
                                        !_restConfModel &&
                                        _cancelPermission! &&
                                        !_selfDelivery)
                                    ? Row(children: [
                                        Expanded(
                                            child: TextButton(
                                          onPressed: () => Get.dialog(
                                              ConfirmationDialog(
                                                icon: Images.warning,
                                                title:
                                                    'are_you_sure_to_cancel'.tr,
                                                description:
                                                    'you_want_to_cancel_this_order'
                                                        .tr,
                                                onYesPressed: () {
                                                  orderController
                                                      .updateOrderStatus(
                                                          widget.orderIndex,
                                                          'canceled',
                                                          back: true)
                                                      .then((success) {
                                                    if (success) {
                                                      Get.find<AuthController>()
                                                          .getProfile();
                                                      Get.find<
                                                              OrderController>()
                                                          .getCurrentOrders();
                                                    }
                                                  });
                                                },
                                              ),
                                              barrierDismissible: false),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(1170, 40),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color ??
                                                      Color(0xFF000000)),
                                            ),
                                          ),
                                          child: Text('cancel'.tr,
                                              textAlign: TextAlign.center,
                                              style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color ??
                                                    Color(0xFF000000),
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                              )),
                                        )),
                                        SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Expanded(
                                            child: CustomButton(
                                          buttonText: 'confirm'.tr,
                                          height: 40,
                                          onPressed: () {
                                            Get.dialog(
                                                ConfirmationDialog(
                                                  icon: Images.warning,
                                                  title:
                                                      'are_you_sure_to_confirm'
                                                          .tr,
                                                  description:
                                                      'you_want_to_confirm_this_order'
                                                          .tr,
                                                  onYesPressed: () {
                                                    orderController
                                                        .updateOrderStatus(
                                                            widget.orderIndex,
                                                            'confirmed',
                                                            back: true)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.find<
                                                                AuthController>()
                                                            .getProfile();
                                                        Get.find<
                                                                OrderController>()
                                                            .getCurrentOrders();
                                                      }
                                                    });
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          },
                                        )),
                                      ])
                                    : controllerOrderModel
                                                    .awt_return_order_reason ==
                                                'n/a' ||
                                            controllerOrderModel
                                                    .awt_return_order_status ==
                                                1
                                        ? SliderButton(
                                            action: () {
                                              if (controllerOrderModel
                                                          .paymentMethod ==
                                                      'cash_on_delivery' &&
                                                  controllerOrderModel
                                                          .orderStatus ==
                                                      'accepted' &&
                                                  !_restConfModel &&
                                                  !_selfDelivery) {
                                                Get.dialog(
                                                    ConfirmationDialog(
                                                      icon: Images.warning,
                                                      title:
                                                          'are_you_sure_to_confirm'
                                                              .tr,
                                                      description:
                                                          'you_want_to_confirm_this_order'
                                                              .tr,
                                                      onYesPressed: () {
                                                        orderController
                                                            .updateOrderStatus(
                                                                widget
                                                                    .orderIndex,
                                                                'confirmed',
                                                                back: true)
                                                            .then((success) {
                                                          if (success) {
                                                            Get.find<
                                                                    AuthController>()
                                                                .getProfile();
                                                            Get.find<
                                                                    OrderController>()
                                                                .getCurrentOrders();
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    barrierDismissible: false);
                                              } else if (controllerOrderModel
                                                      .orderStatus ==
                                                  'picked_up') {
                                                if (controllerOrderModel
                                                        .awt_return_order_status ==
                                                    0) {
                                                  if (Get.find<
                                                              SplashController>()
                                                          .configModel
                                                          .orderDeliveryVerification !=null ||
                                                      controllerOrderModel
                                                              .paymentMethod ==
                                                          'cash_on_delivery') {
                                                    Get.bottomSheet(
                                                        VerifyDeliverySheet(
                                                          orderIndex:
                                                              widget.orderIndex,
                                                          verify: Get.find<
                                                                  SplashController>()
                                                              .configModel
                                                              .orderDeliveryVerification ??false,
                                                          orderAmount:
                                                              //charvani
                                                              (controllerOrderModel.walletAmount != "0" &&
                                                                      controllerOrderModel
                                                                              .walletAmount! !=
                                                                          "0.00" &&
                                                                      controllerOrderModel
                                                                              .walletAmount! !=
                                                                          "" &&
                                                                      controllerOrderModel
                                                                              .paymentMethod
                                                                              !.toLowerCase() !=
                                                                          "wallet")
                                                                  ? (double.parse('${controllerOrderModel
                                                                  .orderAmount}') -
                                                                      num.parse(
                                                                          '${controllerOrderModel
                                                                          .walletAmount}'))
                                                                  : controllerOrderModel
                                                                      .orderAmount,
                                                          cod: controllerOrderModel
                                                                  .paymentMethod ==
                                                              'cash_on_delivery',
                                                        ),
                                                        isScrollControlled:
                                                            true);
                                                  } else {
                                                    Get.find<OrderController>()
                                                        .updateOrderStatus(
                                                            widget.orderIndex,
                                                            'delivered')
                                                        .then((success) {
                                                      if (success) {
                                                        Get.find<
                                                                AuthController>()
                                                            .getProfile();
                                                        Get.find<
                                                                OrderController>()
                                                            .getCurrentOrders();
                                                      }
                                                    });
                                                  }
                                                } else {
                                                  Get.find<OrderController>()
                                                      .ReturnOrderComplete(
                                                          controllerOrderModel
                                                              .id
                                                              .toString(),
                                                          controllerOrderModel
                                                              .deliveryManId
                                                              .toString())
                                                      .then((success) => {
                                                            if (success)
                                                              {
                                                                Get.find<
                                                                        AuthController>()
                                                                    .getProfile(),
                                                                Get.find<
                                                                        OrderController>()
                                                                    .getCurrentOrders()
                                                              }
                                                          });
                                                }
                                              } else if (controllerOrderModel
                                                      .orderStatus ==
                                                  'handover') {
                                                if (Get.find<AuthController>()
                                                        .profileModel
                                                        .active ==
                                                    1) {
                                                  Get.find<OrderController>()
                                                      .updateOrderStatus(
                                                          widget.orderIndex,
                                                          'picked_up')
                                                      .then((success) {
                                                    if (success) {
                                                      Get.find<AuthController>()
                                                          .getProfile();
                                                      Get.find<
                                                              OrderController>()
                                                          .getCurrentOrders();
                                                    }
                                                  });
                                                } else {
                                                  showCustomSnackBar(
                                                      'make_yourself_online_first'
                                                          .tr);
                                                }
                                              }
                                            },
                                            label: Text(
                                              (controllerOrderModel
                                                              .paymentMethod ==
                                                          'cash_on_delivery' &&
                                                      controllerOrderModel
                                                              .orderStatus ==
                                                          'accepted' &&
                                                      !_restConfModel &&
                                                      !_selfDelivery)
                                                  ? 'swipe_to_confirm_order'.tr
                                                  : controllerOrderModel
                                                                  .orderStatus ==
                                                              'picked_up' &&
                                                          controllerOrderModel
                                                                  .awt_return_order_status ==
                                                              0
                                                      ? 'swipe_to_deliver_order'
                                                          .tr
                                                      : controllerOrderModel
                                                                      .orderStatus ==
                                                                  'picked_up' &&
                                                              controllerOrderModel
                                                                      .awt_return_order_status ==
                                                                  1
                                                          ? 'swipe_to_return_complete_order'
                                                              .tr
                                                          : controllerOrderModel
                                                                      .orderStatus ==
                                                                  'handover'
                                                              ? 'swipe_to_pick_up_order'
                                                                  .tr
                                                              : '',
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            dismissThresholds: 0.5,
                                            dismissible: false,
                                            shimmer: true,
                                            width: 1170,
                                            height: 60,
                                            buttonSize: 50,
                                            radius: 10,
                                            icon: Center(
                                                child: Icon(
                                              Get.find<LocalizationController>()
                                                      .isLtr
                                                  ? Icons.double_arrow_sharp
                                                  : Icons.keyboard_arrow_left,
                                              color: Colors.white,
                                              size: 20.0,
                                            )),
                                            isLtr: Get.find<
                                                    LocalizationController>()
                                                .isLtr,
                                            boxShadow: BoxShadow(blurRadius: 0),
                                            buttonColor:
                                                Theme.of(context).primaryColor,
                                            backgroundColor: Color(0xffF4F7FC),
                                            baseColor:
                                                Theme.of(context).primaryColor,
                                          )
                                        : SizedBox()
                                : SizedBox()
                        : SizedBox(),
                  ])
                : Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Get.offAll(() => DashboardScreen(
          pageIndex: 0,
        ));
    return Future.value(true);
  }
}

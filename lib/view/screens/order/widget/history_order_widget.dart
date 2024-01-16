import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/price_converter.dart';

class HistoryOrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunning;
  final bool? istextcolor;
  final int index;
  HistoryOrderWidget(
      {required this.orderModel,
      required this.isRunning,
      required this.index,
      this.istextcolor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getOrderDetailsRoute(orderModel.id ??0),
        arguments: OrderDetailsScreen(
            orderModel: orderModel,
            isRunningOrder: isRunning,
            orderIndex: index, from: null,),
      ),
      child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 300] ?? Color(0xFF000000),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child:
              // Row(children: [
              //
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              //     child: FadeInImage.assetNetwork(
              //       placeholder: Images.placeholder, height: 70, width: 70, fit: BoxFit.cover,
              //       image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
              //           '/${orderModel.restaurantLogo ?? ''}',
              //       imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 70, width: 70, fit: BoxFit.cover),
              //     ),
              //   ),
              //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              //
              //   Expanded(
              //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //
              //       Row(children: [
              //         Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
              //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         Text(
              //           '#${orderModel.id}',
              //           style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              //         ),
              //       ]),
              //       SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //
              //       Text(
              //         orderModel.restaurantName ?? 'no_restaurant_data_found'.tr,
              //         style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
              //       ),
              //       SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //
              //       Row(children: [
              //         Icon(Icons.access_time, size: 15),
              //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         Text(
              //           DateConverter.dateTimeStringToDateTime(orderModel.createdAt),
              //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              //         ),
              //       ]),
              //       Row(children: [
              //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         Text('Distance : '+orderModel.distanceKms,
              //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              //         ),
              //         SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //         Text('Earning : '+PriceConverter.convertPrice(orderModel.distanceFare.toDouble()),
              //           style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              //         ),
              //       ]),
              //
              //     ]),
              //   ),
              //
              // ]),
              Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${'order_id'.tr}: ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          Text('# ${orderModel.id}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black54)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Payment Method : ',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          Text('${orderModel.paymentMethod}',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black54)

                              // Theme.of(context).primaryColor)
                              ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Restaurant Details :',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black54)),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                Images.res_name,
                                width: 12,
                                height: 12,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text('${orderModel.restaurantName}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                            ],
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                Images.bike,
                                width: 12,
                                height: 12,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text('${orderModel.distanceKms}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Base Fee : ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                              Text(orderModel.deliveryBoyBaseFee.toString(),
                                  // orderModel.orderDetails.price.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Extra Fee : ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                              // Text(
                              //     orderModel.orderDetails.taxAmount.toString()),
                              // Text(orderModel.orderDetails.discountOnFood
                              //     .toString()),
                              Text(
                                  // '${(orderModel.orderDetails.taxAmount - orderModel.orderDetails.discountOnFood + orderModel.deliveryCharge + orderModel.packingCharges).toInt()}',
                                  orderModel.deliveryBoyExtraFee.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                            ],
                          ),
                          // if (orderModel.walletAmount != "0" &&
                          //     orderModel.walletAmount != "0.00" &&
                          //     orderModel.walletAmount != "" &&
                          //     orderModel.paymentMethod != "wallet")
                          //   Row(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       Text('Paid through wallet : -',
                          //           style: TextStyle(
                          //               fontSize: 12,
                          //               color: Get.isDarkMode
                          //                   ? Colors.white
                          //                   : Colors.black54)),
                          //       Text(
                          //           double.parse(orderModel.walletAmount)
                          //               .toInt()
                          //               .toString(),
                          //           style: TextStyle(
                          //               fontSize: 12,
                          //               color: Get.isDarkMode
                          //                   ? Colors.white
                          //                   : Colors.black54)),
                          //     ],
                          //   ),
                          Text('------------------------',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.start),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Total Fee : ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                              Text(
                                  // (orderModel.walletAmount != "0" &&
                                  //         orderModel.walletAmount != "0.00" &&
                                  //         orderModel.walletAmount != "" &&
                                  //         orderModel.paymentMethod
                                  //                 .toLowerCase() !=
                                  //             "wallet" &&
                                  //         orderModel.paymentMethod ==
                                  //             "cash_on_delivery")
                                  //     ? (orderModel.orderAmount -
                                  //             num.parse(
                                  //                 orderModel.walletAmount))
                                  //         .toString()
                                  //     : orderModel.orderAmount.toString(),
                                  orderModel.deliveryBoytotalFee.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black54)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),

                  // Container(
                  //   height: 20,
                  //   child:
                  //
                  //   Expanded(
                  //     flex: 2,
                  //     child:
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child:
                  //           Row(
                  //             children: [
                  //               Image.asset(Images.user,width: 12,height: 12,),
                  //               SizedBox(width: 2,),
                  //               Text('${orderModel.restaurantName}', style: TextStyle(fontSize: 12,color: Colors.black54)),
                  //             ],
                  //           ),
                  //         ),
                  //         VerticalDivider(
                  //           thickness: 0.5,
                  //           color: Colors.grey,
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child:
                  //           Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Image.asset(Images.user,width: 12,height: 12,),
                  //               SizedBox(width: 2,),
                  //               Text('${orderModel.deliveryAddress.contactPersonName}', style: TextStyle(fontSize: 12,color: Colors.black54)),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   height: 60,
                  //   child:
                  //   Expanded(
                  //     flex: 2,
                  //     child:
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child:
                  //           Row(
                  //             children: [
                  //               Image.asset(Images.location_marker,width: 12,height: 12,color: Colors.black,),
                  //               SizedBox(width: 2,),
                  //               Flexible(child: Text('${orderModel.restaurantAddress}', style: TextStyle(fontSize: 12,color: Colors.black54),softWrap: true,overflow: TextOverflow.visible),)
                  //             ],
                  //           ),
                  //         ),
                  //         VerticalDivider(
                  //           thickness: 0.5,
                  //           color: Colors.grey,
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child:
                  //           Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Image.asset(Images.location_marker,width: 12,height: 12,color: Colors.black),
                  //               SizedBox(width: 2,),
                  //               Flexible(child: Text('${orderModel.deliveryAddress.address}', style: TextStyle(fontSize: 12,color: Colors.black54),softWrap: true,overflow: TextOverflow.visible),)
                  //             ],
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ])),
            // showStatus ? Container(
            //   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).primaryColor,
            //     borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            //   ),
            //   alignment: Alignment.center,
            //   child: Text(
            //     orderModel.orderStatus.toUpperCase(),
            //     style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
            //   ),
            // ) : Text(
            //   '${orderModel.detailsCount} ${orderModel.detailsCount < 2 ? 'item'.tr : 'items'.tr}',
            //   style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
            // ),

            // showStatus ? SizedBox() : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),
          ])),
    );
  }
}

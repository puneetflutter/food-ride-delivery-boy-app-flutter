import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../../../controller/order_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../main.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/confirmation_dialog.dart';
import '../../../base/custom_button.dart';
import '../../order/order_details_screen.dart';
import '../../request/order_request_screen.dart';

class NewOrderDilog extends StatefulWidget {
  final int orderId;
  // final onTap;
  const NewOrderDilog({super.key,

    required this.orderId,
    // @required this.onTap
  })  ;

  @override
  State<NewOrderDilog> createState() => _NewOrderDilogState();
}

// Charvani
class _NewOrderDilogState extends State<NewOrderDilog> {
  final OrderController orderController = Get.put(OrderController());
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    audio.dispose();
  }

  final audio = AudioPlayer();

  void _startAlarm() {
    audio.play(AssetSource("notification.mp3"));
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // _audio.play('notification.mp3');
      audio.play(AssetSource("notification.mp3"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(Images.notification_in,
              height: 60, color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              'new_order_request_from_a_customer'.tr,
              textAlign: TextAlign.center,
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      backgroundColor: Colors.red,
                      height: 40,
                      buttonText: "Ignore",
                      onPressed: () {
                        print("i am in ignore fun");
                        if (mounted) {
                          setState(() {
                            audio.stop();

                            _timer?.cancel();
                          });

                          Get.back();
                        }
                      })),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: CustomButton(
                      height: 40,
                      buttonText: 'View',
                      onPressed: () async {
                        if (mounted) {
                          setState(() {
                            audio.stop();
                            _timer?.cancel();
                          });
                        }
                        Get.back();
                        // _navigateRequestPage();
                        Get.offAll(() => OrderRequestScreen(
                              // onTap: () => _setPage(0),
                              from: "noti",
                              orderId: widget.orderId.toString(), onTap: (){},
                            ));
                      })),
            ],
          ),
        ]),
      ),
    );
  }
}

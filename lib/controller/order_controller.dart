import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/model/body/record_location_body.dart';
import 'package:efood_multivendor_driver/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_driver/data/model/response/ignore_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/data/repository/order_repo.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo? orderRepo;
  OrderController({this.orderRepo});
  RxBool orderLoading = false.obs;

  late List<OrderModel> _allOrderList;
 late List<OrderModel> _currentOrderList;
  late List<OrderModel> _deliveredOrderList;
  late List<OrderModel> _completedOrderList;
  late List<OrderModel> _latestOrderList;
 late  List<OrderDetailsModel> _orderDetailsModel;
late  List<IgnoreModel> _ignoredRequests = [];
  bool _isLoading = false;
  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1, altitudeAccuracy: 0, headingAccuracy: 0);
  Placemark _placeMark = Placemark(
      name: 'Unknown',
      subAdministrativeArea: 'Location',
      isoCountryCode: 'Found');
  String _otp = '';
  bool _paginate = false;
  late int _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  late OrderModel _orderModel;

  List<OrderModel> get allOrderList => _allOrderList;
  List<OrderModel> get currentOrderList => _currentOrderList;
  List<OrderModel> get deliveredOrderList => _deliveredOrderList;
  List<OrderModel> get completedOrderList => _completedOrderList;
  List<OrderModel> get latestOrderList => _latestOrderList;
  List<OrderDetailsModel> get orderDetailsModel => _orderDetailsModel;
  bool get isLoading => _isLoading;
  Position get position => _position;
  Placemark get placeMark => _placeMark;
  String get address =>
      '${_placeMark.name} ${_placeMark.subAdministrativeArea} ${_placeMark.isoCountryCode}';
  String get otp => _otp;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;
  OrderModel get orderModel => _orderModel;

  Future<void> getAllOrders() async {
    Response response = await Get.find<OrderRepo>().getAllOrders();
    if (response.statusCode == 200) {
      _allOrderList = [];
      response.body
          .forEach((order) => _allOrderList.add(OrderModel.fromJson(order)));
      _deliveredOrderList = [];
      _allOrderList.forEach((order) {
        if (order.orderStatus == 'delivered') {
          _deliveredOrderList.add(order);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCompletedOrders(int offset) async {
    if (offset == 1) {
      _offsetList = [];
      _offset = 1;
      _completedOrderList.clear();
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response =
          await Get.find<OrderRepo>().getCompletedOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _completedOrderList = [];
        }
        _completedOrderList
            .addAll(PaginatedOrderModel.fromJson(response.body).orders as Iterable<OrderModel>);
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize!;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<void> getCurrentOrders() async {
    // Response response = await Get.find<OrderRepo>().getCurrentOrders();
    Response response = await Get.find<OrderRepo>().getCurrentOrders();
    if (response.statusCode == 200) {
      _currentOrderList = [];
      response.body.forEach(
          (order) => _currentOrderList.add(OrderModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrder(OrderModel orderModel) {
    print("from");
    _orderModel = orderModel;
  }

  Future<void> getOrderWithId(int orderId) async {
    print("from 333");
    Response response = await Get.find<OrderRepo>().getOrderWithId(orderId);
    if (response.statusCode == 200) {
      _orderModel = OrderModel.fromJson(response.body);
      print('order model : ${_orderModel.toJson()}');
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  clearFun() {
    print("in cleara");
    if (_latestOrderList != null) {
      _latestOrderList.clear();
      print("cheking after clear llen:  ${_latestOrderList.length}");
    }
    update();
  }

  getLatestOrders() async {
    Response response = await Get.find<OrderRepo>().getLatestOrdersss();
    orderLoading.value = true;
    // Response response = await Get.find<OrderRepo>().getLatestOrdersss();
    print("resbody....${response.body}");
    if (response.statusCode == 200) {
      if (response.body != null) {
        print("kkkkkkkkkkk");
        // List<OrderModel> _latestOrderList = [];
        clearFun();
        _latestOrderList = [];
        List<int> _ignoredIdList = [];
        _ignoredRequests.forEach((ignore) {
          print("oooo");
          _ignoredIdList.add(ignore.id ??0);
        });
        response.body.forEach((order) {
          print("llll");
          if (!_ignoredIdList.contains(OrderModel.fromJson(order).id)) {
            print("ggggg");
            _latestOrderList.add(OrderModel.fromJson(order));
            print("uuuuuu...${_latestOrderList.length}");
            update();
          }
        });
      }
    } else {
      ApiChecker.checkApi(response);
    }

    orderLoading.value = false;

    update();

    return response.body;
  }

  Future<void> recordLocation(RecordLocationBody recordLocationBody) async {
    Response response =
        await Get.find<OrderRepo>().recordLocation(recordLocationBody);
    if (response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<bool> updateOrderStatus(int index, String status,
      {bool back = false}) async {
    _isLoading = true;
    update();
    UpdateStatusBody _updateStatusBody = UpdateStatusBody(
      orderId: _currentOrderList[index].id,
      status: status,
      otp: status == 'delivered' ? _otp : null,
    );
    Response response =
        await Get.find<OrderRepo>().updateOrderStatus(_updateStatusBody);
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      if (back) {
        Get.back();
      }
      _currentOrderList[index].orderStatus = status;
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<void> updatePaymentStatus(int index, String status) async {
    _isLoading = true;
    update();
    UpdateStatusBody _updateStatusBody =
        UpdateStatusBody(orderId: _currentOrderList[index].id, status: status);
    Response response =
        await Get.find<OrderRepo>().updatePaymentStatus(_updateStatusBody);
    if (response.statusCode == 200) {
      _currentOrderList[index].paymentStatus = status;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getOrderDetails(int orderID) async {
    print("from 22");
    _orderDetailsModel.clear();
    Response response = await Get.find<OrderRepo>().getOrderDetails(orderID);
    if (response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body.forEach((orderDetails) =>
          _orderDetailsModel.add(OrderDetailsModel.fromJson(orderDetails)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<bool?>? acceptOrder(
      int orderID, int index, OrderModel orderModel, String from) async {
    print("coming ordermodel is...$orderModel");
    _isLoading = true;
    update();
    Response response = await Get.find<OrderRepo>().acceptOrder(orderID);
    Get.back();
    bool? _isSuccess;
    print("accepted status code....${response.statusCode}");
    print("accepted response is.....${response.body}");

    if (response.statusCode == 200) {
      print("accepted response is.....${response.body}");
      if (response.body != null) {
        _latestOrderList.removeAt(index);

        if (orderModel != null && _currentOrderList != null) {
          _currentOrderList.add(orderModel);
        }
        _isSuccess = true;
      }
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }

    _isLoading = false;
    update();
    return _isSuccess;
  }

//charvani
  Future<bool> acceptNewOrder(
    int orderID,
  ) async {
    _isLoading = true;
    update();
    Response response = await Get.find<OrderRepo>().acceptOrder(orderID);
    print("charvani checking accepet res...$response");
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<bool> ReturnOrderRequest(
      String orderID, String id, String reason) async {
    _isLoading = true;
    update();
    Response response =
        await Get.find<OrderRepo>().getReturnRequest(orderID, id, reason);
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      // _latestOrderList.removeAt(index);
      // _currentOrderList.add(orderModel);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<bool> ReturnOrderComplete(String orderID, String id) async {
    _isLoading = true;
    update();
    Response response =
        await Get.find<OrderRepo>().ReturnOrderComplete(orderID, id);
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      // _latestOrderList.removeAt(index);
      // _currentOrderList.add(orderModel);
      _isSuccess = true;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  void getIgnoreList() {
    _ignoredRequests = [];
    _ignoredRequests.addAll(Get.find<OrderRepo>().getIgnoreList());
  }

  void ignoreOrder(int index) {
    _ignoredRequests
        .add(IgnoreModel(id: _latestOrderList[index].id, time: DateTime.now()));
    _latestOrderList.removeAt(index);
    // orderRepo.setIgnoreList(_ignoredRequests);
    Get.find<OrderRepo>().setIgnoreList(_ignoredRequests);
    update();
  }

  void removeFromIgnoreList() async {
    List<IgnoreModel> _tempList = [];
    _tempList.addAll(_ignoredRequests);
    for (int index = 0; index < _tempList.length; index++) {
      if (Get.find<SplashController>()
              .currentTime
              .difference(_tempList[index].time??DateTime.now())
              .inMinutes >
          10) {
        _tempList.removeAt(index);
      }
    }
    _ignoredRequests = [];
    _ignoredRequests.addAll(_tempList);
    await Get.find<OrderRepo>().setIgnoreList(_ignoredRequests);
  }

  Future<void> getCurrentLocation() async {
    Position _currentPosition = await Geolocator.getCurrentPosition();
    if (!GetPlatform.isWeb) {
      try {
        List<Placemark> _placeMarks = await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);
        _placeMark = _placeMarks.first;
      } catch (e) {}
    }
    _position = _currentPosition;
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if (otp != '') {
      update();
    }
  }
}

class PaginatedOrderModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<OrderModel>? orders;

  PaginatedOrderModel({this.totalSize, this.limit, this.offset, this.orders});

  PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(new OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.orders != null) {
      data['orders'] = this.orders?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderModel {
  int? id;
  int? userId;
  String? walletAmount;
  double? orderAmount;
  double? couponDiscountAmount;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  String? transactionReference;
  int? deliveryAddressId;
  int? deliveryManId;
  String? orderType;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  double? packingCharges;
  double? originalDeliveryCharge;
  double? dmTips;
  String? scheduleAt;
  String? restaurantName;
  String? restaurantAddress;
  String? restaurantLat;
  String? restaurantLng;
  String? restaurantLogo;
  String? restaurantPhone;
  String? restaurantDeliveryTime;
  int? detailsCount;
  String? orderNote;
  DeliveryAddress? deliveryAddress;
  OrderDetails? orderDetails;
  Customer? customer;
  int? processingTime;
  String? distanceKms;
  int? distanceFare;
  int? awt_return_order_status;
  String? awt_return_order_reason;
  dynamic deliveryBoyBaseFee;
  dynamic deliveryBoyExtraFee;
  dynamic deliveryBoytotalFee;

  OrderModel(
      {this.id,
      this.userId,
      this.walletAmount,
      this.orderAmount,
      this.couponDiscountAmount,
      this.paymentStatus,
      this.orderStatus,
      this.totalTaxAmount,
      this.paymentMethod,
      this.transactionReference,
      this.deliveryAddressId,
      this.deliveryManId,
      this.orderType,
      this.restaurantId,
      this.createdAt,
      this.updatedAt,
      this.deliveryCharge,
      this.originalDeliveryCharge,
      this.dmTips,
      this.scheduleAt,
      this.restaurantName,
      this.restaurantAddress,
      this.restaurantLat,
      this.restaurantLng,
      this.restaurantLogo,
      this.restaurantPhone,
      this.restaurantDeliveryTime,
      this.detailsCount,
      this.orderNote,
      this.deliveryAddress,
      this.orderDetails,
      this.customer,
      this.processingTime,
      this.distanceKms,
      this.distanceFare,
      this.packingCharges,
      this.awt_return_order_status,
      this.awt_return_order_reason,
      this.deliveryBoyBaseFee,
      this.deliveryBoyExtraFee,
      this.deliveryBoytotalFee});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    walletAmount = json['wallet_amount'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    orderType = json['order_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'].toDouble();
    packingCharges = json['awt_order_pckg_charge'].toDouble();
    originalDeliveryCharge = json['original_delivery_charge'].toDouble();
    dmTips = json['dm_tips'].toDouble();
    scheduleAt = json['schedule_at'];
    restaurantName = json['restaurant_name'];
    restaurantAddress = json['restaurant_address'];
    restaurantLat = json['restaurant_lat'];
    restaurantLng = json['restaurant_lng'];
    restaurantLogo = json['restaurant_logo'];
    restaurantPhone = json['restaurant_phone'];
    restaurantDeliveryTime = json['restaurant_delivery_time'];
    detailsCount = json['details_count'];
    orderNote = json['order_note'];
    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    processingTime = json['processing_time'];
    distanceKms = json['awt_distance_kms'];
    distanceFare = json['awt_distance_fare'];
    awt_return_order_status = json['awt_return_order_status'];
    awt_return_order_reason = json['awt_return_order_reason'];
    deliveryBoyBaseFee = json['awt_delivery_boy_base_fare'];
    deliveryBoyExtraFee = json['awt_delivery_boy_extra_fare'];
    deliveryBoytotalFee = json['awt_delivery_boy_total_fare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_amount'] = this.orderAmount;
    data['wallet_amount'] = this.walletAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['delivery_address_id'] = this.deliveryAddressId;
    data['delivery_man_id'] = this.deliveryManId;
    data['order_type'] = this.orderType;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['awt_order_pckg_charge'] = this.packingCharges;
    data['original_delivery_charge'] = this.originalDeliveryCharge;
    data['dm_tips'] = this.dmTips;
    data['schedule_at'] = this.scheduleAt;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_address'] = this.restaurantAddress;
    data['restaurant_lat'] = this.restaurantLat;
    data['restaurant_lng'] = this.restaurantLng;
    data['restaurant_logo'] = this.restaurantLogo;
    data['restaurant_phone'] = this.restaurantPhone;
    data['restaurant_delivery_time'] = this.restaurantDeliveryTime;
    data['details_count'] = this.detailsCount;
    data['order_note'] = this.orderNote;
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress?.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails?.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer?.toJson();
    }
    data['processing_time'] = this.processingTime;
    data['awt_distance_fare'] = this.distanceFare;
    data['awt_distance_kms'] = this.distanceKms;
    data['awt_return_order_status'] = this.awt_return_order_status;
    data['awt_return_order_reason'] = this.awt_return_order_reason;
    return data;
  }
}

class DeliveryAddress {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? userId;
  String? contactPersonName;
  String? createdAt;
  String? updatedAt;
  int? zoneId;
  String? streetNumber;
  String? house;
  String? floor;

  DeliveryAddress(
      {this.id,
      this.addressType,
      this.contactPersonNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.userId,
      this.contactPersonName,
      this.createdAt,
      this.updatedAt,
      this.zoneId,
      this.streetNumber,
      this.house,
      this.floor});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    userId = json['user_id'];
    contactPersonName = json['contact_person_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['user_id'] = this.userId;
    data['contact_person_name'] = this.contactPersonName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['zone_id'] = this.zoneId;
    data['road'] = this.streetNumber;
    data['house'] = this.house;
    data['floor'] = this.floor;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? cmFirebaseToken;

  Customer(
      {this.id,
      this.fName,
      this.lName,
      this.phone,
      this.email,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.cmFirebaseToken});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    return data;
  }
}

class OrderDetails {
  // int id;
  // int foodId;
  // int orderId;
  int? price;
  // String foodDetails;
  // String variation;
  // String addOns;
  dynamic discountOnFood;
  // String discountType;
  // int quantity;
  int? taxAmount;
  // String variant;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic itemCampaignId;
  // int totalAddOnPrice;
  // String awtOfferFoodStr;
  // String awtOfferFoodType;

  OrderDetails({
    // this.id,
    // this.foodId,
    // this.orderId,
    this.price,
    // this.foodDetails,
    // this.variation,
    // this.addOns,
    this.discountOnFood,
    // this.discountType,
    // this.quantity,
    this.taxAmount,
    // this.variant,
    // this.createdAt,
    // this.updatedAt,
    // this.itemCampaignId,
    // this.totalAddOnPrice,
    // this.awtOfferFoodStr,
    // this.awtOfferFoodType,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        // id: json["id"],
        // foodId: json["food_id"],
        // orderId: json["order_id"],
        price: json["price"],
        // foodDetails: json["food_details"],
        // variation: json["variation"],
        // addOns: json["add_ons"],
        discountOnFood: json["discount_on_food"],
        // discountType: json["discount_type"],
        // quantity: json["quantity"],
        taxAmount: json["tax_amount"],
        // variant: json["variant"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // itemCampaignId: json["item_campaign_id"],
        // totalAddOnPrice: json["total_add_on_price"],
        // awtOfferFoodStr: json["awt_offer_food_str"],
        // awtOfferFoodType: json["awt_offer_food_type"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        // "food_id": foodId,
        // "order_id": orderId,
        "price": price,
        // "food_details": foodDetails,
        // "variation": variation,
        // "add_ons": addOns,
        "discount_on_food": discountOnFood,
        // "discount_type": discountType,
        // "quantity": quantity,
        "tax_amount": taxAmount,
        // "variant": variant,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        // "item_campaign_id": itemCampaignId,
        // "total_add_on_price": totalAddOnPrice,
        // "awt_offer_food_str": awtOfferFoodStr,
        // "awt_offer_food_type": awtOfferFoodType,
      };
}

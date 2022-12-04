// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:assignment_app/models/product_model.dart';

class OrderModel {
  final String customerName;
  final String deliveryAddress;
  final String orderTakerName;
  final String deliveryDate;
  final List<OrderItemsModel> orderItemsModel;
  OrderModel({
    required this.customerName,
    required this.deliveryAddress,
    required this.orderTakerName,
    required this.deliveryDate,
    required this.orderItemsModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,
      'orderTakerName': orderTakerName,
      'deliveryDate': deliveryDate,
      'orderItemsModel': orderItemsModel.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      customerName: map['customerName'] as String,
      deliveryAddress: map['deliveryAddress'] as String,
      orderTakerName: map['orderTakerName'] as String,
      deliveryDate: map['deliveryDate'] as String,
      orderItemsModel: List<OrderItemsModel>.from(
        (map['orderItemsModel'] as List<int>).map<OrderItemsModel>(
          (x) => OrderItemsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderItemsModel {
  final int orderID;
  final ProductModel productModel;
  double quantity;
  double total;
  int sortNumber;
  OrderItemsModel({
    required this.orderID,
    required this.productModel,
    required this.quantity,
    required this.total,
    required this.sortNumber,
  });

  @override
  String toString() {
    return 'OrderItemsModel(orderID: $orderID, productModel: $productModel, quantity: $quantity, total: $total, sortNumber: $sortNumber)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderID': orderID,
      'productModel': productModel.toMap(),
      'quantity': quantity,
      'total': total,
      'sortNumber': sortNumber,
    };
  }

  factory OrderItemsModel.fromMap(Map<String, dynamic> map) {
    return OrderItemsModel(
      orderID: map['orderID'] as int,
      productModel:
          ProductModel.fromMap(map['productModel'] as Map<String, dynamic>),
      quantity: map['quantity'] as double,
      total: map['total'] as double,
      sortNumber: map['sortNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemsModel.fromJson(String source) =>
      OrderItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  OrderItemsModel copyWith({
    int? orderID,
    ProductModel? productModel,
    double? quantity,
    double? total,
    int? sortNumber,
  }) {
    return OrderItemsModel(
      orderID: orderID ?? this.orderID,
      productModel: productModel ?? this.productModel,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      sortNumber: sortNumber ?? this.sortNumber,
    );
  }
}

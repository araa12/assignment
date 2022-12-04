// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  String? productName;
  String unit;
  double price;

  ProductModel(
      {required this.productName, required this.unit, required this.price});

  @override
  String toString() =>
      'ProductModel(productName: $productName, unit: $unit, price: $price)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'unit': unit,
      'price': price,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        productName: map['productName'],
        price: map['price'],
        unit: map['unit']);
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ProductModel copyWith({
    String? productName,
    String? unit,
    double? price,
  }) {
    return ProductModel(
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      price: price ?? this.price,
    );
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.unit == unit &&
        other.price == price;
  }

  @override
  int get hashCode => productName.hashCode ^ unit.hashCode ^ price.hashCode;
}

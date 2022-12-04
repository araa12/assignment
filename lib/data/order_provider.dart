import 'package:assignment_app/api.dart';
import 'package:assignment_app/models/order_model.dart';
import 'package:assignment_app/models/product_model.dart';
import 'package:get/get.dart';

class OrderProvider extends GetxController {
  final List<OrderItemsModel> orders = <OrderItemsModel>[].obs;
  final totalRS = 0.0.obs;
  final productsName = ['Onion Type A', 'Tomato Afghani', 'Potato Siyani'];
  final currentCellIndex = 0.obs;

  final sortColumn = 0.obs;

  resolveSort() {
    int duplicateDetectedCount = -1;
    for (OrderItemsModel item in orders) {
      for (OrderItemsModel innerItem in orders) {
        if (item.sortNumber == innerItem.sortNumber) {
          duplicateDetectedCount++;
          if (duplicateDetectedCount == 1) {
            sortColumn.value = 1;
          } else {
            sortColumn.value = 1;
          }
        }
      }
    }
  }

  getTotal() {
    double total = 0;
    orders.forEach((element) {
      total += element.total;
    });

    totalRS.value = total;
  }

  Future<bool> saveOrder(OrderModel orderModel) async {
    try {
      final result = await Repository().saveOrder(orderModel);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    orders.addAll([
      OrderItemsModel(
          orderID: 1,
          productModel:
              ProductModel(productName: 'Onion Type A', unit: 'Kg', price: 83),
          quantity: 1,
          total: 83,
          sortNumber: 1),
      OrderItemsModel(
          orderID: 2,
          productModel: ProductModel(
              productName: 'Tomato Afghani', unit: 'Kg', price: 73),
          quantity: 1,
          total: 73,
          sortNumber: 1),
      OrderItemsModel(
          orderID: 2,
          productModel: ProductModel(
              productName: 'Tomato Afghani', unit: 'Kg', price: 73),
          quantity: 1,
          total: 73,
          sortNumber: 1),
      OrderItemsModel(
          orderID: 3,
          productModel: ProductModel(
              productName: 'Potato Siyani', unit: 'dozens', price: 43),
          quantity: 1,
          total: 43,
          sortNumber: 1),
      OrderItemsModel(
          orderID: 3,
          productModel: ProductModel(
              productName: 'Potato Siyani', unit: 'dozens', price: 43),
          quantity: 1,
          total: 43,
          sortNumber: 1)
    ]);

    getTotal();
  }
}

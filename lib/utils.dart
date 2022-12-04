import 'package:assignment_app/data/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'models/order_model.dart';

class Utils {
  final controller = Get.put(OrderProvider());
  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<PlutoRow> getAllRows() {
    return controller.orders
        .map(
          (order) => PlutoRow(cells: {
            'id': PlutoCell(
              value: order.sortNumber,
            ),
            'product_name': PlutoCell(value: order.productModel.productName),
            'quantity': PlutoCell(value: order.quantity),
            'unit': PlutoCell(value: order.productModel.unit),
            'unit_price': PlutoCell(value: order.productModel.price),
            'total':
                PlutoCell(value: order.quantity * order.productModel.price),
          }),
        )
        .toList();
  }

  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
        title: 'Serial',
        field: 'id',
        type: PlutoColumnType.number(),
        enableSorting: true),

    /// Select Column definition
    PlutoColumn(
      title: 'Product Name',
      field: 'product_name',
      enableSorting: true,
      type: PlutoColumnType.select(
          ['Onion Type A', 'Tomato Afghani', 'Potato Siyani']),
    ),

    PlutoColumn(
      title: 'Quantity',
      field: 'quantity',
      type: PlutoColumnType.number(),
    ),

    PlutoColumn(
      title: 'Unit',
      field: 'unit',
      type: PlutoColumnType.text(),
    ),

    PlutoColumn(
      title: 'Unit Price',
      field: 'unit_price',
      type: PlutoColumnType.text(),
    ),

    PlutoColumn(
      title: 'Total',
      field: 'total',
      type: PlutoColumnType.text(),
    ),
  ];
}

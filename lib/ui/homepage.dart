// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assignment_app/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment_app/data/order_provider.dart';
import 'package:assignment_app/models/order_model.dart';
import 'package:assignment_app/models/product_model.dart';
import 'package:get_storage/get_storage.dart';

final productsName = ['Onion Type A', 'Tomato Afghani', 'Potato Siyani'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController customerNameController;
  late final TextEditingController customerAddressController;
  late final TextEditingController orderTakerController;
  late final TextEditingController deliveryDateController;
  late final TextEditingController totalController;
  late final TextEditingController productUnitController;
  DateTime selectedDate = DateTime.now();

  final formKey = GlobalKey<FormState>();

  int currentCellIndex = 0;
  int total = 0;
  bool loading = false;

  @override
  void initState() {
    customerNameController = TextEditingController();
    customerAddressController = TextEditingController();
    orderTakerController = TextEditingController();
    deliveryDateController = TextEditingController();
    totalController = TextEditingController();
    productUnitController = TextEditingController();

    initControllers();

    super.initState();
  }

  initControllers() {
    customerNameController.text = GetStorage().read('customerName') ?? '';
    customerAddressController.text = GetStorage().read('customerAddress') ?? '';
    orderTakerController.text = GetStorage().read('orderTakerName') ?? '';
  }

  @override
  void dispose() {
    customerAddressController.dispose();
    customerAddressController.dispose();
    deliveryDateController.dispose();
    orderTakerController.dispose();
    super.dispose();
  }

  final ordersController = Get.put(OrderProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  TextFeildWithLabel(
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      controller: customerNameController,
                      labeltext: 'Customer Name:'),
                  SizedBox(
                    width: 20,
                  ),
                  TextFeildWithLabel(
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Please Enter Address';
                        }
                        return null;
                      },
                      controller: customerAddressController,
                      labeltext: 'Customer Address:'),
                ],
              ),
              Row(
                children: [
                  TextFeildWithLabel(
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Date cant be empty';
                        }
                        return null;
                      },
                      controller: deliveryDateController,
                      labeltext: 'Delivery Date: '),
                  SizedBox(
                    width: 20,
                  ),
                  TextFeildWithLabel(
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Order Taker cant be empty';
                        }
                        return null;
                      },
                      controller: orderTakerController,
                      labeltext: 'Order Taker: '),
                ],
              ),
              IconButton(
                  onPressed: () {
                    final order = OrderItemsModel(
                        orderID: 23,
                        productModel:
                            ProductModel(price: 0, productName: null, unit: ''),
                        quantity: 1,
                        total: 0,
                        sortNumber: ordersController.orders.length + 1);

                    ordersController.orders.add(order);
                  },
                  icon: const Icon(Icons.add)),
              Obx(
                () => Expanded(
                  child: ListView(
                    children: [
                      _createDataTable(),
                      Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Total RS : ${ordersController.totalRS}',
                            style: const TextStyle(
                                fontSize: 29, color: Colors.purple),
                          )),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final OrderModel orderModel = OrderModel(
                                customerName: customerNameController.text,
                                deliveryAddress: customerAddressController.text,
                                orderTakerName: orderTakerController.text,
                                orderItemsModel: ordersController.orders,
                                deliveryDate: deliveryDateController.text);

                            if (ordersController.orders.isEmpty) {
                              Get.snackbar(
                                  'Cant process', 'Please Add Products',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.purple,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            Get.dialog(createDialog(orderModel));
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: 90,
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                                child: Text(
                              'Order Now',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      border: TableBorder.all(color: Colors.black),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: const Text('Serial'),
        onSort: (columnIndex, as) {
          if (as) {
            ordersController.orders
                .sort((a, b) => a.sortNumber.compareTo(b.sortNumber));
          } else {
            ordersController.orders
                .sort((a, b) => b.sortNumber.compareTo(a.sortNumber));
          }

          ordersController.resolveSort();
        },
      ),
      DataColumn(
        label: Text('Prodcut Name'),
        onSort: (columnIndex, ascending) {
          setState(() {
            if (ordersController.sortColumn.value == 1) {
              ordersController.orders.sort((a, b) => a.productModel.productName!
                  .compareTo(b.productModel.productName!));

              ordersController.resolveSort();
            }
          });
        },
      ),
      const DataColumn(label: Text('Product Quantity'), numeric: true),
      const DataColumn(label: Text('Unit')),
      const DataColumn(label: Text('Unit Price'), numeric: true),
      const DataColumn(label: Text('Total'), numeric: true),
    ];
  }

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  List<DataRow> _createRows() {
    return List<DataRow>.generate(ordersController.orders.length, (index) {
      final currentCell = ordersController.orders[index];
      ordersController.currentCellIndex.value = index;
      return DataRow(cells: [
        DataCell(TextFormField(
          initialValue: currentCell.sortNumber.toString(),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            currentCell.sortNumber = int.parse(value);
            setState(() {});
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        )),
        DataCell(DropdownButton<String>(
            onChanged: (changedValue) async {
              currentCell.productModel.productName = changedValue;
              print(changedValue!.toLowerCase().tr);
              switch (changedValue.toLowerCase().tr) {
                case 'onion type a':
                  ordersController.orders[currentCellIndex].productModel.unit =
                      'Kg';
                  ordersController.orders[currentCellIndex].productModel.price =
                      342;

                  print(' this Case Calls');

                  setState(() {});
                  break;
              }

              setState(() {});
            },
            value: currentCell.productModel.productName,
            items: productsName.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList())),
        DataCell(TextFormField(
          initialValue: currentCell.quantity.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (v) {
            currentCell.quantity = double.parse(v);
            currentCell.total =
                currentCell.quantity * currentCell.productModel.price;
            ordersController.getTotal.call();
            setState(() {});
          },
        )),
        DataCell(TextFormField(
          initialValue: currentCell.productModel.unit,
          onChanged: (value) {
            currentCell.productModel.unit = value;
            print('Unit Updated');
            setState(() {});
          },
          decoration: const InputDecoration(border: InputBorder.none),
        )),
        DataCell(TextFormField(
          keyboardType: TextInputType.number,
          initialValue: currentCell.productModel.price.toString(),
          onChanged: (v) {
            currentCell.productModel.price = double.parse(v);
            currentCell.total =
                currentCell.quantity * currentCell.productModel.price.round();
            ordersController.getTotal.call();

            setState(() {});
          },
          decoration: const InputDecoration(border: InputBorder.none),
        )),
        DataCell(Text(currentCell.total.toString()))
      ]);
    });
  }

  createDialog(OrderModel orderModel) {
    return StatefulBuilder(builder: (context, innserSTate) {
      return Dialog(
        child: Container(
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Total Price is ${ordersController.totalRS}',
                textScaleFactor: 0.8,
                style: const TextStyle(
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel')),
                    ordersController.totalRS > 0
                        ? loading
                            ? const SizedBox(
                                height: 50,
                                width: 50,
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : TextButton(
                                onPressed: () async {
                                  LocalStorage().saveValue(
                                      key: 'customerName',
                                      value: customerNameController.text);

                                  LocalStorage().saveValue(
                                      key: 'customerAddress',
                                      value: customerAddressController.text);

                                  LocalStorage().saveValue(
                                      key: 'orderTakerName',
                                      value: orderTakerController.text);

                                  innserSTate(() => loading = true);

                                  ordersController
                                      .saveOrder(orderModel)
                                      .then((value) => innserSTate(() {
                                            loading = false;
                                            Get.back();
                                          }));
                                },
                                child: const Text('Confirm'))
                        : const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + 2));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deliveryDateController.text = selectedDate.toString();
      });
    }
  }
  // Widget labelText({required String label}) => Text(label);
}

typedef FieldValidator = String? Function(String?)?;

class TextFeildWithLabel extends StatelessWidget {
  const TextFeildWithLabel(
      {super.key,
      required this.controller,
      required this.labeltext,
      this.readOnly = false,
      this.onTap,
      this.validator});
  final String labeltext;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final FieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: [
          SizedBox(
              width: 130,
              child: Text(
                labeltext,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 200,
            child: TextFormField(
              onTap: onTap,
              validator: validator,
              controller: controller,
              readOnly: readOnly,
              enableIMEPersonalizedLearning: true,
              enableSuggestions: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:assignment_app/models/order_model.dart';
import 'package:http/http.dart' as http;

const BASE_URL = 'http://ec2-44-210-117-115.compute-1.amazonaws.com:4000/order';

class Repository {
  Future<http.Response> saveOrder(OrderModel orderM) async {
    print(orderM);
    final body = orderM.toJson();
    print(body);
    final result = await http.post(Uri.parse(BASE_URL),
        headers: {'Content-Type': 'application/json'}, body: body);

    print(jsonDecode(result.body));
    return result;
  }
}

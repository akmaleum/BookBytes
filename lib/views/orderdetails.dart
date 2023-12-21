import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../models/orderdetails.dart';
import '../models/user.dart';
import '../shared/myserverconfig.dart';

class OrderDetailsPage extends StatefulWidget {
  final User user;
  final Order order;

  const OrderDetailsPage({super.key, required this.user, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<OrderDetails> orderDetailsList = <OrderDetails>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrderDetails();
  }

  late double screenWidth, screenHeight;
  final f = DateFormat('dd-MM-yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.2,
            width: screenWidth,
            child: Column(children: [
              const Text(
                "Buyer Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("Name: ${widget.order.userName}"),
              Text("Email:${widget.order.userEmail}"),
              Text(
                  "Order Date ${f.format(DateTime.parse(widget.order.orderDate.toString()))}"),
            ]),
          ),
          Expanded(
            child: Container(
              color: Colors.amber,
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void loadOrderDetails() {
    // String userid = widget.user.userid.toString();
    String orderid = widget.order.orderId.toString();
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes/php/load_ordersDetails.php?orderid=$orderid"),
    )
        .then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          orderDetailsList.clear();
          data['data']['orderdetails'].forEach((v) {
            orderDetailsList.add(OrderDetails.fromJson(v));
          });
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }
}

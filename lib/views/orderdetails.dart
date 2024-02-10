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
  String dropdownvalue = 'New';
  var oderstatus = [
    'New',
    'Processing',
    'Delivered',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownvalue = widget.order.orderStatus.toString();
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
          SizedBox(
            height: screenHeight * 0.15,
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
            child: orderDetailsList.isEmpty
                ? Center()
                : ListView.builder(
                    itemCount: orderDetailsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                              orderDetailsList[index].bookTitle.toString()),
                          onTap: () async {},
                          subtitle:
                              Text("RM ${orderDetailsList[index].bookPrice}"),
                          leading: const Icon(Icons.sell),
                          trailing: Text(
                              "x ${orderDetailsList[index].cartQty} unit"));
                    }),
          ),
          Container(
            height: screenHeight * 0.1,
            // color: Colors.red,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Total RM ${widget.order.orderTotal}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("Status: ${widget.order.orderStatus.toString()}"),
                  IconButton(
                      onPressed: () {
                        loadChangeDialogStatus();
                      },
                      icon: const Icon(Icons.edit))
                ]),
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
          "${MyServerConfig.server}/bookbytes_db/php/load_ordersDetails.php?orderid=$orderid"),
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

  void loadChangeDialogStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Change Order Status",
              style: TextStyle(),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButton(
                value: dropdownvalue,
                underline: const SizedBox(),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: oderstatus.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  dropdownvalue = newValue!;
                  print(dropdownvalue);
                  setState(() {});
                },
              )
            ]),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  updateOrder();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Canceled"),
                    backgroundColor: Colors.red,
                  ));
                },
              ),
            ],
          );
        });
      },
    );
  }

  void updateOrder() {
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes_db/php/update_order.php"),
        body: {
          "orderid": widget.order.orderId,
          "orderstatus": dropdownvalue,
        }).then((response) {
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}

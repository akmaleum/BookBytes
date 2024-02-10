//seller page

import 'dart:convert';
import 'dart:developer';

import 'package:bookbytes/models/order.dart';
import 'package:bookbytes/shared/mydrawer.dart';
import 'package:bookbytes/views/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../shared/myserverconfig.dart';

class OrderPage extends StatefulWidget {
  final User userdata;
  const OrderPage({super.key, required this.userdata});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orderList = <Order>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircleAvatar(backgroundImage: AssetImage('')),
                Text(
                  "Order and Sales",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          page: 'seller',
          userdata: widget.userdata,
        ),
        body: orderList.isEmpty
            ? const Center(child: Text("No Data"))
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text("Number of Order/s ${orderList.length}"),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text(orderList[index].userName.toString()),
                              onTap: () async {
                                Order order =
                                    Order.fromJson(orderList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => OrderDetailsPage(
                                              user: widget.userdata,
                                              order: order,
                                            )));
                                loadOrders();
                              },
                              subtitle:
                                  Text("RM ${orderList[index].orderTotal}"),
                              leading: Icon(Icons.sell),
                              trailing: Text(orderList[index]
                                  .orderStatus
                                  .toString()
                                  .toUpperCase()));
                        }),
                  )
                ],
              ));
  }

  void loadOrders() {
    String userid = widget.userdata.userid.toString();
    // print(
    //     "MyServerConfig.server}/bookbytes/php/load_orders.php?sellerid=$userid");
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes_db/php/load_orders.php?sellerid=$userid"),
    )
        .then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          orderList.clear();
          data['data']['orders'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }
}

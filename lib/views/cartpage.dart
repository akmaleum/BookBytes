import 'dart:convert';
import 'package:bookbytes/models/cart.dart';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared/myserverconfig.dart';

class CartPage extends StatefulWidget {
  final User userdata;

  const CartPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = <Cart>[];
  User get userdata => widget.userdata;
  double total = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      drawer: MyDrawer(
        page: "cart",
        userdata: widget.userdata,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cartList.isEmpty
              ? const Center(
                  child: Text("No items in your cart."),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 7,
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(
                                cartList[index].bookTitle.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "MYR ${cartList[index].bookPrice}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              leading: const CircleAvatar(
                                child: Icon(Icons.book, color: Colors.white),
                                backgroundColor: Colors.blueGrey,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "x ${cartList[index].cartQty} item",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever,
                                        color: Colors.red),
                                    onPressed: () async {
                                      bool confirmDelete =
                                          await confirmDeleteCartItem(index) ??
                                              false;
                                      if (confirmDelete) {
                                        deleteCartItem(index);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {},
                              contentPadding: const EdgeInsets.all(20),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "NET TOTAL",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "MYR ${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text("Proceed to Check Out"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<bool?> confirmDeleteCartItem(int index) async {
    return await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Are you sure you want to remove this item from your cart?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel delete
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirm delete
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  void deleteCartItem(int index) {
    String cartId = cartList[index].cartId.toString();

    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/delete_cart_item.php"),
      body: {'cart_id': cartId},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Item deleted successfully"),
              backgroundColor: Colors.green,
            ),
          );
          // Reload cart after deletion
          loadUserCart();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to delete item"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void loadUserCart() {
    String userid = widget.userdata.userid.toString();
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes/php/load_cart.php?userid=$userid"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          data['data']['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));

            total += double.parse(v['book_price'] * int.parse(v['cart_qty']));
          });
          print(total);
        } else {
          // Handle if no status failed
        }
      }
      isLoading = false;
      setState(() {});
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      print("Timeout");
      isLoading = false;
      setState(() {});
    });
  }
}

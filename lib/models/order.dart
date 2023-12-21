class Order {
  String? orderId;
  String? buyerId;
  String? sellerId;
  String? orderTotal;
  String? orderDate;
  String? orderStatus;
  String? userEmail;
  String? userName;

  Order(
      {this.orderId,
      this.buyerId,
      this.sellerId,
      this.orderTotal,
      this.orderDate,
      this.orderStatus,
      this.userEmail,
      this.userName});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    orderTotal = json['order_total'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    userEmail = json['user_email'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    data['order_total'] = orderTotal;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    return data;
  }
}
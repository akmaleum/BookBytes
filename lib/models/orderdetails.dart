class OrderDetails {
  String? cartId;
  String? bookId;
  String? cartQty;
  String? cartStatus;
  String? bookTitle;
  String? bookPrice;

  OrderDetails(
      {this.cartId,
      this.bookId,
      this.cartQty,
      this.cartStatus,
      this.bookTitle,
      this.bookPrice});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    bookId = json['book_id'];
    cartQty = json['cart_qty'];
    cartStatus = json['cart_status'];
    bookTitle = json['book_title'];
    bookPrice = json['book_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['book_id'] = bookId;
    data['cart_qty'] = cartQty;
    data['cart_status'] = cartStatus;
    data['book_title'] = bookTitle;
    data['book_price'] = bookPrice;
    return data;
  }
}
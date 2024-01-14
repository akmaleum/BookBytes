class Cart {
  String? cartId;
  String? sellerId;
  String? bookId;
  String? cartQty;
  String? cartStatus;
  String? cartDate;
  String? bookTitle;
  String? bookPrice;
  String? bookQty;
  String? bookStatus;

  Cart(
      {this.cartId,
      this.sellerId,
      this.bookId,
      this.cartQty,
      this.cartStatus,
      this.cartDate,
      this.bookTitle,
      this.bookPrice,
      this.bookQty,
      this.bookStatus});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    sellerId = json['seller_id'];
    bookId = json['book_id'];
    cartQty = json['cart_qty'];
    cartStatus = json['cart_status'];
    cartDate = json['cart_date'];
    bookTitle = json['book_title'];
    bookPrice = json['book_price'];
    bookQty = json['book_qty'];
    bookStatus = json['book_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['seller_id'] = sellerId;
    data['book_id'] = bookId;
    data['cart_qty'] = cartQty;
    data['cart_status'] = cartStatus;
    data['cart_date'] = cartDate;
    data['book_title'] = bookTitle;
    data['book_price'] = bookPrice;
    data['book_qty'] = bookQty;
    data['book_status'] = bookStatus;
    return data;
  }
}

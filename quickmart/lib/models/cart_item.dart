class CartItem {
  String productId;
  String productName;
  int quantity;
  double unitPrice;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double calculateTotalPrice() => quantity * unitPrice;

  // Updated factory method to handle the enriched response
  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['title'] ?? '', // Use 'title' from the API response
      quantity: map['quantity'] ?? 0,
      unitPrice: map['price']?.toDouble() ?? 0.0, // Use 'price' from the API response
    );
  }
}

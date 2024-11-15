// models/order_model.dart

class Order {
  final String orderId;
  final String serviceName;
  final String printSize;
  final int quantity;
  final double price;
  final DateTime createdAt;
  final String paymentStatus;
  final String status;

  Order({
    required this.orderId,
    required this.serviceName,
    required this.printSize,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.paymentStatus,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      serviceName: json['service_name'],
      printSize: json['print_size'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      paymentStatus: json['payment_status'],
      status: json['status'],
    );
  }
}

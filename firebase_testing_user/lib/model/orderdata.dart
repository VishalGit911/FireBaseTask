
import 'address.dart';
import 'cart.dart';

class OrderData {
  List<Cart>? cartItems;
  double? totalAmount;
  Address? address;

  OrderData({this.cartItems, this.totalAmount, this.address});
}

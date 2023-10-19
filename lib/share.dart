
class Share {
  static List<Map<String, dynamic>> cartItems = [];
  static Function updateCartItems = () {};
  static int navBarIndex = 0;

  static int cartItemsCount() {
    int n = 0;
    cartItems.forEach((element) {
      n += element['quantity'] as int;
    });
    return n;
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_food_shop_app/data/cart_model.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/auth_controller.dart';
import 'package:get/get.dart';
import '../../http/urls.dart';

class OrderListController extends GetxController {
  bool addToCart(AddToCartModel addToCartModel) {
    final result = addToCartModel.saveAddToCart(addToCartModel);
    if (result) {
      return true;
    } else {
      return false;
    }
  }




  DatabaseReference fatchDataOrder() {
    final ref = FirebaseDatabase.instance.ref('order');
    return ref;
  }

  bool updateOrder(String orderId, String status, String sellerId) {
    bool result = true;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child('order/$orderId/');
    reference.update({
      'status': status,
    }).then((_) {

      AuthController().fetchUserData(sellerId).then((value) {
        String token = value?['token'];
        String name = value?['name'];
        print(token);
        NotificationClass().createNotification(token, "Order Cancelled",
            'Order has been cancelled by ${name} order id ${UserData.id}');
      });

      return true;
    }).catchError((error) {

      return false;
    });
    return result;
  }

  bool updateOrderBySeller(String orderId, String status, String sellerId) {
    bool result = true;
    DatabaseReference reference =
    FirebaseDatabase.instance.ref().child('order/$orderId/');
    reference.update({
      'status': status,
    }).then((_) {

      AuthController().fetchUserData(sellerId).then((value) {
        String token = value?['token'];
         String shopName = value?['shopName'];
        NotificationClass().createNotification(token, "Order ${status}",
            'The order has been ${status}, order id ${UserData.id}');
      });

      return true;
    }).catchError((error) {

      return false;
    });
    return result;
  }

  bool updateCart(int qty, String id) {
    bool result = true;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("cart/${UserData.id}/${id}");
    reference.update({
      'qty': qty,
    }).then((_) {
      return true;
    }).catchError((error) {
      // Delete operation encountered an error
      // result = 'Delete operation failed: $error';
      // print(result);
      return false;
    });
    return result;
  }


}

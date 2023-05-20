import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_food_shop_app/data/cart_model.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:get/get.dart';

import '../../data/product_model.dart';

class CartController extends GetxController {
  bool addToCart(AddToCartModel addToCartModel) {
    final result = addToCartModel.saveAddToCart(addToCartModel);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  DatabaseReference addToCartFatchData(String userId) {
    final ref = FirebaseDatabase.instance.ref('cart/$userId');
    return ref;
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

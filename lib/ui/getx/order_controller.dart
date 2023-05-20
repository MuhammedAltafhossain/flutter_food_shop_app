import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/auth_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../http/urls.dart';

class OrderController extends GetxController {
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  bool orderPlaced(List<dynamic> productDetails, double totalPrice,
      String address, String phoneNumber) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    String orderId = idGenerator();
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('order/${orderId}');
    if(productDetails.length > 0){
      usersRef.set({
        "userId": UserData.id,
        "address": address,
        "phoneNumber": phoneNumber,
        "totalPrice": totalPrice,
        'status': 'Pending',
        'date': formattedDateTime,
        "product": productDetails.toList(),
        "orderId": orderId
      });
    }
    else{
      return false;
    }
    if (usersRef != null) {
      final sellerId = productDetails[0]['sellerId'];

      AuthController().fetchUserData(sellerId).then((value) {
        String token = value?['token'];
        String name = value?['name'];
        print(token);
        NotificationClass().createNotification(token, "New Order",
            'New Order Created by ${name} order id ${UserData.id}');
      });

      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("cart/${UserData.id}");
      reference.remove();

      return true;
    } else {
      return false;
    }
  }
}

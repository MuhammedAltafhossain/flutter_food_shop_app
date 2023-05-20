import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';


class AddToCartListModel {
  String? msg;
  List<AddToCartModel>? data;

  AddToCartListModel({this.msg, this.data});

  AddToCartListModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AddToCartModel>[];
      json['data'].forEach((v) {
        data!.add(AddToCartModel.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddToCartModel {
  late String? id;
  late String? sellerId;
  late String? dishName;
  late String? description;
  late double? price;
  late int? qty;
  late String? imageUrl;
  late DateTime createAt;

  AddToCartModel({this.id, this.sellerId, this.dishName, this.description, this.price, this.imageUrl, this.qty});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'dishName': dishName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'qty': qty,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'],
      sellerId: map['sellerId'],
      dishName: map['dishName'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      qty: map['qty'],
    );
  }

  bool saveAddToCart (AddToCartModel addToCarModel) {
    final DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child('cart/${UserData.id}');
    usersRef.child(addToCarModel.id!).set(addToCarModel.toJson());

    if (usersRef != null) {
      return true;
    } else {
      return false;
    }
  }

  bool getProduct (String userId) {
    final DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child('product/${userId}');
    usersRef.child(userId).get();
    print(usersRef);

    if (usersRef != null) {
      return true;
    } else {
      return false;
    }
  }

}

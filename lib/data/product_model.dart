import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';


class ProductListModel {
  String? msg;
  List<ProductModel>? data;

  ProductListModel({this.msg, this.data});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(ProductModel.fromMap(v));
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

class ProductModel {
  late String? id;
  late String? sellerId;
  late String? dishName;
  late String? description;
  late String? price;
  late String? imageUrl;

  ProductModel({this.id, this.sellerId, this.dishName, this.description, this.price, this.imageUrl});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'dishName': dishName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
     };
  }
  factory ProductModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot?.value as Map<dynamic, dynamic>?;

    if (data == null) {
      throw Exception('Invalid product snapshot');
    }

    return ProductModel(
      id: data['id'],
      sellerId: data['sellerId'],
      dishName: data['dishName'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );
  }
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      sellerId: map['sellerId'],
      dishName: map['dishName'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }

  bool saveProduct (ProductModel productModel) {
    final DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child('product/${productModel.sellerId}');
    usersRef.child(productModel.id!).set(productModel.toJson());

    if (usersRef != null) {
      return true;
    } else {
      return false;
    }
  }



}

import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  late String? id;
  late String? userName;
  late String? shopName;
  late String? email;
  late String? type;
  late String? token;

  UserModel({this.id, this.userName, this.email, this.type, this.shopName, this.token});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': userName,
      'email': email,
      'type': type,
      'shopName': shopName,
      'token' : token
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': userName,
      'email': email,
      'type': type,
      'shopName': shopName,
      'token':token
    };
  }

  void saveUser(UserModel user) {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users');
    usersRef.child(user.id!).set(user.toJson());
    log('save Product ${usersRef}');

  }
}


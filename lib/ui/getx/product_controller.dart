import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_food_shop_app/data/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductModel productModel = ProductModel();
  bool inProgress = true;

  String addProduct(ProductModel productModel) {
    final result = productModel.saveProduct(productModel);
    if (result) {
      return "Product added Successfully";
    } else {
      return "Please Try Again";
    }
  }





  bool deleteProduct(String userId, String productId) {
    bool result = true;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("product/$userId/$productId");
    reference.remove().then((_) {
      // Delete operation completed successfully
      // result = 'Product deleted successfully';
      return true;
    }).catchError((error) {
      // Delete operation encountered an error
      // result = 'Delete operation failed: $error';
      // print(result);
      return false;
    });
    return result;
  }

  DatabaseReference fatchData(String sellerId) {
    final ref = FirebaseDatabase.instance.ref('product/$sellerId');
    return ref;
  }


  DatabaseReference userfatchData() {
    final ref = FirebaseDatabase.instance.ref('product');
    return ref;
  }

  bool updateProduct(ProductModel productModel) {
    bool result = true;
    DatabaseReference reference =
    FirebaseDatabase.instance.ref().child("product/${productModel.sellerId}/${productModel.id}");
    reference.update({
      'dishName': productModel.dishName,
      'price': productModel.price,
      'description': productModel.description,
      'imageUrl': productModel.imageUrl
    }).then((_){

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

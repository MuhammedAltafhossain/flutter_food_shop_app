import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/product_model.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/product_controller.dart';
import 'package:flutter_food_shop_app/ui/widget/drawer_widget.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../widget/add_text_from_field_widget.dart';
import '../widget/app_elevated_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  final TextEditingController _editingControllerDishName =
      TextEditingController();
  final TextEditingController _editingControllerDescription =
      TextEditingController();
  final TextEditingController _editingControllerPrice = TextEditingController();
  final TextEditingController _editingControllerImageUrl =
      TextEditingController();

  ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/daily_food_logo.png',
          height: 100,
          width: 200,
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryColor,
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Form(
          key: _fromKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Add Item',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 2.3,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  'Please add product to your shop',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 2.3,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AddTextFieldWidget(
                  controller: _editingControllerDishName,
                  hintText: 'Dish Name',
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Dish Name iss required';
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AddTextFieldWidget(
                  controller: _editingControllerDescription,
                  hintText: 'Description',
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is required';
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AddTextFieldWidget(
                  controller: _editingControllerPrice,
                  hintText: 'Price',
                  textInputType: true,
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AddTextFieldWidget(
                  obscureText: false,
                  controller: _editingControllerImageUrl,
                  hintText: 'Image Url',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Image Url required';
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AppElevatedButton(
                    text: 'Add',
                    onTap: () {
                      if (_fromKey.currentState!.validate()) {
                        final userId = UserData.id;
                        print(userId);
                        String idGenerator() {
                          final now = DateTime.now();
                          return now.microsecondsSinceEpoch.toString();
                        }

                        String productId = idGenerator();
                        ProductModel productModel = ProductModel(
                            sellerId: userId,
                            dishName: _editingControllerDishName.text.trim(),
                            description:
                                _editingControllerDescription.text.trim(),
                            id: productId,
                            imageUrl: _editingControllerImageUrl.text.trim(),
                            price: _editingControllerPrice.text.trim());

                        final result =
                            productController.addProduct(productModel);
                        if (result == 'Product added Successfully') {
                          customeMessage(
                              "Success",
                              "Product added Successfully",
                              const Icon(
                                Icons.add,
                                color: Colors.green,
                              ));
                        } else {
                          customeMessage(
                              "Error",
                              "Please Try again",
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ));
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

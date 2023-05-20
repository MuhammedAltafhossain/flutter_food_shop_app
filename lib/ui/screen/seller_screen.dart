import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/product_model.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/product_controller.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../widget/add_text_from_field_widget.dart';
import '../widget/app_elevated_button.dart';
import '../widget/drawer_widget.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  final TextEditingController _editingControllerDishName =
      TextEditingController();
  final TextEditingController _editingControllerDescription =
      TextEditingController();
  final TextEditingController _editingControllerPrice = TextEditingController();
  final TextEditingController _editingControllerImageUrl =
      TextEditingController();

  ProductController productController = Get.put(ProductController());
  List<ProductModel> listOfProduct = [];
  String? sellerId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sellerId = UserData.id;
  }

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
      drawer: const DrawerWidget(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: productController.fatchData(sellerId!),
                defaultChild: const Center(child: Text('Loading')),
                itemBuilder: (context, snapshot, animation, index) {
                  Map products = snapshot.value as Map;

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              snapshot.child('imageUrl').value.toString(),
                              height: 220,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        products['dishName'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        // snapshot.child('dishName').value.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '\$ ${products['price']}',
                                      // snapshot.child('dishName').value.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(products['description']),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppElevatedButton(
                                      text: 'Update',
                                      onTap: () {
                                        final productId = products['id'];
                                        _editingControllerDishName.text =
                                            products['dishName'];
                                        _editingControllerDescription.text =
                                            products['description'];
                                        _editingControllerPrice.text =
                                            products['price'];
                                        _editingControllerImageUrl.text =
                                            products['imageUrl'];
                                        buildShowModalBottomSheet(
                                            context, productId);
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppElevatedButton(
                                    text: 'Delete',
                                    onTap: () {
                                      final productId = products['id'];
                                      if (productId != null &&
                                          sellerId != null) {
                                        final result =
                                            productController.deleteProduct(
                                                sellerId!, productId);
                                        if (result) {
                                          customeMessage(
                                            "Success",
                                            'Product deleted successfully',
                                            const Icon(
                                              Icons.ads_click,
                                              color: Colors.red,
                                            ),
                                          );
                                        } else {
                                          customeMessage(
                                            "Error",
                                            'Something wrong',
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, productId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _fromKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'Update Item',
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
                      'Update product to your shop',
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
                          return 'Invalid Email';
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
                      text: 'Update',
                      onTap: () {
                        if (_fromKey.currentState!.validate()) {
                          final userId = UserData.id;

                          ProductModel productModel = ProductModel(
                              sellerId: userId,
                              dishName: _editingControllerDishName.text.trim(),
                              description:
                                  _editingControllerDescription.text.trim(),
                              id: productId,
                              imageUrl: _editingControllerImageUrl.text.trim(),
                              price: _editingControllerPrice.text.trim());

                          final result =
                              productController.updateProduct(productModel);
                          if (result) {
                            customeMessage(
                                "Success",
                                "Product Update Successfully",
                                const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ));
                            Navigator.of(context).pop();
                          } else {
                            customeMessage(
                              "Error",
                              "Please Try again",
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          }
                        } else {
                          print('error');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

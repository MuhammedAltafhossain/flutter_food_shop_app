import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/cart_model.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/cart_controller.dart';
import 'package:flutter_food_shop_app/ui/getx/product_controller.dart';
import 'package:flutter_food_shop_app/ui/screen/user_cart_list_screen.dart';
import 'package:flutter_food_shop_app/ui/widget/drawer_widget.dart';
import 'package:flutter_food_shop_app/ui/widget/inc_dec_form_field.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../widget/app_elevated_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  ProductController productController = Get.put(ProductController());
  CartController cartController = Get.put(CartController());

  String? userId;
  int qty = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = UserData.id;
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
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const UserCartListScreen());
              },
              icon: const Icon(Icons.add_shopping_cart))
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: productController.userfatchData().onChildAdded,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data?.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          elevation: 15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Image.network(
                                  list[index]['imageUrl'],
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
                                            list[index]['dishName'],
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
                                          '\$ ${list[index]['price'].toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: AppColors.primaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Product Description',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      list[index]['description'].toString(),
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.20),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IncDecFormField(
                                            onChange: (quantity) {
                                              qty = quantity;
                                            },
                                            cartQty: 0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: 120,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AppElevatedButton(
                                            onTap: () {
                                              AddToCartModel addToCartModel =
                                                  AddToCartModel(
                                                      id: list[index]['id'],
                                                      price: double.tryParse(list[index]
                                                          ['price']),
                                                      imageUrl: list[index]
                                                          ['imageUrl'],
                                                      description: list[index]
                                                          ['description'],
                                                      dishName: list[index]
                                                          ['dishName'],
                                                      sellerId: list[index]
                                                      ['sellerId'],
                                                      qty: qty);
                                              final result = cartController
                                                  .addToCart(addToCartModel);
                                              if (result) {
                                                customeMessage(
                                                    'Success',
                                                    'Product Add to cart Successful..',
                                                    const Icon(
                                                      Icons.add_shopping_cart,
                                                      color: Colors.white,
                                                    ));
                                              } else {
                                                customeMessage(
                                                    'Failed',
                                                    'Product Add to cart Failed../',
                                                    const Icon(
                                                      Icons.add_shopping_cart,
                                                      color: Colors.red,
                                                    ));
                                              }
                                            },
                                            text: 'Add to cart',
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

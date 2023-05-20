import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/cart_controller.dart';
import 'package:flutter_food_shop_app/ui/getx/product_controller.dart';
import 'package:flutter_food_shop_app/ui/screen/check_out_screen.dart';
import 'package:flutter_food_shop_app/ui/widget/drawer_widget.dart';
import 'package:flutter_food_shop_app/ui/widget/inc_dec_form_field.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../widget/app_elevated_button.dart';

class UserCartListScreen extends StatefulWidget {
  const UserCartListScreen({Key? key}) : super(key: key);

  @override
  State<UserCartListScreen> createState() => _UserCartListScreenState();
}

class _UserCartListScreenState extends State<UserCartListScreen> {
  ProductController productController = Get.put(ProductController());
  CartController cartController = Get.put(CartController());

  String? userId;
  int qty = 1;
  int totalQuantity = 0;
  double totalPrice = 0.0;
  List<dynamic> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = UserData.id;
    calculateTotalPriceAndQuantity();
  }

  void calculateTotalPriceAndQuantity() {
    totalQuantity = 0;
    totalPrice = 0.0;
    final cartItemsStream =
        cartController.addToCartFatchData(userId.toString()).onValue;
    cartItemsStream.listen((event) {
      final dataSnapshot = event.snapshot;
      final Map<dynamic, dynamic>? cartItems = dataSnapshot.value as dynamic;
      if (cartItems != null) {
        for (var item in cartItems.values) {
          final int quantity = item['qty'];
          final int productPrice = item['price'] ?? 0;
          final int price = productPrice * quantity;
          totalPrice += price;
        }
      }
      setState(() {}); // Update the state to reflect the changes
    });
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
              onPressed: () {}, icon: const Icon(Icons.add_shopping_cart))
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  cartController.addToCartFatchData(userId.toString()).onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Cart is empty'),
                  );
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data?.snapshot.value as dynamic ?? {};
                  list.clear();
                  list = map.values.toList();


                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        elevation: 5,
                        child: Row(
                          children: [
                            Image.network(
                              list[index]['imageUrl'],
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                          list[index]['dishName'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Price : ${list[index]['price']}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    width: 100,
                                    child: IncDecFormField(
                                        onChange: (quantity) {
                                          print(quantity);
                                          totalPrice = 0;
                                          totalPrice == quantity * list[index]['price'];
                                          String id = list[index]['id'];

                                          cartController.updateCart(quantity, id);
                                          setState(() {});
                                        },
                                        cartQty: list[index]['qty'],),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.20),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      '\$$totalPrice',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: AppElevatedButton(
                    text: 'Checkout',
                    onTap: () {
                      Get.to(CheckOutScreen(
                        list: list, totalPrice: totalPrice
                      ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

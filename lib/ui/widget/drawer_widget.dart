import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/screen/login_screen.dart';
import 'package:flutter_food_shop_app/ui/screen/seller_screen.dart';
import 'package:flutter_food_shop_app/ui/screen/user_order_list.dart';
import 'package:flutter_food_shop_app/ui/screen/user_screen.dart';
import 'package:get/get.dart';
import '../screen/add_product_screen.dart';
import '../screen/seller_order_list.dart';
import '../screen/user_cart_list_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/daily_food_logo.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name : ${UserData.name ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'E-mail : ${UserData.email ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Type : ${UserData.type ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(children: [
              ListTile(
                title: const Text("Home"),
                leading: const Icon(Icons.home),
                onTap: () {
                  if (UserData.type == 'seller') {
                    Get.to(const SellerScreen());
                  } else {
                    Get.to(const UserScreen());
                  }
                },
              ),
              ListTile(
                title: UserData.type == 'seller'
                    ? const Text("Add Product")
                    : const Text("Add to Cart"),
                leading: const Icon(Icons.add_shopping_cart),
                onTap: () {
                  if (UserData.type == 'seller') {
                    Get.to(const AddProductScreen());
                  } else {
                    Get.to(Get.to(const UserCartListScreen()));
                  }
                },
              ),
              ListTile(
                  title: UserData.type == 'seller'
                      ? const Text("Order List")
                      : const Text("Order List"),
                  leading: const Icon(Icons.shopping_bag),
                  onTap: () {
                    if (UserData.type == 'seller') {
                      Get.to(const SellerOrderList());
                    } else {
                      Get.to(Get.to(const UserOrderList()));
                    }
                  }),
              ListTile(
                title: const Text("Logout"),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.to(const LogInScreen());

                },
              ),


            ]),
          )
        ],
      ),
    );
  }
}

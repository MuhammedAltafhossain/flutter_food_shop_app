import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/ui/screen/user_screen.dart';
import 'package:flutter_food_shop_app/ui/utils/app_colors.dart';
import 'package:flutter_food_shop_app/ui/widget/app_elevated_button.dart';
import 'package:get/get.dart';

class OrderCompleteScreen extends StatefulWidget {
  double subTotal = 0.0;

  OrderCompleteScreen({Key? key, required this.subTotal}) : super(key: key);

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(50)),
              child: const Icon(
                Icons.check,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '\$${widget.subTotal.toString()}',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                  color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Order is complete',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const Text(
              'Please check Order Page',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppElevatedButton(
                  text: "Continue Shopping",
                  onTap: () {
                    Get.to(const UserScreen());
                  }),
            )
          ],
        ),
      ),
    );
  }
}

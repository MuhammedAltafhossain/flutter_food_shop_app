import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/ui/getx/order_controller.dart';
import 'package:flutter_food_shop_app/ui/screen/order_complete_screen.dart';
import 'package:flutter_food_shop_app/ui/widget/add_text_from_field_widget.dart';
import 'package:flutter_food_shop_app/ui/widget/app_elevated_button.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../widget/drawer_widget.dart';

class CheckOutScreen extends StatefulWidget {
  List<dynamic> list = [];
  double totalPrice = 0.0;

  CheckOutScreen({Key? key, required this.list, required this.totalPrice})
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

int sum = 0;
double subTotal = 0.0;

class _CheckOutScreenState extends State<CheckOutScreen> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subTotal = widget.totalPrice + 60;
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key: _fromKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    'Check Out',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddTextFieldWidget(
                    controller: addressController,
                    obscureText: false,
                    hintText: 'Address',
                    validator: (value) {
                      print(value);
                      if (value!.isEmpty) {
                        return 'Address is required';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddTextFieldWidget(
                    controller: phoneNumberController,
                    obscureText: false,
                    hintText: 'Phone Number',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number is required';
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration:
                BoxDecoration(color: AppColors.primaryColor.withOpacity(.1)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sub Total',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        '\$${widget.totalPrice.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        '60',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        '\$${subTotal.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppElevatedButton(
                        text: "Order placed",
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            final result = orderController.orderPlaced(
                                widget.list,
                                subTotal,
                                addressController.text.trim(),
                                phoneNumberController.text.trim());
                            print(result);
                            if (result) {
                              Get.to(OrderCompleteScreen(subTotal: subTotal,));
                            } else {
                              customeMessage('Error', "Please try again",
                                  Icon(Icons.error));
                            }
                          }
                          ;
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

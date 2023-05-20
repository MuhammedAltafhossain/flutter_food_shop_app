import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/ui/screen/seller_screen.dart';
import 'package:flutter_food_shop_app/ui/screen/singup_screen.dart';
import 'package:flutter_food_shop_app/ui/screen/user_screen.dart';
import 'package:flutter_food_shop_app/ui/utils/app_colors.dart';
import 'package:flutter_food_shop_app/ui/widget/add_text_from_field_widget.dart';
import 'package:flutter_food_shop_app/ui/widget/app_elevated_button.dart';
import 'package:get/get.dart';

import '../../data/user_data.dart';
import '../getx/auth_controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  AuthController authController = Get.put(AuthController());

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _fromKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/daily_food_logo.png',
              height: 60,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Login',
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
              'Please sign in to continue',
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
              controller: _emailTextEditingController,
              hintText: 'Email Address',
              obscureText: false,
              validator: (value) {
                if (!isValidEmail(value.toString())) {
                  return 'Invalid Email';
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            AddTextFieldWidget(
              controller: _passwordTextEditingController,
              hintText: 'Password',
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            AppElevatedButton(
                text: 'LOGIN',
                onTap: () {
                  if (_fromKey.currentState!.validate()) {
                    final email = _emailTextEditingController.text.trim();
                    final password = _passwordTextEditingController.text.trim();
                    authController
                        .loginWithEmailAndPassword(email, password)
                        .then((value) {
                      if (value != null) {
                        if (value == "Wrong password") {
                          customeMessage(
                              'error',
                              'wrong password',
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ));
                        } else if (value == 'User not found') {
                          customeMessage(
                              "Error",
                              "User not found..",
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ));
                        } else {
                          authController.fetchUserData(value).then((value) {
                            if (value != null) {
                              UserData.id = value['id'];
                              UserData.type = value['type'];
                              UserData.name = value['name'];
                              UserData.email = value['email'];
                              UserData.token = value['token'];
                              if (value['type'] == 'user') {
                                Get.to(const UserScreen());
                              } else {
                                Get.to(const SellerScreen());
                              }
                            }
                          });
                        }
                      }
                    });
                  }
                }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an accounts?',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1.3,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Get.to(const SingUpScreen());
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: AppColors.primaryColor),
                    )),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

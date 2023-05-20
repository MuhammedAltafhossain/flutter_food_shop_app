import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/ui/getx/auth_controller.dart';
import 'package:flutter_food_shop_app/ui/screen/login_screen.dart';
import 'package:flutter_food_shop_app/ui/utils/app_colors.dart';
import 'package:flutter_food_shop_app/ui/widget/add_text_from_field_widget.dart';
import 'package:flutter_food_shop_app/ui/widget/app_elevated_button.dart';
import 'package:get/get.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _shopNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  List<String> items = ['user', 'seller'];
  String currentItem = 'user';
  bool checkDropdownValue = false;

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
      child: SingleChildScrollView(
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
                'Let\'s Get Started',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 2.3,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Create an Account',
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
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: const Text('Choose Option'),
                    elevation: 16,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    onChanged: (String? newValue) {
                      if (newValue != null) currentItem = newValue;
                      if (newValue == 'user') {
                        checkDropdownValue = false;
                        setState(() {});
                      } else {
                        checkDropdownValue = true;
                      }
                      setState(() {});
                    },
                    value: currentItem,
                    items: items
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              checkDropdownValue
                  ? Column(
                      children: [
                        AddTextFieldWidget(
                          controller: _userNameTextEditingController,
                          hintText: 'Please enter your name',
                          obscureText: false,
                          validator: (value) {
                            if (value == null) {
                              return 'Name is required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        AddTextFieldWidget(
                          controller: _shopNameTextEditingController,
                          hintText: 'Please entry your shop name',
                          obscureText: false,
                          validator: (value) {
                            if (value == null) {
                              return 'shop name is required';
                            }
                          },
                        )
                      ],
                    )
                  : AddTextFieldWidget(
                      controller: _userNameTextEditingController,
                      hintText: 'Please enter your name',
                      obscureText: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Name is required';
                        }
                      },
                    ),
              const SizedBox(
                height: 12,
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
                  if (value == null) {
                    return 'Password is required';
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              AppElevatedButton(
                  text: 'SIGN UP',
                  onTap: () {
                    if (_fromKey.currentState!.validate()) {
                      final email = _emailTextEditingController.text.trim();
                      final password =
                          _passwordTextEditingController.text.trim();
                      final shopName =
                          _shopNameTextEditingController.text.trim();
                      final userName =
                          _userNameTextEditingController.text.trim();
                      final type = currentItem.trim();

                      authController
                          .registerWithEmailAndPassword(
                              email, password, type, shopName, userName)
                          .then((value) {
                            if(value){
                              Get.to(const LogInScreen());
                            }
                            else{

                            }
                        log('authController ${value} ');


                      });
                    }
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an accounts?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.3,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(const LogInScreen());
                      },
                      child: Text(
                        'Sing in',
                        style: TextStyle(color: AppColors.primaryColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

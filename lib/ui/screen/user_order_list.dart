import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_shop_app/data/user_data.dart';
import 'package:flutter_food_shop_app/ui/getx/order_list_controller.dart';
import 'package:flutter_food_shop_app/ui/getx/product_controller.dart';
import 'package:flutter_food_shop_app/ui/widget/drawer_widget.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class UserOrderList extends StatefulWidget {
  const UserOrderList({Key? key}) : super(key: key);

  @override
  State<UserOrderList> createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  ProductController productController = Get.put(ProductController());
  OrderListController orderListController = Get.put(OrderListController());
  String? userId;
  int qty = 1;
  int totalQuantity = 0;
  double totalPrice = 0.0;
  List<dynamic> list = [];
  bool isEqual = false;
  String orderStatus = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = UserData.id;
  }



  int calculateMinutesSum(DateTime fromDate, DateTime toDate) {
    Duration duration = toDate.difference(fromDate);
    int minutesSum = duration.inMinutes;
    return minutesSum;
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
                query: orderListController.fatchDataOrder(),
                defaultChild: const Center(child: Text('Loading')),
                itemBuilder: (context, snapshot, animation, index) {
                  Map products = snapshot.value as Map;
                  list.add(products);

                  DateTime date = DateTime.now();
                  DateTime formDate = DateTime.parse(list[index]['date']);
                  const int targetMinutes = 10;
                  int minutesSum = calculateMinutesSum(formDate, date);
                  orderStatus = list[index]['status'];
                  if (orderStatus == 'Pending') {
                    isEqual = minutesSum > targetMinutes;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: 200, minHeight: 56.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int a) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.cyan,
                                      backgroundImage: NetworkImage(list[index]
                                      ['product'][a]['imageUrl']),
                                    ),
                                    title: Text(
                                      list[index]['product'][a]['dishName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(
                                        'Price: ${list[index]['product'][a]['price']
                                            .toString()}'),
                                    trailing: Text(
                                      'Qty : ${list[index]['product'][a]['qty']}'
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryColor),
                                    ),
                                  );
                                },
                                itemCount: list[index]['product'].length,
                              ),
                            ),
                            Text(
                              'Date : ${list[index]['date']}',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status : ${list[index]['status']}',
                                ),
                                Text(
                                  'Total Price : \$${list[index]['totalPrice']}',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            orderStatus == 'Pending' ?
                            isEqual
                                ? TextButton(
                                onPressed: () {
                                  final orderId = list[index]['orderId'];
                                  final sellerId = list[index]['product'][0]['sellerId'];
                                  final result = orderListController
                                      .updateOrder(
                                      orderId, 'Cancelled', sellerId);
                                  if (result) {
                                    customeMessage('Message', 'Order cancelled',
                                        Icon(Icons.info, color: Colors.green,));
                                  }
                                  else {
                                    customeMessage(
                                        'Error', 'Order cancel failed',
                                        Icon(Icons.info, color: Colors.red,));
                                  }
                                },
                                child: const Text('Cancelled'))
                                : Container() : Container(),
                          ],
                        ),
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
}

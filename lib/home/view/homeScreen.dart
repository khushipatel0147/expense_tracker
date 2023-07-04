import 'package:expense_tracker/model/incomeexpense.dart';
import 'package:expense_tracker/utiles/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/incomeexpenseController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  DbHelper dbHelper = DbHelper();
  IncomeExpenseModel model = IncomeExpenseModel();

  IncomeExpenseController controller = Get.put(IncomeExpenseController());

  void initState() {
    super.initState();
    controller.getdata();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          "Income & Expenses Tracker",
          style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  Get.toNamed('/ie', arguments: {'index': index, 'status': 0});
                },
                onDoubleTap: () {
                  DbHelper dbHelper = DbHelper();
                  dbHelper.deleteData(controller.datalist[index]['id']);
                  controller.getdata();
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      border: Border.all(color: Colors.indigo, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${controller.datalist[index]['cate']}",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20,
                                  letterSpacing: 1),
                            ),
                            Spacer(),
                            Text(
                              "${controller.datalist[index]['amount']}",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 16,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 18,
                              width: 83,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "${controller.datalist[index]['date']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                DbHelper dbHelper = DbHelper();

                                dbHelper.updateData(
                                    model, controller.datalist[index]['id']);
                                Get.toNamed('/ie', arguments: {'index': index, 'status': 0});

                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 25),
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.delete,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: controller.datalist.length),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          onPressed: () {
            Get.toNamed('/ie', arguments: {'index': null, 'status': 1});
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    ));
  }
}

import 'package:expense_tracker/utiles/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class IncomeExpenseController extends GetxController {
  RxString bydefaultdate =
      "${DateFormat('dd-MM-yyyy').format(DateTime.now())}".obs;
  RxString bydefaulttime = "${TimeOfDay.now()}".obs;
  RxString bydefaultcate='Select a Category'.obs;
  RxInt bydefaultvalue=0.obs;

  DbHelper dbHelper=DbHelper();
  RxList datalist=[].obs;
  Future<void> getdata()
  async {
   datalist.value = await dbHelper.readData();
    print(datalist.length);
  }
}

import 'package:expense_tracker/expense/view/incomeExpenseScreen.dart';
import 'package:expense_tracker/home/view/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void main()
{
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/':(p0) => HomeScreen(),
      '/ie':(p0) => IncomeExpenseScreen(),
    },
  ));
}
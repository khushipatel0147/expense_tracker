import 'package:expense_tracker/model/incomeexpense.dart';
import 'package:expense_tracker/utiles/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/controller/incomeexpenseController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IncomeExpenseScreen extends StatefulWidget {
  const IncomeExpenseScreen({super.key});

  @override
  State<IncomeExpenseScreen> createState() => _IncomeExpenseScreenState();
}

//
class _IncomeExpenseScreenState extends State<IncomeExpenseScreen> {
  IncomeExpenseController controller = Get.put(IncomeExpenseController());

  TextEditingController txtnote = TextEditingController();
  TextEditingController txtamount = TextEditingController();
  Map ex = Get.arguments;

  @override
  void initState() {
    super.initState();

    if (ex['status'] == 0) {
      int index = ex['index'];
      txtamount = TextEditingController(
          text: controller.datalist[index]['amount'].toString());
      txtnote = TextEditingController(text: controller.datalist[index]['note']);
      controller.bydefaultcate.value = controller.datalist[index]['cate'];
      controller.bydefaultdate.value = controller.datalist[index]['date'];
      controller.bydefaulttime.value = controller.datalist[index]['time'];
      controller.bydefaultvalue.value = controller.datalist[index]['status'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: ex['status'] == 0
            ? Text(
                "Update Data",
                style: TextStyle(
                    color: Colors.white, fontSize: 20, letterSpacing: 1),
              )
            : Text(
                "Income & Expenses",
                style: TextStyle(
                    color: Colors.white, fontSize: 20, letterSpacing: 1),
              ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            buildTextField(
                hint: "amount",
                controller: txtamount,
                type: TextInputType.number),
            SizedBox(height: 10),
            Container(
              height: 63,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigoAccent, width: 1.75),
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(
                () => DropdownButton<String>(
                  isExpanded: true,
                  value: controller.bydefaultcate.value,
                  onChanged: (value) {
                    controller.bydefaultcate.value = value!;
                  },
                  items: [
                    'Select a Category',
                    'Food',
                    'Travel',
                    'Education',
                    'Entertainment',
                    'Other',
                  ].map<DropdownMenuItem<String>>(
                    (String val) {
                      return DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              val,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.5,
                                  letterSpacing: 2),
                            ),
                          ),
                          value: val);
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 10),
            buildTextField(
                hint: "note", controller: txtnote, type: TextInputType.text),
            SizedBox(height: 10),
            Container(
              height: 63,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.75, color: Colors.indigoAccent)),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickdate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2100));
                      if (pickdate != null &&
                          pickdate != controller.bydefaultdate) {
                        DateFormat date = DateFormat('dd-MM-yyyy');
                        controller.bydefaultdate.value = date.format(pickdate);
                      }
                    },
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 25),
                  Obx(
                    () => Text(
                      "${controller.bydefaultdate}",
                      style: TextStyle(
                          color: Colors.black, fontSize: 18, letterSpacing: 1),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 63,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.75, color: Colors.indigoAccent)),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? picktime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (picktime != null &&
                          picktime != controller.bydefaulttime) {
                        controller.bydefaulttime.value =
                            picktime.format(context);
                      }
                    },
                    child: Icon(
                      Icons.watch_later,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 25),
                  Obx(
                    () => Text(
                      "${controller.bydefaulttime}",
                      style: TextStyle(
                          color: Colors.black, fontSize: 18, letterSpacing: 1),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.75, color: Colors.indigoAccent)),
              child: Obx(
                () => Column(
                  children: [
                    RadioListTile(
                      activeColor: Colors.indigoAccent,
                      value: 0,
                      title: Text(
                        'Expense',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1),
                      ),
                      groupValue: controller.bydefaultvalue.value,
                      onChanged: (value) {
                        controller.bydefaultvalue.value = 0;
                      },
                    ),
                    RadioListTile(
                      activeColor: Colors.indigoAccent,
                      value: 1,
                      title: Text(
                        'Income',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1),
                      ),
                      groupValue: controller.bydefaultvalue.value,
                      onChanged: (value) {
                        controller.bydefaultvalue.value = 1;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (ex['status']==0)
                {
                  DbHelper dbhelper = DbHelper();
                  IncomeExpenseModel model = IncomeExpenseModel(
                    time: controller.bydefaulttime.value,
                    status: controller.bydefaultvalue.value,
                    note: txtnote.text,
                    date: controller.bydefaultdate.value,
                    cate: controller.bydefaultcate.value,
                    amount: int.parse(txtamount.text),
                    id: controller.datalist[ex['index']]['id'],
                  );
                  dbhelper.updateData(
                      model, controller.datalist[ex['index']]['id']);
                }
                else
                {
                  DbHelper dbhelper = DbHelper();
                  IncomeExpenseModel model = IncomeExpenseModel(
                      time: controller.bydefaulttime.value,
                      status: controller.bydefaultvalue.value,
                      note: txtnote.text,
                      date: controller.bydefaultdate.value,
                      cate: controller.bydefaultcate.value,
                      amount: int.parse(txtamount.text));
                  dbhelper.insertData(model);
                }
                controller.getdata();
                Get.back();
              },
              child: ex['status'] == 0
                  ? Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, letterSpacing: 1),
                    )
                  : Text(
                      "Include",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, letterSpacing: 1),
                    ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent),
            )
          ],
        ),
      ),
    ));
  }

  TextField buildTextField({hint, controller, type}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.indigo,
      style: TextStyle(color: Colors.black, fontSize: 18, letterSpacing: 1),
      decoration: InputDecoration(
        label: Text("$hint",
            style: TextStyle(
              color: Colors.indigoAccent,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo.shade900, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.indigoAccent, width: 1.5)),
      ),
    );
  }
}

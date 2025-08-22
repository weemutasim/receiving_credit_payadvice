import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../font/appColor.dart';
import '../font/appFonts.dart';
import '../util/dateformat.dart';
import '../widgets/search.dart';

class Payadvance extends StatefulWidget {
  const Payadvance({super.key});

  @override
  State<Payadvance> createState() => _PayadvanceState();
}

class _PayadvanceState extends State<Payadvance> {
  final List<bool> _isPaidList = List.generate(6, (_) => false);

  final TextEditingController _dateController = TextEditingController(text: dateformat(date: DateTime.now(), type: "dsn"));
  final _search = TextEditingController();
  DateTime? selectedDate;

  bool _reportload = false;
  bool _loaded = true;
  Uint8List? _report;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.pinkcm,
              onPrimary: Colors.white, 
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkPink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = dateformat(date: picked, type: "dsn");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.btBgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Search(
                  searchController: _search,
                  title: "Search",
                  onChanged: (value) {
                      print('Search submitted: $value');
                  },
                ),
                SizedBox(
                  width: width * .15,
                  height: height * .05,
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.traJanPro,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      labelText: "Select date",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today_rounded, color: AppColors.darkPink),
                        onPressed: () => _selectDate(context),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkPink, width: 2.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * .015, top: height * .045),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                rowHeader('ชื่อเอเย่นต์', 'Agent Name', width * .3, width * .0085),
                rowHeader('หมายเลขการจอง', 'RSVN', width * .07, width * .0085),
                rowHeader('บัตร', 'Voucher', width * .07, width * .0085),
                rowHeader('ประเภทการจ่าย', 'PayType', width * .07, width * .0085),
                rowHeader('จำนวนเงิน', 'Amount', width * .07, width * .0085),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * .015),
            child: Column(
              children: List.generate(6, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    body('Test', width * .3, width, height, index),
                    body('Test', width * .07, width, height, index),
                    body('Test', width * .07, width, height, index),
                    body('-', width * .07, width, height, index),
                    body('Test', width * .07, width, height, index),
                    Checkbox(
                      value: _isPaidList[index],
                      activeColor: AppColors.darkPink,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPaidList[index] = value ?? false;
                        });
                        // print('Checkbox $index >> ${_isPaidList[index]}');
                      },
                    ),
                  ],
                );
              })
            ),
          ),
        ],
      ),
    );
  }

  Widget rowHeader(String title, String subtitle, double width, double size) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      color: AppColors.darkPink,
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: size, fontFamily: AppFonts.pgVim, color: Colors.white)), //16
          Text(subtitle, style: TextStyle(fontSize: size, fontFamily: AppFonts.pgVim, color: Colors.white)),
        ],
      )
    );
  }

  Widget body(String data, double width, double size, double height, int index) {
    return Container(
      width: width, //190
      height: height * .035,
      margin: const EdgeInsets.only(top: 3),
      alignment: Alignment.center,
      color: index % 2 == 0 ? const Color.fromARGB(255, 249,196,198) : const Color.fromARGB(255, 253,237,238),
      child: Text(data, style: TextStyle(fontSize: size * .009, fontFamily: AppFonts.pgVim, color: Colors.black, overflow: TextOverflow.ellipsis)) //18
    );
  }
}
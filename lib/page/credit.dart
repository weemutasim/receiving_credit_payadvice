import 'package:credit_payadvice_receiving/font/appFonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
// import 'package:flutter/material.dart';
import '../font/appColor.dart';
import '../report/recevingVoucher.dart';
import '../util/dateformat.dart';
import '../widgets/search.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> {
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

    Offset distan = const Offset(18, 18);
    double blur = 20.0;

    return Scaffold(
      backgroundColor: AppColors.btBgColor, //AppColors.btBgColor
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
          Row(
            children: [
              Container(
                width: width * .5,
                height: height * .8,
                /* decoration: BoxDecoration(
                  border: Border.all()
                ), */
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * .015, top: height * .045),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          rowHeader('ชื่อเอเย่นต์', 'Agent Name', width * .17, width * .0085),
                          rowHeader('หมายเลขการจอง', 'RSVN', width * .07, width * .0085),
                          rowHeader('บัตร', 'Voucher', width * .07, width * .0085),
                          rowHeader('ประเภทการจ่าย', 'PayType', width * .07, width * .0085),
                          rowHeader('จำนวนเงิน', 'Amount', width * .07, width * .0085),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * .015),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            _reportload = false;
                            _loaded = false;
                          });
                          _report = await Recevingvoucher().genPDFRecevingvoucher(date: selectedDate!);
                          setState(() {
                            _reportload = true;
                          });
                        },
                        child: Column(
                          children: List.generate(6, (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                body('Test', width * .17, width, height, index),
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
                    ),
                  ],
                ),
              ),
              SizedBox(width: width * .01),
              Container(
                width: width * .45,
                height: height * .7,
                margin: EdgeInsets.only(left: width * .02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white
                ),
                child: _reportload ? PdfPreview(
                  // pdfFileName: 'Ticket Report ($_title) ${_codeChk ? '($_saleCode)' : ''} ${dateformat(date: _saleDate, type: 'dn')}',
                  allowPrinting: true, 
                  allowSharing: true,
                  canDebug: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  actionBarTheme: PdfActionBarTheme(
                    backgroundColor: AppColors.darkPink,
                  ),
                  dynamicLayout: true,
                  loadingWidget: LoadingAnimationWidget.hexagonDots(color: AppColors.pinkcm, size: width * .045),
                  build: (format) => _report!,
                  onError: (context, error) {
                    return Center(child: Text("เกิดข้อผิดพลาด", style: TextStyle(fontSize: width * .015, fontFamily: AppFonts.pgVim)));
                  },
                ) : _loaded 
                  ? Center(child: Text("ไม่พบข้อมูล", style: TextStyle(fontSize: width * .02, fontFamily: AppFonts.pgVim)))
                  : Center(child: LoadingAnimationWidget.hexagonDots(color: AppColors.pinkcm, size: width * .045)),
              ),
            ],
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
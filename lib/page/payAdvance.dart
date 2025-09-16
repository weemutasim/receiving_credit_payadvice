import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import '../api/dbConnect.dart';
import '../font/appColor.dart';
import '../font/appFonts.dart';
import 'dart:async';
import '../model/mdPayAdvance.dart';
import '../model/mdPayType.dart';
import '../report/creditReport.dart';
import '../util/dateformat.dart';
import '../widgets/search.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class Payadvance extends StatefulWidget {
  const Payadvance({super.key});

  @override
  State<Payadvance> createState() => _PayadvanceState();
}

class _PayadvanceState extends State<Payadvance> with AutomaticKeepAliveClientMixin {
  List<PayType> _payTypeData = [];

  final TextEditingController _dateController = TextEditingController(text: dateformat(date: DateTime.now(), type: "dsn"));
  final TextEditingController _searchController = TextEditingController();
  DateTime? selectedDate;

  List<CashAdvance> _payAdvanceData = [];
  List<CashAdvance> _payAdvanceReport = [];
  List<Map<String, dynamic>> advReport = [];
  List<CashAdvance>? _filteredPayAdvanceData;

  bool _dataLoad = false;
  bool _viewLoad = false;
  bool _selectAll = false;

  @override
  bool get wantKeepAlive => true; 

  @override
  void initState() { //9-9
    super.initState();

    selectedDate = DateTime.now();
    _dBPayType();
    _dBPayAdvance();
  }

  Future<void> _dBPayType() async {
    await Dbconnect().payTypeList().then((value) {
      if (value != null) {
        _payTypeData = value;
      }
    });
  }

  Future<void> _dBPayAdvance() async {
    Map<String, Map<String, dynamic>> grouped = {};
    await Dbconnect().payAdvance(showdate: dateformat(date: selectedDate!, type: 'db')).then((onValue) {
      if(onValue != null){
        _payAdvanceData = onValue.where((item) => item.paytype == '4' && (double.tryParse(item.amount ?? '0.00') ?? 0.0) > 0 && item.activeflag != 'Y').toList();
        _payAdvanceData.sort((a, b) {
          final int userA = int.tryParse(a.userid!) ?? 0;
          final int userB = int.tryParse(b.userid!) ?? 0;
          return userA.compareTo(userB);
        });

        _payAdvanceReport = onValue.where((item) => item.paytype == '4' && (double.tryParse(item.amount ?? '0.00') ?? 0.0) > 0).toList();
        _filteredPayAdvanceData = _payAdvanceData;

        if(_payAdvanceReport.isNotEmpty) {
          for (var item in _payAdvanceReport) {
            String userId = item.userid!;
            String username = item.name!;

            if (!grouped.containsKey(userId)) {
              grouped[userId] = {
                'username': username,
                'userid': userId,
                'sumAmt': double.tryParse(item.amount ?? '0') ?? 0.0,
                'detail': [item]
              };
            } else {
              final current = grouped[userId]!['sumAmt'] as double;
              final newValue = double.tryParse(item.amount ?? '0') ?? 0.0;

              grouped[userId]!['detail'].add(item);
              grouped[userId]!['sumAmt'] = current + newValue;
            }
          }
          advReport = grouped.values.toList();

          advReport.sort((a, b) {
            final int userA = int.tryParse(a['userid'].toString()) ?? 0;
            final int userB = int.tryParse(b['userid'].toString()) ?? 0;
            return userA.compareTo(userB);
          });
        }
        
        /* for(final data in _payAdvanceData){
          print('data > ${data.paytype} accode ${data.accode} activeflat ${data.activeflag} id ${data.id}');
        } */

        setState(() {
          _dataLoad = true;
        });
        _viewLoad = false;
      } else {
        setState(() {
          _viewLoad = false;
          _dataLoad = false;
        });
      }
    }).onError((error, stackTrace) {
      print('Error occurred: $error');
      setState(() {
        _viewLoad = false;
        _dataLoad = false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2025, DateTime.september, 10),
      lastDate: DateTime.now(),
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
      _viewLoad = true;
      _selectAll = false;
      await _dBPayAdvance();
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPayAdvanceData = _payAdvanceData;
      } else {
        _filteredPayAdvanceData = _payAdvanceData!.where((item) => (item.agentcode ?? '').toLowerCase().contains(query.toLowerCase()) || (item.agentname ?? '').toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _printPDF(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], "application/pdf");
    final url = html.Url.createObjectUrlFromBlob(blob);

    js.context.callMethod("autoPrint", [url]);
    html.Url.revokeObjectUrl(url);
  }

  void _alreadyDialog(BuildContext context, String newFlag, CashAdvance item, int chk, {bool? value}) {
    Dialogs.materialDialog(
      barrierDismissible: false,
      msg: chk == 0 ? 'ยืนยันตรวจสอบรายการทั้งหมด' : 'ยืนยันตรวจสอบรายการ',
      title: chk == 0 ? 'Verify All' : "Verify",
      color: Colors.white,
      context: context,
      dialogWidth: kIsWeb ? .25 : null,
        titleStyle: TextStyle(
        fontSize: 25,
        fontFamily: AppFonts.traJanPro,
        fontWeight: FontWeight.bold,
        color: AppColors.pinkcm,
      ),
      msgStyle: TextStyle(
        fontSize: 18,
        fontFamily: AppFonts.pgVim,
        color: Colors.black87,
      ),
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'กลับ',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey, fontFamily: AppFonts.pgVim),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () async {
            if(chk == 0){
              setState(() {
              _selectAll = value ?? false;
              });
              for (var item in _filteredPayAdvanceData!) {
                item.activeflag = newFlag;
                if(item.activeflag != 'Y'){
                  await Dbconnect().upActiveFlag(id: item.id!, flag: newFlag, accCode: item.accode!, amt: item.amount!, cusCode: item.agentcode!, date: dateformat(date: selectedDate!, type: 'db'), perId: item.userid!, refNo: dateformat(date: selectedDate!, type: 'dn'), payType: item.paytype!);
                }
              }
              await _dBPayAdvance();
            } else {
              // print('id > ${item.id} acctiveFlac > $newFlag');
              setState(() {
                item.activeflag = newFlag;
              });
              await Dbconnect().upActiveFlag(id: item.id!, flag: newFlag, accCode: item.accode!, amt: item.amount!, cusCode: item.agentcode!, date: dateformat(date: selectedDate!, type: 'db'), perId: item.userid!, refNo: dateformat(date: selectedDate!, type: 'dn'), payType: item.paytype!);
              await _dBPayAdvance();
            }
            Navigator.of(context).pop();
          },
          text: 'ยืนยัน',
          iconData: Icons.done_rounded,
          color: Colors.green,
          textStyle: TextStyle(color: Colors.white, fontFamily: AppFonts.pgVim),
          iconColor: Colors.white,
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final Map<String, String> accMap = {
      for (var pay in _payTypeData) pay.acccode!: pay.shutname!,
    };

    return Scaffold(
      backgroundColor: AppColors.btBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Search(
                    title: "ค้นหา",
                    searchController: _searchController,
                    readOnly: !_dataLoad,
                    onChanged: (value) {
                      _filterData(_searchController.text);
                    },
                    onTab: (value) {
                      _filterData('');
                    },
                  ),
                  _buildButton('รายงานเงินรับล่วงหน้า', width, height, (_payAdvanceReport.isNotEmpty && _dataLoad) ? () async {
                    final data = await CreditReport().genPDFCreditReport(date:selectedDate!, dataCash: advReport, dataPayType: _payTypeData, title: 'รายงานเงินรับล่วงหน้า', titleEng: 'Pay Advance Report');
                    _printPDF(data);
              
                  } : null, Colors.blueGrey, width * .14, 1, radius: const BorderRadius.all(Radius.circular(25))),
                  SizedBox(
                    width: width * .15,
                    height: height * .05,
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontFamily: AppFonts.pgVim,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        labelText: "เลือกวันที่",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today_rounded, color: AppColors.darkPink),
                          onPressed: _viewLoad ? null : () {
                            _selectDate(context);
                          }
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.darkPink, width: 2.0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onTap: _viewLoad ? null : () => _selectDate(context),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                rowHeader('ชื่อเอเย่นต์', 'Agent Name', width * .3, width * .0085),
                rowHeader('หมายเลขการจอง', 'RSVN', width * .07, width * .0085),
                rowHeader('บัตร', 'Voucher', width * .09, width * .0085),
                rowHeader('ประเภทการจ่าย', 'PayType', width * .1, width * .0085),
                rowHeader('จำนวนเงิน', 'Amount', width * .07, width * .0085),
                Container(
                  width: width * .04,
                  padding: const EdgeInsets.all(5.5),
                  color: AppColors.darkPink,
                  child: Column(
                    children: [
                      Text('Check', style: TextStyle(fontSize: width * .0085, fontFamily: AppFonts.pgVim, color: Colors.white)),
                      Checkbox(
                        value: (_payAdvanceData.isNotEmpty) ? _selectAll : false,
                        activeColor: AppColors.darkPink,
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        onChanged: (_payAdvanceData.isNotEmpty && _payAdvanceData.any((item) => item.accode != null && item.accode!.isNotEmpty)) ? (bool? value) async {
                          final newFlag = value == true ? 'Y' : 'N';
                          _alreadyDialog(context, newFlag, CashAdvance(), 0, value: value);
                        } : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (_dataLoad && _payAdvanceData.isNotEmpty) ? SizedBox(
              width: width * .7,
              height: height * .72,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate((_filteredPayAdvanceData ?? []).length, (index) {
                    final item = (_filteredPayAdvanceData ?? [])[index];
                
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        body('${item.agentcode ?? '-'}  ${item.agentname ?? '-'}', width * .3, width, height, index, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: width * .008)),
                        body(item.rsvn ?? '-', width * .07, width, height, index),
                        body(item.voucher ?? '-', width * .09, width, height, index),
                        body(accMap[item.accode] ?? '-', width * .1, width, height, index),
                        body(item.amount ?? '-', width * .07, width, height, index),
                        Container(
                          width: width * .04,
                          height: height * .035,
                          margin: const EdgeInsets.only(top: 2),
                          color: index % 2 == 0 ? const Color.fromARGB(255, 249,196,198) : const Color.fromARGB(255, 253,237,238),
                          child: Checkbox(
                            value: item.activeflag == 'Y',
                            activeColor: AppColors.darkPink,
                            onChanged: (item.accode != null && item.accode!.isNotEmpty) ? (bool? value) async {
                              final newFlag = value == true ? 'Y' : 'N';
                              _alreadyDialog(context, newFlag, item, 1);
                            } : null,
                          ),
                        ),
                      ],
                    );
                  })
                ),
              ),
            ) : Container(
              width: width * .67,
              height: height * .72,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: height * .01/* , right: width * .016 */),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: _viewLoad ? LoadingAnimationWidget.fourRotatingDots(color: AppColors.darkPink, size: 100) : Text("ไม่พบข้อมูล", style: TextStyle(fontSize: width * .015, fontFamily: AppFonts.pgVim)),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowHeader(String title, String subtitle, double width, double size) {
    return Container(
      width: width,
      alignment: Alignment.center,
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

  Widget body(String data, double width, double size, double height, int index, {Alignment alignment = Alignment.center, EdgeInsets padding = const EdgeInsets.all(0)}) {
    return Container(
      width: width, //190
      height: height * .035,
      padding: padding,
      alignment: alignment,
      margin: const EdgeInsets.only(top: 2),
      color: index % 2 == 0 ? const Color.fromARGB(255, 249,196,198) : const Color.fromARGB(255, 253,237,238),
      child: Text(data, style: TextStyle(fontSize: size * .009, fontFamily: AppFonts.pgVim, color: Colors.black)) //18
    );
  }

  Widget _buildButton(String label, double width, double height, VoidCallback? onPressed, Color color, double widthButton, int chk, {BorderRadius radius = BorderRadius.zero}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(widthButton, height * 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: color,
        elevation: 5,
        padding: EdgeInsets.zero,
      ),
      child: Text(label, style: TextStyle(color: AppColors.white, fontFamily: AppFonts.pgVim, fontSize: width * .0095)),
    );
  }
}
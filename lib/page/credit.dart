import 'package:credit_payadvice_receiving/font/appFonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:printing/printing.dart';
import '../api/dbConnect.dart';
import '../font/appColor.dart';
import '../model/mdPayAdvance.dart';
import '../model/mdPayType.dart';
import '../model/mdTransactionAll.dart';
import '../report/creditReport.dart';
import '../report/incomeReportA4Landscape.dart';
import '../report/recevingVoucher.dart';
import '../util/dateformat.dart';
import '../widgets/search.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/services.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> with AutomaticKeepAliveClientMixin {
  List<PayType> _payTypeData = [];
  List<TransactionAll> _transaction = [];

  final TextEditingController _dateController = TextEditingController(text: dateformat(date: DateTime.now(), type: "dsn"));
  final TextEditingController _searchController = TextEditingController();
  DateTime? selectedDate;

  bool _dataLoad = false;
  bool _transactionLoad = false;
  bool _viewLoad = false;
  bool _selectAll = false;
  bool _reportload = false;
  
  Uint8List? _report;
  double sumAmtAllCredit = 0.00;

  List<CashAdvance> _payCreditData = [];
  List<CashAdvance> _creditDataReport = [];
  List<CashAdvance> _advDataReport = [];
  List<Map<String, dynamic>> creditReport = [];
  List<CashAdvance>? _filteredCreditData;

  @override
  void initState() {
    super.initState();

    _dBPayType();
    selectedDate = DateTime.now();
    _dBTransaction();
    _dBCredit();
  }

  @override
  bool get wantKeepAlive => true; 

  Future<void> _dBTransaction() async {
    await Dbconnect().dataTransactionAll(date: dateformat(date: selectedDate!, type: "db")).then((value) {
      if(value != null) {
        _transaction = value;
        setState(() {
          _transactionLoad = true;
        });
      } else {
        setState(() {
          _transactionLoad = false;
        });
      }
    });
  }

  Future<void> _dBPayType() async {
    await Dbconnect().payTypeList().then((value) {
      if (value != null) {
          _payTypeData = value;
      }
    });
  }

  Future<void> _dBCredit() async {
    Map<String, Map<String, dynamic>> grouped = {};
    await Dbconnect().payAdvance(showdate: dateformat(date: selectedDate!, type: 'db')).then((onValue) {
      if(onValue != null){
        _payCreditData = onValue.where((item) => item.paytype == '2' && (double.tryParse(item.amount ?? '0.00') ?? 0.0) > 0 && item.activeflag != 'P').toList();
        _payCreditData.sort((a, b) {
          final int userA = int.tryParse(a.userid!) ?? 0;
          final int userB = int.tryParse(b.userid!) ?? 0;
          return userA.compareTo(userB);
        });

        //report payment all
        _creditDataReport = onValue.where((item) => item.paytype == '2' && (double.tryParse(item.amount ?? '0.00') ?? 0.0) > 0.0).toList();
        _advDataReport = onValue.where((item) => item.paytype == '4' && (double.tryParse(item.amount ?? '0.00') ?? 0.0) > 0.0).toList();

        sumAmtAllCredit = _payCreditData.fold(0.0, (sum, item) => sum + (double.tryParse(item.amount ?? '0.00') ?? 0.0));
        _filteredCreditData = _payCreditData;

        if(_creditDataReport.isNotEmpty) {
          for (var item in _creditDataReport) {
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
          creditReport = grouped.values.toList();

          creditReport.sort((a, b) {
            final int userA = int.tryParse(a['userid'].toString()) ?? 0;
            final int userB = int.tryParse(b['userid'].toString()) ?? 0;
            return userA.compareTo(userB);
          });
        }
        // print('credit >> $creditReport');

        setState(() {
          _dataLoad = true;
        });
        _viewLoad = false;
      }else {
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
      firstDate: DateTime(2000),
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
      await _dBTransaction();
      await _dBCredit();
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCreditData = _payCreditData;
      } else {
        _filteredCreditData = _payCreditData!.where((item) => (item.agentcode ?? '').toLowerCase().contains(query.toLowerCase()) || (item.agentname ?? '').toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _printPDF(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], "application/pdf");
    final url = html.Url.createObjectUrlFromBlob(blob);

    js.context.callMethod("autoPrint", [url]);
    html.Url.revokeObjectUrl(url);
  }

  void _dialogReport(double width, double height) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: pdfPreview(width, height)
        );
      }
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
      backgroundColor: AppColors.btBgColor, //AppColors.btBgColor
      body: Column(
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
                Padding(
                  padding: EdgeInsets.only(right: width * .045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: width * .05),
                      _buildButton('ใบนำส่งรายได้ฝ่ายบัตร', width, height, (_transaction.isNotEmpty && _transactionLoad) ? () async {
                        setState(() {
                          _reportload = false;
                        });
                        _report = await IncomReportAllA4Landscape().genPDFTransactionAllA4Landscape(dataAll: _transaction, date: selectedDate!, title: '', dataAdv: _advDataReport, dataCredit: _creditDataReport, payType: _payTypeData);
                        setState(() {
                          _reportload = true;
                        });
                        _dialogReport(width, height);
                  
                      } : null, Colors.blueGrey, width * .14, 0, radius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
                      SizedBox(width: width * .005),
                      _buildButton('รายงานเงินรับล่วงหน้าเงินเชื่อ', width, height, (creditReport.isNotEmpty && _dataLoad) ? () async {
                        final data = await CreditReport().genPDFCreditReport(date:selectedDate!, dataCash: creditReport, dataPayType: _payTypeData, title: 'รายงานเงินรับล่วงหน้าเงินเชื่อ', titleEng: 'Advance Payment and Credit Report');
                        _printPDF(data);
                  
                      } : null, Colors.blueGrey, width * .14, 1, radius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
                    ],
                  ),
                ),
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
                        onPressed: _viewLoad ? null : () => _selectDate(context),
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * .04,
                    padding: const EdgeInsets.all(5.5),
                    color: AppColors.darkPink,
                    child: Column(
                      children: [
                        Text('Check', style: TextStyle(fontSize: width * .0085, fontFamily: AppFonts.pgVim, color: Colors.white)),
                        Checkbox(
                          value: _payCreditData.isNotEmpty ? _selectAll : false,
                          activeColor: AppColors.darkPink,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          onChanged: _payCreditData.isNotEmpty/*  && _payCreditData.any((item) => item.activeflag != 'Y') */ ? (bool? value) async {
                            final newFlag = value == true ? 'Y' : 'N';

                            setState(() {
                              _selectAll = value ?? false;
                            });
                            for (var item in _filteredCreditData!)  {
                              item.activeflag = newFlag;
                              if(item.activeflag != 'Y'){
                                await Dbconnect().upActiveFlag(id: item.id!, flag: newFlag, accCode: item.accode!, amt: item.amount!, cusCode: item.agentcode!, date: dateformat(date: selectedDate!, type: 'dn'), perId: item.userid!, refNo: dateformat(date: selectedDate!, type: 'dn'), payType: item.paytype!);
                              }
                            }
                            await _dBCredit();
                          } : null,
                        ),
                      ],
                    ),
                  ),
                  rowHeader('ชื่อเอเย่นต์', 'Agent Name', width * .3, width * .0085),
                  rowHeader('หมายเลขการจอง', 'RSVN', width * .07, width * .0085),
                  rowHeader('บัตร', 'Voucher', width * .09, width * .0085),
                  rowHeader('ประเภทการจ่าย', 'PayType', width * .1, width * .0085),
                  rowHeader('จำนวนเงิน', 'Amount', width * .07, width * .0085),
                ],
              ),
              (_dataLoad && _payCreditData.isNotEmpty) ? Container(
                width: width * .7,
                height: height * .67,
                margin: EdgeInsets.only(left: width * .021),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                    ...List.generate((_filteredCreditData ?? []).length, (index) {
                      final item = (_filteredCreditData ?? [])[index];
                      Color green = item.activeflag == 'Y' ? Colors.green.shade200 : index % 2 == 0 ? const Color.fromARGB(255, 249,196,198) : const Color.fromARGB(255, 253,237,238);
                      Color greenText = item.activeflag == 'Y' ? const Color.fromARGB(255, 12, 92, 16) : Colors.black;
                              
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * .04,
                            height: height * .039,
                            // padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                            color: green,
                            child: Checkbox(
                              value: item.activeflag == 'Y',
                              activeColor: AppColors.darkPink,
                              onChanged: item.activeflag != 'Y' ? (bool? value) async {
                                final newFlag = value == true ? 'Y' : 'N';
                                setState(() {
                                  item.activeflag = newFlag;
                                });
                                await Dbconnect().upActiveFlag(id: item.id!, flag: newFlag, accCode: item.accode!, amt: item.amount!, cusCode: item.agentcode!, date: dateformat(date: selectedDate!, type: 'dn'), perId: item.userid!, refNo: dateformat(date: selectedDate!, type: 'dn'), payType: item.paytype!);
                                await _dBCredit();
                              } : null,
                            ),
                          ),
                          body('${item.agentcode ?? '-'}  ${item.agentname ?? '-'}', width * .3, width, height, index, green, greenText, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: width * .008)),
                          body(item.rsvn!, width * .07, width, height, index, green, greenText),
                          body(item.voucher!, width * .09, width, height, index, green, greenText),
                          body(accMap[item.accode] ?? '-', width * .1, width, height, index, green, greenText),
                          body(item.amount!, width * .07, width, height, index, green, greenText),
                          IconButton(
                            onPressed: item.activeflag == 'Y' ? () async {
                              _report = await Recevingvoucher().genPDFRecevingvoucher(date: selectedDate!, data: item);
                              await Dbconnect().upActiveFlag(id: item.id!, flag: 'P', accCode: item.accode!, amt: item.amount!, cusCode: item.agentcode!, date: dateformat(date: selectedDate!, type: 'dn'), perId: item.userid!, refNo: dateformat(date: selectedDate!, type: 'dn'), payType: item.paytype!);
                              await _dBCredit();
                              _printPDF(_report!);
                            } : null,
                            icon: Icon(Icons.print_rounded, color: item.activeflag == 'Y' ? AppColors.darkPink : Colors.grey)
                          ),
                        ],
                      );
                    }),
                    if(_dataLoad && _payCreditData.isNotEmpty) Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container( //creditDatabase
                          width: width * .11, //190
                          height: height * .05, //50
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: width * .026, top: height * .005),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                            color: AppColors.darkPink,
                          ),
                          child: Text('Total  ${formatter.format(sumAmtAllCredit)}', style: TextStyle(fontSize: width * .011, fontFamily: AppFonts.pgVim, color: Colors.white)), //20
                        ),
                      ],
                    )
                    ]
                  ),
                ),
              ) : Container(
                width: width * .67,
                height: height * .72,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: height * .01/* , left: width * .018 */),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
                child: _viewLoad ? LoadingAnimationWidget.fourRotatingDots(color: AppColors.darkPink, size: 100) : Text("ไม่พบข้อมูล", style: TextStyle(fontSize: width * .015, fontFamily: AppFonts.pgVim)),
              ),
              /* if(_dataLoad && _payCreditData.isNotEmpty) Container( //creditDatabase
                width: width * .14, //190
                height: height * .05, //50
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: width * .53, top: height * .01),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                  color: AppColors.darkPink,
                ),
                child: Text('Total  ${formatter.format(sumAmtAllCredit)}', style: TextStyle(fontSize: width * .011, fontFamily: AppFonts.pgVim, color: Colors.white)), //20
              ) */
            ],
          ),
        ],
      ),
    );
  }

  Widget pdfPreview(double width, double height) {
    return Container(
      width: width * .7, //.45
      height: height * .9, //.7
      margin: EdgeInsets.only(left: width * .01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white
      ),
      child: _reportload ? PdfPreview(
        // pdfFileName: 'Ticket Report ($_title) ${_codeChk ? '($_saleCode)' : ''} ${dateformat(date: _saleDate, type: 'dn')}',
        allowPrinting: false, 
        allowSharing: false,
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
      ) : Center(child: Text("ไม่พบข้อมูล", style: TextStyle(fontSize: width * .02, fontFamily: AppFonts.pgVim)))
    );
  }

  Widget rowHeader(String title, String subtitle, double width, double size, {BorderRadius borderSide = BorderRadius.zero}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: borderSide,
        color: AppColors.darkPink,
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: size, fontFamily: AppFonts.pgVim, color: Colors.white)), //16
          Text(subtitle, style: TextStyle(fontSize: size, fontFamily: AppFonts.pgVim, color: Colors.white)),
        ],
      )
    );
  }

  Widget body(String data, double width, double size, double height, int index, Color colors, Color greenText, {Alignment alignment = Alignment.center, EdgeInsets padding = const EdgeInsets.all(0)}) {
    return Container(
      width: width, //190
      height: height * .039,
      padding: padding,
      alignment: alignment,
      // margin: const EdgeInsets.only(top: 1),
      color: colors,
      child: Text(data, style: TextStyle(fontSize: size * .009, fontFamily: AppFonts.pgVim, color: greenText)) //18
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: AppColors.white, fontFamily: AppFonts.pgVim, fontSize: width * .0095)),
          if(chk != 1) Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: width * .008),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _transactionLoad ? AppColors.darkPink : Colors.grey
            ),
            child: Text(_transactionLoad ?_transaction.length.toString() : '0',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.pgVim,
                fontSize: width * .0095,
                height: 1
              ),
              textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
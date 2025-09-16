import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../model/mdTransactionAll.dart';
import 'footer/footer.dart';
import 'header/headerIncome.dart';

class MockData {
  final String? agentName;
  final String? a30;
  final String? a60;
  final String? a90;

  MockData({this.agentName, this.a30, this.a60, this.a90});
}

class NoteCoinsData {
  final double amount;
  final String qty;

  NoteCoinsData({required this.amount, required this.qty});
}

class IncomReportAll {
  Future<Uint8List> genPDFTransactionAll({required List<TransactionAll> dataAll, required DateTime date, required String title}) async {

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/Ticketing.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-regular.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final traJanPro = pw.Font.ttf(trajanpro);

    for(final data in dataAll) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.only(top: .8 * PdfPageFormat.cm, left: 1.55 * PdfPageFormat.cm, right: 1.55 * PdfPageFormat.cm, bottom: .8 * PdfPageFormat.cm),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: headerReportIncome(context, 'ใบนำส่งรายได้ฝ่ายบัตร', 'Income Report', date, logoblack, pgVim, traJanPro, data.name!, data.code!)
            );
          },
          build: (pw.Context context) {
            return bodyReport(pgVim, traJanPro, data);
          },
          footer: (pw.Context context) {
            return pw.Column(
              children: [
                footer(context, pgVim, traJanPro, 'Income Report'),
              ]
            );
          }
        )
      );
    }

    return pdf.save();
  }

  String formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  List<pw.Widget> bodyReport(pw.Font pgVim, pw.Font traJanPro, TransactionAll data) {
    double sumNoteCoinsAmount() {
      try {
        return data.notesandcoins!.fold(0.0, (total, note) => total + double.parse(note.amount!));
      } catch (e) {
        return 0.0;
      }
    }

    double sumPayeshopAmount() {
      try {
        return data.payeshop!.fold(0.0, (total, payeshop) => total + double.parse(payeshop.amount!));
      } catch (e) {
        return 0.0;
      }
    }
    
    NoteCoinsData buildNoteCoinsData(String coins) {
      double amount = 0.0;
      String qty = '0';
      try {
        var note = data.notesandcoins!.firstWhere((element) => element.ntype == coins);
        amount = double.parse(note.amount!);
        qty = note.qty!;
      } catch (e) {
        print('Error: $e');
      }
      return NoteCoinsData(amount: amount, qty: qty);
    }

    double totalAmount = sumNoteCoinsAmount();
    double creditcardAmount = double.parse(data.creditcard![0].amount!);
    double payeshopAmount = sumPayeshopAmount();
    double grandTotal = totalAmount + creditcardAmount + payeshopAmount;
    // double amt = data.details!.fold(0.0, (sum, item) => sum + (item.amount != null ? double.parse(item.amount!) : 0.0));

    double fontSizeHead = 10;
    double fontSizeBody = 7;

    pw.Widget buildContainer(String title, pw.Font pgVim, double width, double padding, pw.Alignment alignment, {double? height}) {
      return pw.Container(
        padding: pw.EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        alignment: alignment,
        child: pw.Text(title,
          style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold))
      );
    }

    pw.Widget buildConCredit(String text, pw.Font traJanPro, double width, double fontSize) {
      return pw.Container(
        width: width,
        // padding: const pw.EdgeInsets.all(2),
        // decoration: pw.BoxDecoration(border: pw.Border.all()),
        alignment: pw.Alignment.center,
        child: pw.Text(text,
          style: pw.TextStyle(font: traJanPro, fontSize: fontSize, fontWeight: pw.FontWeight.bold))
      );
    }

    pw.Widget buildBodyContainer2(String title, String label, String sum, pw.Font pgVim, double width1, double width2, double height, double padding, int ckh) {
      return pw.Container(
        child: pw.Row(
          children: <pw.Widget>[
            pw.Container(
              padding: pw.EdgeInsets.all(padding),
              width: width1,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              alignment: pw.Alignment.center,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(title,
                    style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold)),
                  if(ckh != 0) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(label,
                      style: pw.TextStyle(font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                  ]             
                ]
              )
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(2),
              height: height,
              width: width2,
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              alignment: pw.Alignment.centerRight,
              child: pw.Text(sum,
                style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold))
            ),    //pw.SizedBox(height: 20),
          ]
        )
      );
    }

    return <pw.Widget>[
      pw.Container(
        child: pw.Row(
          children: <pw.Widget>[
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  child: pw.Container(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Container(
                          child: pw.Column(
                            children: <pw.Widget>[
                              buildHeaderContainer('บัตรเครดิต', 'Credit Card', pgVim, 140, 6.0),
                              pw.SizedBox(width: 10),
                              buildBodyContainer2('(1) รวม', 'Total', formatAmount(creditcardAmount), pgVim, 70, 70, 21, 3.0, 1),
                              pw.SizedBox(height: 7),
                              buildHeaderContainer('เอฟซีคอยน์', 'FCcion', pgVim, 140, 6.0),
                              buildBodyContainer2('(2) รวม', 'Total', '0.00', pgVim, 70, 70, 21, 3.0, 1),
                              pw.SizedBox(height: 8),
                              buildHeaderContainer('อื่นๆ', 'Other', pgVim, 140, 6.0),
                              pw.SizedBox(width: 10),
                              buildBodyContainer2('E-SHOP', 'Total', formatAmount(payeshopAmount), pgVim, 70, 70, 15, 4.0, 0),
                              buildBodyContainer2('VOUCHER', 'Total', '0.00', pgVim, 70, 70, 15, 4.0, 0),
                              buildBodyContainer2('CHEQUE', 'Total', '0.00', pgVim, 70, 70, 15, 4.0, 0),
                              buildBodyContainer2('PAY-IN', 'Total', '0.00', pgVim, 70, 70, 15, 4.0, 0),
                              buildBodyContainer2('TAX', 'Total', '0.00', pgVim, 70, 70, 15, 4.0, 0),
                              buildBodyContainer2('GIFT CERTIFICATE', 'Total', '0.00', pgVim, 70, 70, 15, 4.0, 0),
                            ]
                          ),
                        ),
                        pw.SizedBox(width: 6),
                        pw.Container(
                          child: pw.Column(
                            children: <pw.Widget>[
                              pw.Container(
                                child: pw.Row(
                                  children: <pw.Widget>[
                                    buildHeaderContainer('เงินสกุลต่างประเทศ', 'Foreign Currency', pgVim, 180, 6.0),
                                    buildHeaderContainer('ธนบัตรและเหรียญกษาปณ์', 'Notes & Coins', pgVim, 180, 6.0),
                                  ]
                                )
                              ),
                              buildBodyCurrencyAndNoteCoins('USD', '0.00', '0.00', '0.00', '1000', buildNoteCoinsData('1000').qty, formatAmount(buildNoteCoinsData('1000').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('SGD', '0.00', '0.00', '0.00', '500', buildNoteCoinsData('500').qty, formatAmount(buildNoteCoinsData('500').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('TWD', '0.00', '0.00', '0.00', '100', buildNoteCoinsData('100').qty, formatAmount(buildNoteCoinsData('100').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('JPY', '0.00', '0.00', '0.00', '50', buildNoteCoinsData('50').qty, formatAmount(buildNoteCoinsData('50').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('HKD', '0.00', '0.00', '0.00', '20', buildNoteCoinsData('20').qty, formatAmount(buildNoteCoinsData('20').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('GBP', '0.00', '0.00', '0.00', '10', buildNoteCoinsData('10').qty, formatAmount(buildNoteCoinsData('10').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('CNY', '0.00', '0.00', '0.00', '5', buildNoteCoinsData('5').qty, formatAmount(buildNoteCoinsData('5').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('AUD', '0.00', '0.00', '0.00', '2', buildNoteCoinsData('2').qty, formatAmount(buildNoteCoinsData('2').amount), pgVim),
                              buildBodyCurrencyAndNoteCoins('EUR', '0.00', '0.00', '0.00', '1', buildNoteCoinsData('1').qty, formatAmount(buildNoteCoinsData('1').amount), pgVim),
                              pw.Container(
                                child: pw.Row(
                                  children: <pw.Widget>[
                                    buildHeaderContainer('(4) รวม', 'Total', pgVim, 100, 2.5),
                                    buildContainer('0.00', pgVim, 80, 2, pw.Alignment.centerRight, height: 20),
                                    buildContainer('0.50', pgVim, 50, 6.5, pw.Alignment.center),
                                    buildContainer(buildNoteCoinsData('0.50').qty, pgVim, 50, 2, pw.Alignment.centerRight, height: 20),
                                    buildContainer(formatAmount(buildNoteCoinsData('0.50').amount), pgVim, 80, 2, pw.Alignment.centerRight, height: 20),
                                  ]
                                )
                              ),
                              pw.Container(
                                child: pw.Row(
                                  children: <pw.Widget>[
                                    buildContainer('รายได้รอบ 1 / Amount (First Collection)', pgVim, 180, 5, pw.Alignment.center),
                                    buildContainer('0.25', pgVim, 50, 5, pw.Alignment.center),
                                    buildContainer(buildNoteCoinsData('0.25').qty, pgVim, 50, 2, pw.Alignment.centerRight, height: 17),
                                    buildContainer(formatAmount(buildNoteCoinsData('0.25').amount), pgVim, 80, 2, pw.Alignment.centerRight, height: 17),
                                  ]
                                )
                              ),
                              pw.Container(
                                child: pw.Row(
                                  children: <pw.Widget>[
                                    buildBodyContainer2('(5) เงินสด', 'Cash', '0.00', pgVim, 100, 80, 21, 3.0, 1),
                                    buildBodyContainer2('(6) รวม', 'Total', formatAmount(totalAmount), pgVim, 100, 80, 21, 3.0, 1),
                                  ]
                                )
                              ),
                            ]
                          )
                        ),
                      ]
                    )
                  )
                ),
              ],
            ),
          ],
        )
      ),
      pw.Container(
        height: 70,
        width: 490,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: <pw.Widget>[
            pw.Container(
              padding: const pw.EdgeInsets.all(6.0),
              width: 310,
              child: pw.Column(
                children: <pw.Widget>[
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text('หมายเหตุ ',
                        style: pw.TextStyle( font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 2),
                      pw.Text('Remark',
                        style: pw.TextStyle( font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 6),
                      pw.Text('             __________________________________________________________________________________________',
                        style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 10),
                      pw.Text('             __________________________________________________________________________________________',
                        style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 10),
                      pw.Text('               ____________________________________________________________________________________________________________',
                        style: pw.TextStyle( font: traJanPro, fontSize: 5, fontWeight: pw.FontWeight.normal)),
                    ]
                  ),
                ]
              )
            ),
            pw.SizedBox(width: 6),
            pw.Container(
              height: 80,
              width: 190,
              child: pw.Column(
                children: <pw.Widget>[
                  buildTotal('รวมทั้งสิ้น', 'Grand Total', pgVim, formatAmount(grandTotal)),
                  buildTotal('หักรับคืนคูปอง', 'Refund', pgVim, '0.00'),
                  buildTotal('รวมรายได้สุทธิ์', 'Net Amount', pgVim, formatAmount(grandTotal)),
                ]
              )
            )
          ]
        )
      ),
      pw.SizedBox(height: 20),
      pw.Text('** นำส่งสินเชื่อ',
        style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 10),
        child: pw.Row(
          children: [
            buildConCredit('rsvn', traJanPro, 50, fontSizeHead),
            buildConCredit('Agent', traJanPro, 60, fontSizeHead),
            buildConCredit('Voucher', traJanPro, 80, fontSizeHead),
            // buildConCredit('AgentName', traJanPro, 60, fontSizeHead),
            buildConCredit('Amount', traJanPro, 50, fontSizeHead),
          ]
        ),
      ),
      pw.SizedBox(height: 5),
      /* pw.Padding(
        padding: const pw.EdgeInsets.only(left: 10),
        child: pw.Column(
          children: List.generate(data.details!.length, (index) {
            final detail = data.details![index];
            return pw.Row(
              children: [
                buildConCredit(detail.rsvn!, traJanPro, 50, fontSizeBody),
                buildConCredit(detail.extcode!, traJanPro, 60, fontSizeBody),
                buildConCredit(detail.refno!, pgVim, 80, fontSizeBody),
                // buildConCredit(detail.trrunno!, traJanPro, 60, fontSizeBody),
                buildConCredit(detail.amount!, traJanPro, 50, fontSizeBody),
              ]
            );
          }),
        ),
      ), */
    ];
  }

  pw.Widget buildHeaderContainer(String title, String label, pw.Font pgVim, double width, double padding) {
    return pw.Container(
      padding: pw.EdgeInsets.all(padding),
      width: width,
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      alignment: pw.Alignment.center,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Text(title,
            style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 2),
          pw.Text(label,
            style: pw.TextStyle(font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)),
          //pw.SizedBox(width: 20),
        ]
      )
    );
  }

  pw.Widget buildBodyCurrencyAndNoteCoins(String currency, String quantity, String rate, String amount, String coinsType, String coinsQuantity, String coinsAmount, pw.Font pgVim) {
    pw.Widget buildContainerCurrency(String title, pw.Font pgVim, double width, double padding, pw.Alignment alignment, {double? height}) {
      return pw.Container(
        padding: pw.EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        alignment: alignment,
        child: pw.Text(title,
          style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
      );
    }

    return pw.Container(
      child: pw.Row(
        children: <pw.Widget>[
          buildContainerCurrency(currency, pgVim, 30, 4.5, pw.Alignment.center),
          buildContainerCurrency(quantity, pgVim, 35, 2, pw.Alignment.centerRight, height: 16),
          buildContainerCurrency(rate, pgVim, 35, 2, pw.Alignment.centerRight, height: 16),
          buildContainerCurrency(amount, pgVim, 80, 2, pw.Alignment.centerRight, height: 16),
          buildContainerCurrency(coinsType, pgVim, 50, 4.5, pw.Alignment.center),
          buildContainerCurrency(coinsQuantity, pgVim, 50, 2, pw.Alignment.centerRight, height: 16),
          buildContainerCurrency(coinsAmount, pgVim, 80, 2, pw.Alignment.centerRight, height: 16),
        ]
      )
    );
  }

  pw.Widget buildTotal(String title, String label, pw.Font pgVim, String sum) {
    return pw.Container(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Container(
            padding: const pw.EdgeInsets.all(4.0),
            width: 110,
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(title,
                  style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 2),
                pw.Text(label,
                  style: pw.TextStyle(font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)),
              ]
            )
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(2),
            height: 23,
            width: 80,
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            alignment: pw.Alignment.centerRight,
            child: pw.Text(sum,
              style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold))),
        ]
      )
    );
  }
}
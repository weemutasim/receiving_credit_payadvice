import 'package:credit_payadvice_receiving/model/mdPayAdvance.dart';
import 'package:credit_payadvice_receiving/model/mdPayType.dart';
import 'package:credit_payadvice_receiving/model/mdTransactionAll.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../util/dateformat.dart';
import 'footer/footerA5.dart';
import 'header/headerA4Landscape.dart';

class NoteCoinsData {
  final double amount;
  final String qty;

  NoteCoinsData({required this.amount, required this.qty});
}

class NoteCurrency {
  final String amount;
  final String qty;
  final String rate;

  NoteCurrency({required this.amount, required this.qty, required this.rate});
}

class IncomReportAllA4Landscape {

  Future<Uint8List> genPDFTransactionAllA4Landscape({required List<TransactionAll> dataAll, required DateTime date, required String title, required List<CashAdvance> dataAdv, required List<CashAdvance> dataCredit, required List<PayType> payType}) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/Ticketing.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-regular.ttf");
    final trajanproBold = await rootBundle.load("assets/fonts/trajanpro-bold.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final traJanPro = pw.Font.ttf(trajanpro);
    final trajanprobold = pw.Font.ttf(trajanproBold);


    for(final data in dataAll) {
      List<CashAdvance> adv = dataAdv.where((item) => item.userid == data.userid).toList();
      List<CashAdvance> credit = dataCredit.where((item) => item.userid == data.userid).toList();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.only(top: .5 * PdfPageFormat.cm, left: .45 * PdfPageFormat.cm, right: .5 * PdfPageFormat.cm, bottom: .5 * PdfPageFormat.cm),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: headerReportIncomeA4Landscape(context, 'ใบนำส่งรายได้ฝ่ายบัตร', 'Income Report', date, logoblack, pgVim, traJanPro, data.name!, data.code!, adv, credit)
            );
          },
          build: (pw.Context context) {
            return bodyReport(context, pgVim, traJanPro, data, adv, credit, payType, trajanprobold);
          },
          footer: (pw.Context context) {
            return pw.Column(
              children: [
                footerReportA5(context, pgVim, traJanPro, 'Income Report', date, data.name!),
              ]
            );
          },
        )
      );
    }

    return pdf.save();
  }

  List<pw.Widget> bodyReport(pw.Context context, pw.Font pgVim, pw.Font traJanPro, TransactionAll data, List<CashAdvance> adv, List<CashAdvance> credit, List<PayType> payType, pw.Font trajanprobold) {
    double sumNoteCoinsAmount() {
      try {
        return data.notesandcoins!.fold(0.0, (total, note) => total + double.parse(note.amount ?? '0.0'));
      } catch (e) {
        return 0.0;
      }
    }

    double sumPayeshopAmount() {
      try {
        return data.payeshop!.fold(0.0, (total, payeshop) => total + double.parse(payeshop.amount ?? '0.0'));
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
        // print('Error: $e');
      }
      return NoteCoinsData(amount: amount, qty: qty);
    }

    NoteCurrency buildCurrency(String currencyCode) {
      String amount = '0.00';
      String qty = '0';
      String rate = '0.00';
      try {
        var note = data.notesandcoinsDetail!.firstWhere((element) => element.currencyCode == currencyCode);
        amount = note.amount!;
        qty = note.qty!;
        rate = note.rate!;
      } catch (e) {
        // print('Error: $e');
      }
      return NoteCurrency(amount: amount, qty: qty, rate: rate);
    }

    double sumCurrencyAmount() {
      try {
        return data.notesandcoinsDetail!.fold(0.0, (total, currency) => total + double.parse(currency.amount ?? '0.0'));
      } catch (e) {
        return 0.0;
      }
    }

    // double fontSizeHead = 7;
    double fontSizeBody = 9;
    double discount = 0.0;

    final Map<String, String> accMap = {
      for (var pay in payType) pay.acccode!: pay.shutname!,
    };

    //currency
    double currency = sumCurrencyAmount();

    List<CashAdvance> cashAdv = adv.where((item) => item.accode == '111').toList();
    List<CashAdvance> creditAdv = adv.where((item) => item.accode == '114').toList();
    double cashAdvAmt = cashAdv.fold(0.0, (prev, elem) => prev + (double.tryParse(elem.amount ?? '0.0') ?? 0.0));
    double creditAdvAmt = creditAdv.fold(0.0, (prev, elem) => prev + (double.tryParse(elem.amount ?? '0.0') ?? 0.0));

    List<CashAdvance> cashCredit = credit.where((item) => item.accode == '111').toList();
    List<CashAdvance> creditCredit = credit.where((item) => item.accode == '114').toList();
    double cashCreditAmt = cashCredit.fold(0.0, (prev, elem) => prev + (double.tryParse(elem.amount ?? '0.0') ?? 0.0));
    double creditCreditAmt = creditCredit.fold(0.0, (prev, elem) => prev + (double.tryParse(elem.amount ?? '0.0') ?? 0.0));

    // print('adv > ${payAdv.length}');
    // print('credit > ${credit.length}');

    //coins
    double noteCoinsAmount = sumNoteCoinsAmount();
    double creditcardAmount = data.creditcard!.isNotEmpty ? double.tryParse(data.creditcard![0].amount!) ?? 0.0 : 0.0;
    double payeshopAmount = sumPayeshopAmount();
    double grandTotal = noteCoinsAmount + creditcardAmount + payeshopAmount;
    double netGrandTotal = grandTotal - 0.0;

    pw.Widget buildConCredit(String text, pw.Font traJanPro, double width, double fontSize, {pw.Alignment alignment = pw.Alignment.center}) {
      return pw.Column(
        children: [
          pw.Container(
            width: width,
            // decoration: pw.BoxDecoration(border: pw.Border.all()),
            alignment: alignment,
            child: pw.Text(text,
              style: pw.TextStyle(font: pgVim, fontSize: fontSize))
          ),
          pw.SizedBox(height: 3)
        ]
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

    pw.Widget buildBodyContainer4(String title, String label, String sum, pw.Font pgVim, double width1, double width2, double height, double padding, int ckh, pw.Font trajanprobold) {
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
                style: pw.TextStyle(font: trajanprobold, fontSize: 8, fontWeight: pw.FontWeight.bold))
            ),    //pw.SizedBox(height: 20),
          ]
        )
      );
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
              style: pw.TextStyle(font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)), //255
            //pw.SizedBox(width: 20),
          ]
        )
      );
    }

    pw.Widget buildBodyContainer3(String title, String label, String sum, pw.Font pgVim, double width1, double width2, double height, double padding, int ckh, pw.Font traJanProBold) {
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
                style: pw.TextStyle(font: traJanProBold, fontSize: 8, fontWeight: pw.FontWeight.bold))
            ),    //pw.SizedBox(height: 20),
          ]
        )
      );
    }

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

    pw.Widget buildContainer2(String title, pw.Font pgVim, double width, double padding, pw.Alignment alignment, pw.Font trajanprobold, {double? height}) {
      return pw.Container(
        padding: pw.EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        alignment: alignment,
        child: pw.Text(title,
          style: pw.TextStyle(font: trajanprobold, fontSize: 8, fontWeight: pw.FontWeight.bold))
      );
    }

    pw.Widget buildContainer1(String title, pw.Font pgVim, double width, double padding, pw.Alignment alignment, {double? height}) {
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

    pw.Widget buildBodyCurrencyAndNoteCoins(String currency, String quantity, String rate, String amount, String coinsType, String coinsQuantity, String coinsAmount, pw.Font pgVim) {
      pw.Widget buildContainerCurrency(String title, double width, double padding, pw.Alignment alignment, {double? height}) {
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
            buildContainerCurrency(currency, 30, 4.5, pw.Alignment.center),
            buildContainerCurrency(rate, 30, 2, pw.Alignment.centerRight, height: 16),
            buildContainerCurrency(quantity, 30, 2, pw.Alignment.centerRight, height: 16), //35-50 15
            buildContainerCurrency(amount, 45, 2, pw.Alignment.centerRight, height: 16),
            buildContainerCurrency(coinsType, 40, 4.5, pw.Alignment.center),
            buildContainerCurrency(coinsQuantity, 35, 2, pw.Alignment.centerRight, height: 16),
            buildContainerCurrency(coinsAmount, 60, 2, pw.Alignment.centerRight, height: 16),
          ]
        )
      );
    }

    return <pw.Widget>[
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Container(
            width: 395,
            height: 335,
            /* decoration: pw.BoxDecoration(
              border: pw.Border.all()
            ), */
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Column(
                      children: <pw.Widget>[
                        buildHeaderContainer('บัตรเครดิต', 'Credit Card', pgVim, 120, 6.0),
                        // pw.SizedBox(width: 10),
                        buildBodyContainer3('(1) รวม', 'Total', formatter.format(creditcardAmount), pgVim, 70, 50, 21, 3.0, 1, trajanprobold),
                        // pw.SizedBox(height: 7),
                        buildHeaderContainer('เอฟซีคอยน์', 'FCcion', pgVim, 120, 6.0),
                        buildBodyContainer3('(2) รวม', 'Total', '0.00', pgVim, 70, 50, 21, 3.0, 1, trajanprobold),
                        // pw.SizedBox(height: 8),
                        buildHeaderContainer('อื่นๆ', 'Other', pgVim, 120, 6.0),
                        // pw.SizedBox(width: 10),
                        buildBodyContainer2('E-SHOP', 'Total', formatter.format(payeshopAmount), pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer2('VOUCHER', 'Total', '0.00', pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer2('CHEQUE', 'Total', '0.00', pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer2('PAY-IN', 'Total', '0.00', pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer2('TAX', 'Total', '0.00', pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer2('GIFT CERTIFICATE', 'Total', '0.00', pgVim, 70, 50, 15, 4.0, 0),
                        buildBodyContainer3('(3) รวม /Total', 'Total', formatter.format(payeshopAmount), pgVim, 70, 50, 15, 4.0, 0, trajanprobold),
                      ]
                    ),
                    pw.SizedBox(width: 6),
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Container(
                            child: pw.Row(
                              children: <pw.Widget>[
                                buildHeaderContainer('เงินสกุลต่างประเทศ', 'Foreign Currency', pgVim, 135, 6),
                                buildHeaderContainer('ธนบัตรและเหรียญกษาปณ์', 'Notes & Coins', pgVim, 135, 6),
                              ]
                            )
                          ),
                          buildBodyCurrencyAndNoteCoins('USD', buildCurrency('1').qty, buildCurrency('1').rate, formatter.format(double.parse(buildCurrency('1').amount)), '1000', buildNoteCoinsData('1000').qty, formatter.format(buildNoteCoinsData('1000').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('SGD', buildCurrency('5').qty, buildCurrency('5').rate, formatter.format(double.parse(buildCurrency('5').amount)), '500', buildNoteCoinsData('500').qty, formatter.format(buildNoteCoinsData('500').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('TWD', buildCurrency('9').qty, buildCurrency('9').rate, formatter.format(double.parse(buildCurrency('9').amount)), '100', buildNoteCoinsData('100').qty, formatter.format(buildNoteCoinsData('100').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('JPY', buildCurrency('4').qty, buildCurrency('4').rate, formatter.format(double.parse(buildCurrency('4').amount)), '50', buildNoteCoinsData('50').qty, formatter.format(buildNoteCoinsData('50').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('HKD', buildCurrency('6').qty, buildCurrency('6').rate, formatter.format(double.parse(buildCurrency('6').amount)), '20', buildNoteCoinsData('20').qty, formatter.format(buildNoteCoinsData('20').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('GBP', buildCurrency('3').qty, buildCurrency('3').rate, formatter.format(double.parse(buildCurrency('3').amount)), '10', buildNoteCoinsData('10').qty, formatter.format(buildNoteCoinsData('10').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('CNY', buildCurrency('8').qty, buildCurrency('8').rate, formatter.format(double.parse(buildCurrency('8').amount)), '5', buildNoteCoinsData('5').qty, formatter.format(buildNoteCoinsData('5').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('AUD', buildCurrency('7').qty, buildCurrency('7').rate, formatter.format(double.parse(buildCurrency('7').amount)), '2', buildNoteCoinsData('2').qty, formatter.format(buildNoteCoinsData('2').amount), pgVim),
                          buildBodyCurrencyAndNoteCoins('EUR', buildCurrency('2').qty, buildCurrency('2').rate, formatter.format(double.parse(buildCurrency('2').amount)), '1', buildNoteCoinsData('1').qty, formatter.format(buildNoteCoinsData('1').amount), pgVim),
                          pw.Container(
                            child: pw.Row(
                              children: <pw.Widget>[
                                buildHeaderContainer('(4) รวม', 'Total', pgVim, 60, 2.5), //130
                                buildContainer2(formatter.format(currency), pgVim, 75, 2, pw.Alignment.centerRight, trajanprobold, height: 20),
                                buildContainer1('0.50', pgVim, 40, 6.5, pw.Alignment.center),
                                buildContainer1(buildNoteCoinsData('0.50').qty, pgVim, 35, 2, pw.Alignment.centerRight, height: 20),
                                buildContainer1(formatter.format(buildNoteCoinsData('0.50').amount), pgVim, 60, 2, pw.Alignment.centerRight, height: 20),
                              ]
                            )
                          ),
                          pw.Container(
                            child: pw.Row(
                              children: <pw.Widget>[
                                buildContainer('รายได้รอบ 1 / Amount (First Collection)', pgVim, 135, 5, pw.Alignment.center),
                                buildContainer1('0.25', pgVim, 40, 5, pw.Alignment.center),
                                buildContainer1(buildNoteCoinsData('0.25').qty, pgVim, 35, 2, pw.Alignment.centerRight, height: 17),
                                buildContainer1(formatter.format(buildNoteCoinsData('0.25').amount), pgVim, 60, 2, pw.Alignment.centerRight, height: 17),
                              ]
                            )
                          ),
                          pw.Container(
                            child: pw.Row(
                              children: <pw.Widget>[
                                buildBodyContainer4('(5) เงินสด', 'Cash', '0.00', pgVim, 55, 80, 21, 3.0, 1, trajanprobold),
                                buildBodyContainer4('(6) รวม', 'Total', formatter.format(noteCoinsAmount), pgVim, 75, 60, 21, 3.0, 1, trajanprobold),
                              ]
                            )
                          ),
                        ]
                      )
                    ),
                  ]
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.SizedBox(
                      width: 240,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.SizedBox(height: 6),
                          pw.Text('หมายเหตุ ',
                            style: pw.TextStyle( font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 2),
                          pw.Text('Remark',
                            style: pw.TextStyle( font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                          pw.SizedBox(height: 10),
                          pw.Text('             _________________________________________________________________________',
                            style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                          pw.SizedBox(height: 10),
                          pw.Text('             _________________________________________________________________________',
                            style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                          pw.SizedBox(height: 10),
                          pw.Text('             _________________________________________________________________________',
                            style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal)),
                        ]
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Column(
                        children: <pw.Widget>[
                          buildTotal('รวมทั้งสิ้น', 'Grand Total', pgVim, formatter.format(grandTotal), trajanprobold),
                          buildTotal('หักรับคืนคูปอง', 'Refund', pgVim, formatter.format(discount), trajanprobold),
                          buildTotal('รวมรายได้สุทธิ์', 'Net Amount', pgVim, formatter.format(netGrandTotal), trajanprobold),
                        ]
                      ) 
                    )
                  ]
                ),
              ]
            )
          ),
          pw.Container(
            width: 400,
            height: 335,
            margin: const pw.EdgeInsets.only(left: 17),
            /* decoration: pw.BoxDecoration(
              border: pw.Border.all()
            ), */
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                if(adv.isNotEmpty) pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      decoration: const pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                        color: PdfColors.grey400,
                      ),
                      child: pw.Text('Pay advance',
                        style: pw.TextStyle( font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.normal)),
                    )
                  ]
                ),
                pw.SizedBox(height: 5),
                ...List.generate(adv.length, (index) {
                  final detail = adv[index];
                  return pw.Row(
                    children: [
                      buildConCredit(detail.rsvn!, traJanPro, 40, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      buildConCredit('${detail.agentcode} ${detail.agentname!}', traJanPro, 250, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      // buildConCredit(detail.voucher!, pgVim, 55, fontSizeBody, alignment:pw.Alignment.center),
                      buildConCredit(accMap[detail.accode] ?? '-', pgVim, 55, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      buildConCredit(detail.amount!, traJanPro, 55, fontSizeBody, alignment:pw.Alignment.centerRight),
                    ]
                  );
                }),
                if(adv.isNotEmpty) pw.Divider(thickness: .5),
                if(adv.isNotEmpty) pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 150,
                      /* decoration: pw.BoxDecoration(
                        border: pw.Border.all()
                      ), */
                      child: pw.Column(
                        children: [
                          if(cashAdv.isNotEmpty) pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total Cash', style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)), 
                              pw.Text(formatter.format(cashAdvAmt), style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)), 
                            ]
                          ),
                          pw.SizedBox(height: 3),
                          if(creditAdv.isNotEmpty) pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total Credit', style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(formatter.format(creditAdvAmt), style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            ]
                          ),
                          pw.SizedBox(height: 3),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Grand Total', style: pw.TextStyle(font: trajanprobold, fontSize: 11, fontWeight: pw.FontWeight.bold)),
                              pw.Text(formatter.format((cashAdvAmt + creditAdvAmt)), style: pw.TextStyle(font: trajanprobold, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            ]
                          )
                        ]
                      )
                    )
                  ]
                ),
                // pw.SizedBox(height: 5),
                if(credit.isNotEmpty) pw.Row(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      decoration: const pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                        color: PdfColors.grey400,
                      ),
                      child: pw.Text('Credit',
                        style: pw.TextStyle( font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.normal)),
                    )
                  ]
                ),
                pw.SizedBox(height: 5),
                ...List.generate(credit.length, (index) {
                  final detail = credit[index];
                  return pw.Row(
                    children: [
                      buildConCredit(detail.rsvn!, traJanPro, 40, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      buildConCredit('${detail.agentcode} ${detail.agentname!}', traJanPro, 250, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      // buildConCredit(detail.voucher!, pgVim, 55, fontSizeBody, alignment:pw.Alignment.center),
                      buildConCredit(accMap[detail.accode] ?? '-', pgVim, 55, fontSizeBody, alignment:pw.Alignment.centerLeft),
                      buildConCredit(detail.amount!, traJanPro, 55, fontSizeBody, alignment:pw.Alignment.centerRight),
                    ]
                  );
                }),
                if(credit.isNotEmpty) pw.Divider(thickness: .5),
                if(credit.isNotEmpty) pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 150,
                      /* decoration: pw.BoxDecoration(
                        border: pw.Border.all()
                      ), */
                      child: pw.Column(
                        children: [
                          if(cashCredit.isNotEmpty) pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total Cash', style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)), 
                              pw.Text(formatter.format(cashCreditAmt), style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            ]
                          ),
                          pw.SizedBox(height: 3),
                          if(creditCredit.isNotEmpty) pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total Credit', style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(formatter.format(creditCreditAmt), style: pw.TextStyle(font: traJanPro, fontSize: 10, fontWeight: pw.FontWeight.bold)), 
                            ]
                          ),
                          pw.SizedBox(height: 3),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Grand Total', style: pw.TextStyle(font: trajanprobold, fontSize: 11, fontWeight: pw.FontWeight.bold)),
                              pw.Text(formatter.format((creditCreditAmt + cashCreditAmt)), style: pw.TextStyle(font: trajanprobold, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            ]
                          )
                        ]
                      )
                    )
                  ]
                ),
              ]
            ),
          )
        ]
      ),
      // pw.NewPage(),
    ];
  }

  pw.Widget buildTotal(String title, String label, pw.Font pgVim, String sum, pw.Font trajanprobold) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: <pw.Widget>[
        pw.Container(
          width: 96,
          padding: const pw.EdgeInsets.all(4.0),
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
          width: 60,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          alignment: pw.Alignment.centerRight,
          child: pw.Text(sum,
            style: pw.TextStyle(font: label != 'Refund' ? trajanprobold : pgVim, fontSize: label != 'Refund' ? 8 : 7, fontWeight: label != 'Refund' ? pw.FontWeight.bold : null)
          )
        ),
      ]
    );
  }
}
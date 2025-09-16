import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../model/mdPayAdvance.dart';
import '../model/mdPayType.dart';
import '../util/dateformat.dart';
import 'footer/footer.dart';
import 'header/header.dart';

class CreditReport {
  List<Map<String, dynamic>>? data;
  List<PayType>? payType;

  Future<Uint8List> genPDFCreditReport({required DateTime date, required List<Map<String, dynamic>> dataCash, required List<PayType> dataPayType, required String title, required String titleEng}) async {
    data = dataCash;
    payType = dataPayType;

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/logo_cm_bk.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-bold.ttf");
    final traJanPro = pw.Font.ttf(trajanpro);

    double sumAmt = dataCash.fold(0.0, (prev, element) => prev + element['sumAmt']);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.only(left: 1.5 * PdfPageFormat.cm, right: 1 * PdfPageFormat.cm, bottom: 1 * PdfPageFormat.cm, top: 1 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: headerReport(context, title, titleEng, date, logoblack, pgVim, traJanPro, '', '') + colheader(traJanPro) + [pw.SizedBox(height: 5)]
          );
        },
        build: (pw.Context context) {
          return bodyCancelReport(pgVim, traJanPro, sumAmt);
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: <pw.Widget>[
              footer(context, pgVim, traJanPro, "Credit Report"),
            ]
          );
        },
      )
    );

    return pdf.save();
  }

  pw.Widget underLine(double indent) {
    return pw.Column(
      children: <pw.Widget>[
        pw.SizedBox(height: 3),
        pw.Divider(color: PdfColors.grey400, height: 1, indent: indent, endIndent: 0),
        pw.SizedBox(height: 3),
      ]
    );
  }

  List<pw.Widget> colheader(pw.Font traJanPro) {
    pw.Widget buildContainerHeader(String title, double height, double width, pw.Border border, pw.Font tranJanFont) {
      return pw.Container(
        height: height,
        width: width,
        decoration: pw.BoxDecoration(border: border),
        alignment: pw.Alignment.center,
        child: pw.Text(title,
          style: pw.TextStyle(font: tranJanFont, fontSize: 11, fontWeight: pw.FontWeight.bold)),
      );
    }

    return <pw.Widget>[
      pw.Row(
        children: [
          buildContainerHeader('rsvn', 30, 55, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5)), traJanPro),
          buildContainerHeader('', 30, 40, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5), left: pw.BorderSide(width: 0.5)), traJanPro),
          buildContainerHeader('Agent', 30, 210, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5)), traJanPro),
          buildContainerHeader('Voucher', 30, 85, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5), left: pw.BorderSide(width: 0.5)), traJanPro),
          buildContainerHeader('Paytype', 30, 75, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5), left: pw.BorderSide(width: 0.5)), traJanPro),
          buildContainerHeader('Amount', 30, 60, const pw.Border(bottom: pw.BorderSide(width: 0.5), top: pw.BorderSide(width: 0.5), left: pw.BorderSide(width: 0.5)), traJanPro),
        ],
      ),
    ];
  }

  List<pw.Widget> bodyCancelReport(pw.Font pgVim, pw.Font traJanPro, double sumAmt) { //Body
    final Map<String, String> accMap = {
      for (var pay in payType!) pay.acccode!: pay.shutname!,
    };

    pw.Widget buildContainerBody(String title, double width, pw.Font traJanPro, pw.Alignment alignment, {pw.EdgeInsets padding = const pw.EdgeInsets.only(left: 5)}) { 
      return pw.Column(
        children: [
          pw.Container(
          width: width,
          alignment: alignment,
          padding: padding,
          child:  pw.Text(title,
            style: pw.TextStyle(font: pgVim, fontSize: 9)),
        ),
        pw.SizedBox(height: 3)
        ]
      );
    }

    return <pw.Widget>[
      pw.Column(
        children: [
          ...List.generate(data!.length, (index) {
            final item = data![index];
            return pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      margin: const pw.EdgeInsets.all(3),
                      alignment: pw.Alignment.centerLeft,
                      padding: const pw.EdgeInsets.all(3),
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(8),
                        color: PdfColors.grey300
                      ),
                      child: pw.Text(item['username'].toString(),
                        style: pw.TextStyle(font: pgVim, fontSize: 9, color: PdfColors.black)),
                    ),
                  ]
                ),
                ...List.generate(item['detail'].length, (index) {
                  final data = item['detail'][index];

                  return pw.Row(
                    children: [
                      buildContainerBody(data.rsvn!, 55, traJanPro, pw.Alignment.centerLeft),
                      buildContainerBody(data.agentcode!, 40, traJanPro, pw.Alignment.centerLeft),
                      buildContainerBody(data.agentname!, 210, pgVim, pw.Alignment.centerLeft),
                      buildContainerBody(data.voucher!, 85, traJanPro, pw.Alignment.centerLeft),
                      buildContainerBody(accMap[data.accode] ?? '-', 75, traJanPro, pw.Alignment.centerLeft),
                      buildContainerBody(formatter.format(double.parse(data.amount ?? '0.00')), 60, traJanPro, pw.Alignment.centerRight, padding: const pw.EdgeInsets.only(right: 5)),
                    ]
                  );
                })
              ]
            );
          }),
        ]
      ),
      pw.SizedBox(height: 3),
      underLine(0),
      pw.Padding(
        padding: const pw.EdgeInsets.only(right: 2, top: 3, bottom: 3),
        child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Grand Total  ${formatter.format(sumAmt)}', style: pw.TextStyle(font: traJanPro, fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ]
        ),
      ),
      underLine(0),
    ];
  }
}
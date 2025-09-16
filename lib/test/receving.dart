/* import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../model/mdPayAdvance.dart';
import '../util/dateformat.dart';

class Recevingvoucher {
  CashAdvance? cashAdvance;

  Future<Uint8List> genPDFRecevingvoucher({required DateTime date, required CashAdvance data }) async {
    cashAdvance = data;

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/logo_cm_bk.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-regular.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final traJanPro = pw.Font.ttf(trajanpro);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5.portrait.landscape,
        margin: const pw.EdgeInsets.only(top: .5 * PdfPageFormat.cm, left: .5 * PdfPageFormat.cm, right: .5 * PdfPageFormat.cm, bottom: .5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: headerReport(context, 'ใบสำคัญรับ', 'Receving Voucher', logoblack, pgVim, traJanPro)
          );
        },
        build: (pw.Context context) {
          return bodyReport(pgVim, traJanPro);
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              footerReport(context, pgVim, traJanPro, date),
            ]
          );
        },
      )
    );

    return pdf.save();
  }

  headerReport(pw.Context context, String titleThai, String titleEng, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro) {
    List<String> listDate = ['D', 'D', 'M', 'M', 'Y', 'Y'];
    List<String> listDateNo = dateformat(date: DateTime.now(), type: 'dmy').split('');

    pw.Widget dateNo(double width, double height, String title, pw.Font pgVim, { int chk = 0}) {
      return pw.Container(
        width: width,
        height: height,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border(
            top: const pw.BorderSide(width: .5, color: PdfColors.black),
            left: const pw.BorderSide(width: .5, color: PdfColors.black),
            right: const pw.BorderSide(width: .5, color: PdfColors.black),
            bottom: chk == 1 ? const pw.BorderSide(width: .5, color: PdfColors.black) : pw.BorderSide.none
          )
        ),
        child: pw.Text(title, style: pw.TextStyle(font: pgVim, fontSize: 7))
      );
    }

    pw.Widget generateDateNo(dynamic listDate, pw.Font traJanPro, int chk) {
      return pw.Row(
        children: List.generate(listDate.length, (index) {
          final data = listDate[index];
          final dateNo = listDateNo[index];

          return pw.Container(
            width: 10,
            height: 12.5,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: const pw.BorderSide(width: .5, color: PdfColors.black),
                bottom: const pw.BorderSide(width: .5, color: PdfColors.black),
                top: chk == 0 ? const pw.BorderSide(width: .5, color: PdfColors.black) : pw.BorderSide.none
              )
            ),
            child: chk == 0 ? pw.Text(data, style: pw.TextStyle(font: traJanPro, fontSize: 7)) : pw.Text(dateNo, style: pw.TextStyle(font: traJanPro, fontSize: 7))
          );
        }) 
      );
    }

    return [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                logoblack,
                width: 100,
              ),
              pw.SizedBox(width: 84),
              pw.Column(
                children: [
                  pw.Text(titleThai, style: pw.TextStyle(font: pgVim, fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  pw.Text(titleEng, style: pw.TextStyle(font: pgVim, fontSize: 15, fontWeight: pw.FontWeight.bold))
                ]
              ),
              pw.SizedBox(width: 84),
              pw.Column(
                children: [
                  pw.Row(
                    children: [
                      dateNo(60, 25, 'เลขที่ /No.', pgVim),
                      dateNo(60, 25, '', pgVim),
                    ]
                  ),
                  pw.Row(
                    children: [
                      dateNo(60, 6, '', pgVim),
                      dateNo(60, 6, '', pgVim),
                    ]
                  ),
                  pw.Row(
                    children: [
                      dateNo(60, 25, 'วันที่ /DATE.', pgVim, chk: 1),
                      pw.Column(
                        children: [
                          generateDateNo(listDate, traJanPro, 0),
                          generateDateNo(listDate, traJanPro, 1),
                        ]
                      )
                    ]
                  ),
                ]
              ),
            ]
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 20, left: 20),
            child: pw.Text('รับเงินจาก /Received From _______________________________________________________________________________________', style: pw.TextStyle(font: pgVim, fontSize: 8))
          ),
        ]
      )
    ];
  }

  List<pw.Widget> bodyReport(pw.Font pgVim, pw.Font traJanPro) {
    return [
      pw.Column(
        children: [
          // pw.Text('Text >>>')
        ]
      )
    ];
  }

  footerReport(pw.Context context, pw.Font pgVim, pw.Font traJanPro, DateTime date) {
    List<String> listTitle = ['จัดทำโดย /Prepared By', 'รับเงินโดย /Received By', 'ตรวจสอบโดย /Checked By', 'ผ่านรายการโดย /Posted By']; 

    pw.Widget choice(String title){
      return pw.Row(
        children: [
          pw.Container(
            width: 10,
            height: 10,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(
                color: PdfColors.black,
                width: .5,
              ),
            ),
          ),
          pw.SizedBox(width: 2.5),
          pw.Text(title, style: pw.TextStyle(font: pgVim, fontSize: 7)),
        ]
      );
    }

    return pw.Container(
      width: 600,
      height: 140,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: .5, color: PdfColors.black)
      ),
      child: pw.Column(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(7),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('รับชำระโดย', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                pw.SizedBox(width: 10),
                choice('เงินสด __________________________ บาท (____________________________________________________)'),
              ]
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5, bottom: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                choice('บัตรเครดิต'),
                pw.SizedBox(width: 5),
                choice('เงินโอน'),
                pw.SizedBox(width: 5),
                choice('เช็คเลขที่ _______________________ ธนาคาร _________________________ ลงวันที่ ___________ จำนวนเงิน __________________ บาท'),
              ]
            ), 
          ),
          pw.Container(
            width: 600,
            height: 20,
            padding: const pw.EdgeInsets.only(left: 5),
            alignment: pw.Alignment.centerLeft,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(width: .5, color: PdfColors.black),
                bottom: pw.BorderSide(width: .5, color: PdfColors.black),
              ),
            ),
            child: pw.Text('หมายเหตุ /Remarks      ________________________________________________________________', style: pw.TextStyle(font: pgVim, fontSize: 7))
          ),
          pw.Row(
            children: List.generate(listTitle.length, (index) {
              final data = listTitle[index];
              return pw.Container(
                width: 141.7,
                height: 20,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  border: index == 3
                  ? const pw.Border(
                      bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
                    )
                  : const pw.Border(
                      bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
                      right: pw.BorderSide(width: 0.5, color: PdfColors.black),
                    ),
                ),
                child: pw.Text(data, style: pw.TextStyle(font: pgVim, fontSize: 7))
              );
            }) 
          ),
          pw.Row(
            children: List.generate(4, (index) {
              return pw.Container(
                width: 141.7,
                height: 61,
                decoration: pw.BoxDecoration(
                  border: index == 3 ? null : const pw.Border(
                      right: pw.BorderSide(width: 0.5, color: PdfColors.black),
                    ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(height: 22),
                    pw.Text(index == 1 ? '${cashAdvance!.name?.split(' ')[0]}' : '________________________', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                    pw.SizedBox(height: 4),
                    pw.Text(index == 1 ? '(     ${cashAdvance!.name}     )' : '(                                        )', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                    pw.SizedBox(height: 4),
                    pw.Text(index == 1 ? 'วันที่ /Date   ${dateformat(date: date, type: 'dsn')}' : 'วันที่ /Date _______________', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                  ]
                )
              );
            })
          )
        ]
      )
    );
  }
} */
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class Recevingvoucher {
    Future<Uint8List> genPDFRecevingvoucher({required DateTime date/* , required PdfPageFormat formatter */}) async {

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/logo_cm_bk.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-regular.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final traJanPro = pw.Font.ttf(trajanpro);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.only(top: .5 * PdfPageFormat.cm, left: .5 * PdfPageFormat.cm, right: .5 * PdfPageFormat.cm, bottom: .5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: headerReport(context, 'ใบสำคัญรับ', 'Receving Voucher', date, logoblack, pgVim, traJanPro)
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

  footerReport(pw.Context context, pw.Font pgVim, pw.Font traJanPro, DateTime date) {
    List<String> listTitle = ['จัดทำโดย /Prepared By', 'รับเงินโดย /Received By', 'ตรวจสอบโดย /Checked By', 'ผ่านรายการโดย /Posted By']; 

    pw.Widget choice(String title){
      return pw.Row(
        children: [
          pw.Container(
            width: 5,
            height: 5,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(
                color: PdfColors.black,
                width: .5,
              ),
            ),
          ),
          pw.SizedBox(width: 2.5),
          pw.Text(title, style: pw.TextStyle(font: pgVim, fontSize: 5)),
        ]
      );
    }

    return pw.Container(
      width: 391.2,
      height: 100,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: .5, color: PdfColors.black)
      ),
      child: pw.Column(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('รับชำระโดย', style: pw.TextStyle(font: pgVim, fontSize: 5)),
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
                choice('เช็คเลขที่ _______________________ ธนาคาร ____________________ ลงวันที่ ___________ จำนวนเงิน __________________ บาท'),
              ]
            ), 
          ),
          pw.Container(
            width: 391.2,
            height: 15,
            padding: const pw.EdgeInsets.only(left: 5),
            alignment: pw.Alignment.centerLeft,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(width: .5, color: PdfColors.black),
                bottom: pw.BorderSide(width: .5, color: PdfColors.black),
              ),
            ),
            child: pw.Text('หมายเหตุ /Remarks      ________________________________________________________________', style: pw.TextStyle(font: pgVim, fontSize: 5))
          ),
          pw.Row(
            children: List.generate(listTitle.length, (index) {
              final data = listTitle[index];
              return pw.Container(
                width: 97.80,
                height: 15,
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
                child: pw.Text(data, style: pw.TextStyle(font: pgVim, fontSize: 5))
              );
            }) 
          ),
          pw.Row(
            children: List.generate(4, (index) {
              return pw.Container(
                width: 97.80,
                height: 45,
                decoration: pw.BoxDecoration(
                  border: index == 3 ? null : const pw.Border(
                      right: pw.BorderSide(width: 0.5, color: PdfColors.black),
                    ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(height: 18),
                    pw.Text('________________________', style: pw.TextStyle(font: pgVim, fontSize: 5)),
                    pw.SizedBox(height: 4),
                    pw.Text('(                                        )', style: pw.TextStyle(font: pgVim, fontSize: 5)),
                    pw.SizedBox(height: 4),
                    pw.Text('วันที่ /Date _______________', style: pw.TextStyle(font: pgVim, fontSize: 5)),
                  ]
                )
              );
            })
          )
        ]
      )
    );
  }

  headerReport(pw.Context context, String titleThai, String titleEng, DateTime date, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro) {
    List<String> listDate = ['D', 'D', 'M', 'M', 'Y', 'Y'];

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
        child: pw.Text(title, style: pw.TextStyle(font: pgVim, fontSize: 5))
      );
    }

    pw.Widget generateDateNo(dynamic listDate, pw.Font traJanPro, int chk) {
      return pw.Row(
        children: List.generate(listDate.length, (index) {
          final data = listDate[index];
          return pw.Container(
            width: 7,
            height: 7.5,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: const pw.BorderSide(width: .5, color: PdfColors.black),
                bottom: const pw.BorderSide(width: .5, color: PdfColors.black),
                top: chk == 0 ? const pw.BorderSide(width: .5, color: PdfColors.black) : pw.BorderSide.none
              )
            ),
            child: chk == 0 ? pw.Text(data, style: pw.TextStyle(font: traJanPro, fontSize: 4)) : pw.Text('', style: pw.TextStyle(font: traJanPro, fontSize: 4))
          );
        }) 
      );
    }

    return [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Image(
                logoblack,
                width: 60,
              ),
              pw.SizedBox(width: 84),
              pw.Column(
                children: [
                  pw.Text(titleThai, style: pw.TextStyle(font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text(titleEng, style: pw.TextStyle(font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.bold))
                ]
              ),
              pw.SizedBox(width: 84),
              pw.Column(
                children: [
                  pw.Row(
                    children: [
                      dateNo(40, 15, 'เลขที่ /No.', pgVim),
                      dateNo(42, 15, '', pgVim),
                    ]
                  ),
                  pw.Row(
                    children: [
                      dateNo(40, 3, '', pgVim),
                      dateNo(42, 3, '', pgVim),
                    ]
                  ),
                  pw.Row(
                    children: [
                      dateNo(40, 15, 'วันที่ /DATE.', pgVim, chk: 1),
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
            padding: const pw.EdgeInsets.only(top: 10, left: 10),
            child: pw.Text('รับเงินจาก /Received From _______________________________________________________________________________________', style: pw.TextStyle(font: pgVim, fontSize: 5))
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
}
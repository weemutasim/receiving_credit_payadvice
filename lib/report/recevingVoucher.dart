import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../model/mdPayAdvance.dart';
import '../util/dateformat.dart';
import 'package:number_to_thai_words/number_to_thai_words.dart';

class Recevingvoucher {
  CashAdvance? cashAdvance;

  Future<Uint8List> genPDFRecevingvoucher({required DateTime date, required CashAdvance data}) async {
    cashAdvance = data;

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoblack = pw.MemoryImage((await rootBundle.load('assets/images/logo_cm_bk.jpg')).buffer.asUint8List());
    final pgvim = await rootBundle.load("assets/fonts/pgvim.ttf");
    final trajanpro = await rootBundle.load("assets/fonts/trajanpro-regular.ttf");
    final trajanprobold = await rootBundle.load("assets/fonts/trajanpro-bold.ttf");
    final pgVim = pw.Font.ttf(pgvim);
    final traJanPro = pw.Font.ttf(trajanpro);
    final traJanProBold = pw.Font.ttf(trajanprobold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5.portrait.landscape,
        margin: const pw.EdgeInsets.only(top: .5 * PdfPageFormat.cm, left: .6 * PdfPageFormat.cm, right: .6 * PdfPageFormat.cm, bottom: .5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: headerReport(context, 'ใบสำคัญรับ', 'Receving Voucher', logoblack, pgVim, traJanPro)
          );
        },
        build: (pw.Context context) {
          return bodyReport(pgVim, traJanPro, traJanProBold);
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              footerReport(context, pgVim, traJanPro, date, traJanProBold),
            ]
          );
        },
      )
    );

    return pdf.save();
  }

  headerReport(pw.Context context, String titleThai, String titleEng, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro) {
    List<String> listDateNo = dateformat(date: DateTime.now(), type: 'dmy').split('');
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
            padding: const pw.EdgeInsets.only(top: 5, left: 20, bottom: 4),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('รับเงินจาก /Received From     ', style: pw.TextStyle(font: pgVim, fontSize: 8)),
                pw.Text('${cashAdvance!.agentname}', style: pw.TextStyle(font: traJanPro, fontSize: 9))
              ]
            )
          ),
        ]
      )
    ];
  }

  List<pw.Widget> bodyReport(pw.Font pgVim, pw.Font traJanPro, pw.Font traJanProBold) {
    List<String> title = ['รหัสบัญชี', 'ชื่อบัญชี่', 'เดบิต', 'เครดิต'];
    List<String> titleEng = ['Accounr Code', 'Account Name', 'Debit', 'Credit'];

    List<String> col1 = ['1', '0', '0', '0', '0', '0', '0', '2', '0', '1'];
    List<String> col2 = ['1', '2', '2', '0', '0', '0', '0', '0', '0', '0'];
    List<String> col3 = ['1', '2', '3', '0', '0', '0', '0', '0', '0', '0'];
    List<String> col4 = ['1', '0', '1', '0', '0', '0', '4', '0', '2', '2'];
    List<String> col5 = ['1', '4', '8', '0', '0', '0', '0', '1', '0', '0'];
    List<String> col6 = ['2', '1', '5', '0', '0', '0', '0', '1', '0', '0'];
    List<String> col7 = ['2', '1', '6', '0', '0', '0', '0', '1', '0', '0'];
    List<String> col8 = ['2', '3', '9', '0', '0', '0', '0', '2', '0', '0'];
    List<String> col11 = ['1', '2', '0', '0', '0', '0', '0', '1', '0', '1'];
    List<String> col12 = ['2', '3', '9', '0', '0', '0', '0', '1', '0', '0'];

    pw.Row boxGenerate(List<String> data, String accName){
      return pw.Row(
        children: [
          ...List.generate(data.length, (index) {
            final colData = data[index];

            return pw.Container(
              width: 14,
              height: 12.5,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: .5, color: PdfColors.black)
              ),
              child: pw.Text(colData, style: pw.TextStyle(font: pgVim, fontSize: 7)),
            );
          }),
          pw.Container(
            width: 140,
            height: 12.5,
            padding: const pw.EdgeInsets.only(left: 10),
            alignment: pw.Alignment.centerLeft,
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(width: .5, color: PdfColors.black), right: pw.BorderSide(width: .5, color: PdfColors.black))
            ),
            child: pw.Text(accName, style: pw.TextStyle(font: pgVim, fontSize: 7)),
          ),
          ...List.generate(20, (index) {
              return pw.Container(
              width: 14,
              height: 12.5,
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: .5, color: PdfColors.black), right: pw.BorderSide(width: .5, color: PdfColors.black))
              ),
            );
          })
        ]
      );
    }

    pw.Row boxGenerateEmpty(int data){
      return pw.Row(
        children: [
          ...List.generate(data, (index) {
            return pw.Container(
              width: 14,
              height: 12.5,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: .5, color: PdfColors.black)
              ),
            );
          }),
          pw.Container(
            width: 140,
            height: 12.5,
            alignment: pw.Alignment.center,
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(width: .5, color: PdfColors.black), bottom: pw.BorderSide(width: .5, color: PdfColors.black), right: pw.BorderSide(width: .5, color: PdfColors.black),)
            ),
          ),
          ...List.generate(20, (index) {
              return pw.Container(
              width: 14,
              height: 12.5,
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: .5, color: PdfColors.black), right: pw.BorderSide(width: .5, color: PdfColors.black))
              ),
            );
          })
        ]
      );
    }

    return [
      pw.Column(
        children: [
          pw.Row(
            children: List.generate(title.length, (index) {
              final data = title[index];
              final dataEng = titleEng[index];

              return pw.Container(
                width: 140,
                height: 20,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: index == 0 ? const pw.BorderSide(width: .5, color: PdfColors.black) : pw.BorderSide.none,
                    top: const pw.BorderSide(width: .5, color: PdfColors.black),
                    bottom: const pw.BorderSide(width: .5, color: PdfColors.black),
                    right: const pw.BorderSide(width: .5, color: PdfColors.black),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(data, style: pw.TextStyle(font: pgVim, fontSize: 7)),
                    pw.Text(dataEng, style: pw.TextStyle(font: pgVim, fontSize: 7))
                  ]
                )
              );
            }) 
          ),
          boxGenerate(col1, 'เงินสดรับ-รายได้'),
          boxGenerate(col2, 'บัตรเครดิต'),
          boxGenerate(col3, 'เช็ครับลงวันที่ล่วงหน้า'),
          boxGenerate(col4, 'เงินฝากธนาคาร - Kbank (เชิงทะเล)'),
          boxGenerate(col5, 'ถาษีหัก ณ ที่จ่าย - ปีนี้'),
          boxGenerate(col6, 'รายได้รับล่วงหน้า (Non-Vat)'),
          boxGenerate(col7, 'รายได้บัตร - รับล่วงหน้า (Non-Vat)'),
          boxGenerate(col8, 'ภาษีขายที่ยังไม่ครบกำหนดชำระ'),
          boxGenerateEmpty(10),
          boxGenerateEmpty(10),
          boxGenerate(col11, 'ลูกหนี้การค้า'),
          boxGenerate(col12, 'ภาษีขาย'),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 280,
                height: 13,
                alignment: pw.Alignment.center,
                decoration: const pw.BoxDecoration(
                  border: pw.Border(right: pw.BorderSide(width: .5, color: PdfColors.black), left: pw.BorderSide(width: .5, color: PdfColors.black))
                ),
                child:   pw.Text('รวม /Total', style: pw.TextStyle(font: pgVim, fontSize: 7)),
              ),
              ...List.generate(20, (index) {
                return pw.Container(
                  width: 14,
                  height: 13,
                  alignment: pw.Alignment.center,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(right: pw.BorderSide(width: .5, color: PdfColors.black))
                  ),
                );
              })
            ]
          )
        ]
      )
    ];
  }

  footerReport(pw.Context context, pw.Font pgVim, pw.Font traJanPro, DateTime date, pw.Font traJanProBold) {
    List<String> listTitle = ['จัดทำโดย /Prepared By', 'รับเงินโดย /Received By', 'ตรวจสอบโดย /Checked By', 'ผ่านรายการโดย /Posted By']; 
    final String? thaiWords;
    
    if(cashAdvance!.accode == '111'){
      thaiWords = NumberToThaiWords.convert(double.parse(cashAdvance!.amount ?? '0.0'));
    } else if(cashAdvance!.accode == '114'){
      thaiWords = NumberToThaiWords.convert(double.parse(cashAdvance!.amount ?? '0.0'));
    } else {
      thaiWords = NumberToThaiWords.convert(double.parse(cashAdvance!.amount ?? '0.0'));
    }

    pw.Widget choice(String title, String check){
      return pw.Row(
        children: [
          pw.Container(
            width: 10,
            height: 10,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(
                color: PdfColors.black,
                width: .5,
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 13),
              child: pw.Text(check)
            )
          ),
          pw.SizedBox(width: 2.5),
          pw.Text(title, style: pw.TextStyle(font: pgVim, fontSize: 7)),
        ]
      );
    }

    return pw.Container(
      width: 560,
      height: 119,
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
                choice('เงินสด', cashAdvance!.accode == '111' ? '/' : ''),
                cashAdvance!.accode == '111' ? pw.Text( '          ${formatter.format(double.parse(cashAdvance!.amount ?? '0.0'))}          ', style: pw.TextStyle(font: traJanPro, fontSize: 8)) :
                pw.Text(' ________________________ ', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                pw.Text('บาท     ${cashAdvance!.accode == '111' ? '(           $thaiWords           )' : '_______________________________________'}', style: pw.TextStyle(font: pgVim, fontSize: 7)),
              ]
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5, bottom: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                choice('บัตรเครดิต', cashAdvance!.accode == '114' ? '/' : ''),
                pw.SizedBox(width: 5),
                choice('เงินโอน', cashAdvance!.accode == '133' ? '/' : ''),
                pw.SizedBox(width: 5),
                choice('เช็คเลขที่ _______________________ ธนาคาร _______________________ ลงวันที่ ____________ จำนวนเงิน', ''),
                cashAdvance!.accode == '114' ? pw.Text('     ${formatter.format(double.parse(cashAdvance!.amount ?? '0.0'))}     ', style: pw.TextStyle(font: traJanPro, fontSize: 8)) :
                pw.Text(' ________________ ', style: pw.TextStyle(font: pgVim, fontSize: 7)),
                pw.Text('บาท', style: pw.TextStyle(font: pgVim, fontSize: 7))
              ]
            ), 
          ),
          pw.Container(
            width: 560,
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
                width: 140,
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
                width: 140,
                height: 40,
                decoration: pw.BoxDecoration(
                  border: index == 3 ? null : const pw.Border(
                      right: pw.BorderSide(width: 0.5, color: PdfColors.black),
                    ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(height: 10),
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
}



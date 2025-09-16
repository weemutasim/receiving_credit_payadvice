import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../util/dateformat.dart';

pw.Container footerReportA5(pw.Context context, pw.Font pgVim, pw.Font traJanPro, String title, DateTime date, String saleName) {
  double fontSize = 5.5;
  double widthFooter = 18;

  pw.Widget buildSender(String title, String label, { String saleName = ''}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6.0),
      width: 195,
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      alignment: pw.Alignment.center,
      child: pw.Column(
        crossAxisAlignment:pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            width: 40,
            alignment: pw.Alignment.center,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(title,
                    style: pw.TextStyle( font: pgVim, fontSize: 6, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(label,
                    style: pw.TextStyle( font: pgVim, fontSize: 5, fontWeight: pw.FontWeight.normal)),
                ]
              )
            ),
          pw.SizedBox(height: 5),
          pw.Text(saleName.isNotEmpty ?'(              ${saleName.split(' ')[0]}              )' : '(________________________________)',
            style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
          pw.SizedBox(height: 8),
          pw.Text(saleName.isNotEmpty ?'(              $saleName              )' : '(________________________________)',
            style: pw.TextStyle(font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
          pw.SizedBox(height: 8),
          pw.Text(saleName.isNotEmpty ? dateformat(date: DateTime.now(), type: 'dsn') : '______/______/______', 
            style: pw.TextStyle(font: traJanPro, fontSize: 7, fontWeight: pw.FontWeight.normal)),
        ]
      )
    );
  }

  return pw.Container(
    child: pw.Column(
      children: [
        // if(context.pageNumber <= 2)
        pw.SizedBox(height: 10),
        pw.Container(
          child: pw.Row(
            children: <pw.Widget>[
              buildSender('ผู้นำส่ง', 'Reported by', saleName: saleName),
              buildSender('ผู้รับเงิน', 'Received by'),
            ]
          )
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start, 
          children: <pw.Widget>[
            pw.SizedBox(width: widthFooter),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(title,
                style: pw.TextStyle(font: pgVim, fontSize: fontSize, fontWeight: pw.FontWeight.normal)),
            ),
            pw.SizedBox(width: widthFooter),
            pw.Container(
              height: 25,
              width: 0.7,
              decoration: const pw.BoxDecoration(color: PdfColors.black),
              margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
              
            ),
            pw.Container(
              width: 230,
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
              child: pw.Column(
                children: <pw.Widget>[
                pw.Text("บริษัท คาร์นิวัลเมจิก จำกัด 999 หมู่ 3 ตำบลกมลา อำเภอกะทู้ จังหวัดภูเก็ต 83150",
                  style: pw.TextStyle( font: pgVim, fontSize: fontSize, fontWeight: pw.FontWeight.normal)), //5.5
                pw.SizedBox(height: 3),
                pw.Text("Carnival Magic Co., Ltd. 999 Moo 3 Kamala Kathu phuket 83150 Thailand",
                  style: pw.TextStyle( font: pgVim, fontSize: fontSize, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 3),
                pw.Text("Tel: 076 385222  Email: ticketing@carnivalmagic.fun",
                  style: pw.TextStyle( font: traJanPro, fontSize: fontSize, fontWeight: pw.FontWeight.normal)),
                ]
              )
            ),
            pw.Container(
              height: 25,
              width: .7,
              decoration: const pw.BoxDecoration(color: PdfColors.black),
              margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
            ),
            pw.SizedBox(width: widthFooter),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(dateformat(date: DateTime.now(), type: 'dsn'),
                style: pw.TextStyle(font: pgVim, fontSize: fontSize, fontWeight: pw.FontWeight.normal)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20, top: 10),
              child: pw.Text(context.pagesCount == 1 ? '' : "${context.pageNumber} / ${context.pagesCount}",
                style: pw.TextStyle( font: traJanPro, fontSize: 4, fontWeight: pw.FontWeight.normal))
            ),
          ]
        ),
      ]
    )
  );
}
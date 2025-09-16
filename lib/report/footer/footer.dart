import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../util/dateformat.dart';

pw.Container footer(pw.Context context, pw.Font pgVim, pw.Font traJanPro, String title) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 0.0 * PdfPageFormat.cm),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center, 
      children: <pw.Widget>[
        pw.SizedBox(width: 50),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(title,
            style: pw.TextStyle(font: pgVim, fontSize: 5, fontWeight: pw.FontWeight.normal)), 
        ),
        pw.SizedBox(width: 25),
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
              style: pw.TextStyle( font: pgVim, fontSize: 5.5, fontWeight: pw.FontWeight.normal)),
            pw.SizedBox(height: 3),
            pw.Text("Carnival Magic Co., Ltd. 999 Moo 3 Kamala Kathu phuket 83150 Thailand",
              style: pw.TextStyle( font: pgVim, fontSize: 5.5, fontWeight: pw.FontWeight.normal)),
            pw.SizedBox(height: 3),
            pw.Text("Tel: 076 385222  Email: credit@carnivalmagic.fun",
              style: pw.TextStyle( font: traJanPro, fontSize: 5.5, fontWeight: pw.FontWeight.normal)),
            ]
          )
        ),
        pw.Container(
          height: 25,
          width: 0.7,
          decoration: const pw.BoxDecoration(color: PdfColors.black),
          margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
        ),
        pw.SizedBox(width: 25),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(dateformat(date: DateTime.now(), type: 'dsn'),
            style: pw.TextStyle(font: pgVim, fontSize: 5, fontWeight: pw.FontWeight.normal)), 
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 80),
          child: pw.Text(context.pagesCount == 1 ? '' : "${context.pageNumber} / ${context.pagesCount}",
            style: pw.TextStyle( font: traJanPro, fontSize: 6, fontWeight: pw.FontWeight.normal))
        ),
      ]
    ),
  );
}
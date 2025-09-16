import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../util/dateformat.dart';

List<pw.Widget> headerReportIncomeA5(pw.Context context, String titleThai, String titleEng, DateTime date, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro, String name, String code) {
  double fontSizeThai = 9;
  double fontSizeEng = 7;
  double fontSizeHead = 7;

  pw.Widget buildConCredit(String text, pw.Font traJanPro, double width, double fontSize) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      height: 15,
      width: width,
      // decoration: pw.BoxDecoration(border: pw.Border.all()),
      alignment: pw.Alignment.center,
      child: pw.Text(text,
        style: pw.TextStyle(font: traJanPro, fontSize: fontSize, fontWeight: pw.FontWeight.bold))
    );
  }

  return <pw.Widget>[
    pw.Column(
      children: <pw.Widget>[
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: <pw.Widget>[
            pw.Image(
              logoblack,
              width: 100,
            ),
            pw.SizedBox(width: 20),
            pw.Container(
              height: 65,
              width: 0.8,
              decoration: const pw.BoxDecoration(color: PdfColors.black),
            ),
            pw.SizedBox(width: 20),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(titleThai,
                  style: pw.TextStyle(font: pgVim, fontSize: 15, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text(titleEng,
                  style: pw.TextStyle(font: traJanPro, fontSize: 15, fontWeight: pw.FontWeight.bold)),
              ],
            )
          ],
        ),
        /* pw.Padding(
          padding: const pw.EdgeInsets.only(left: 330),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                pw.Text('วันที่',
                  style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                pw.Text('  ${DbClass().dateformat(date: date, ftype: 'dprv')} ',
                  style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal))
                ]
              ),
              pw.SizedBox(height: 2),
              pw.Text(' Date',
                style: pw.TextStyle( font: pgVim, fontSize: fontSizeEng, fontWeight: pw.FontWeight.normal)),
            ]
          ),
        ), */
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: <pw.Widget>[
            pw.Row(
              children: <pw.Widget>[
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Row(
                      children: [
                      pw.Text('ชื่อ - สกุล',
                        style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 10),
                      name.isNotEmpty ? pw.Text(name,
                        style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)) : pw.Text(name,
                        style: pw.TextStyle( font: traJanPro, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                      ]
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text('Name - surname',
                      style: pw.TextStyle( font: pgVim, fontSize: fontSizeEng, fontWeight: pw.FontWeight.normal)),
                  ]
                ),
                pw.SizedBox(width: 40),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Row(
                      children: [
                      pw.Text('เลขประจำตัว',
                        style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 10),
                      code.isNotEmpty ? pw.Text(code,
                        style: pw.TextStyle( font: traJanPro, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)) : pw.Text(code,
                        style: pw.TextStyle( font: traJanPro, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)), 
                      ]
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text('Staff ID NO.',
                      style: pw.TextStyle( font: pgVim, fontSize: fontSizeEng, fontWeight: pw.FontWeight.normal)),
                  ]
                ),
              ]
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                  pw.Text('วันที่',
                    style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                  pw.Text('  ${dateformat(date: date, type: 'dn')} ',
                    style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal))
                  ]
                ),
                pw.SizedBox(height: 2),
                pw.Text(' Date',
                  style: pw.TextStyle( font: pgVim, fontSize: fontSizeEng, fontWeight: pw.FontWeight.normal)),
              ]
            ),
          ]
        ),
        pw.SizedBox(height: 8),
        /* if(context.pageNumber != 1 && context.pageNumber != 2) pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10),
          child: pw.Row(
            children: [
              buildConCredit('rsvn', traJanPro, 50, fontSizeHead),
              buildConCredit('Agent', traJanPro, 60, fontSizeHead),
              buildConCredit('Voucher', traJanPro, 60, fontSizeHead),
              // buildConCredit('AgentName', traJanPro, 60, fontSizeHead),
              buildConCredit('Amount', traJanPro, 50, fontSizeHead),
            ]
          ),
        ), */
      ],
    ),
  ];
}
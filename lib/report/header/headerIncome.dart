import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../util/dateformat.dart';

List<pw.Widget> headerReportIncome(pw.Context context, String titleThai, String titleEng, DateTime date, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro, String name, String code) {
  double fontSizeHead = 10;

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
          children: <pw.Widget>[
            pw.Image(
              logoblack,
              width: 100,
            ),
            pw.SizedBox(width: 20),
            pw.Container(
              height: 65,
              width: .8,
              decoration: const pw.BoxDecoration(color: PdfColors.black),
            ),
            pw.SizedBox(width: 20),
            pw.Container(
              padding: const pw.EdgeInsets.only(top: 10,),
              height: 60,
              width: 360,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(titleThai,
                    style: pw.TextStyle(font: pgVim, fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text(titleEng,
                    style: pw.TextStyle(font: traJanPro, fontSize: 15, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: <pw.Widget>[
            pw.Row(
              children: <pw.Widget>[
                pw.Container(
                  width: 50,
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text('ชื่อ - สกุล',
                        style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 2),
                      pw.Text('Name - surname',
                        style: pw.TextStyle( font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
                    ]
                  )
                ),
                pw.Container(
                  height: 18,
                  width: 150,
                  padding: const pw.EdgeInsets.only(left: 5),
                  child: name.isNotEmpty ? pw.Text(name,
                    style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.normal)) : pw.Text(name,
                    style: pw.TextStyle( font: traJanPro, fontSize: 9, fontWeight: pw.FontWeight.normal))
                ),
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: <pw.Widget>[
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 50,
                            alignment: pw.Alignment.centerRight,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: <pw.Widget>[
                                pw.Text('เลขประจำตัว',
                                  style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.normal)),
                                pw.SizedBox(height: 2),
                                pw.Text('Staff ID NO.',
                                  style: pw.TextStyle( font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
                              ]
                            )
                          ),
                        ]
                      ),
                    ]
                  ),
                ),
                pw.Container(
                  height: 18,
                  width: 80,
                  padding: const pw.EdgeInsets.only(left: 10),
                  child: code.isNotEmpty ? pw.Text(code,
                    style: pw.TextStyle( font: traJanPro, fontSize: 9, fontWeight: pw.FontWeight.normal)) : pw.Text(code,
                    style: pw.TextStyle( font: traJanPro, fontSize: 9, fontWeight: pw.FontWeight.normal)),  
                ),
              ]
            ),
            pw.Container(
              width: 100,
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Column(
                    children: [
                      pw.Text('วันที่',
                        style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 2),
                      pw.Text(' Date',
                        style: pw.TextStyle( font: pgVim, fontSize: 7, fontWeight: pw.FontWeight.normal)),
                    ]
                  ),
                  pw.Text('  ${dateformat(date: date, type: 'dn')} ',
                    style: pw.TextStyle( font: pgVim, fontSize: 9, fontWeight: pw.FontWeight.normal))
                ]
              )
            ),
          ]
        ),
        pw.SizedBox(height: 8),
        /* if(context.pageNumber != 1) pw.Padding(
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
        ), */
      ],
    ),
  ];
}
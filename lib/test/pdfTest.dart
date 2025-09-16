/* //print Receiving
/* onTap: () async {
  setState(() {
    _reportload = false;
  });
  _report = await Recevingvoucher().genPDFRecevingvoucher(date: selectedDate!);
  setState(() {
    _reportload = true;
  });
}, */

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../util/dateformat.dart';

List<pw.Widget> headerReportIncomeA4Landscape(pw.Context context, String titleThai, String titleEng, DateTime date, pw.MemoryImage logoblack, pw.Font pgVim, pw.Font traJanPro, String name, String code) {
  double fontSizeThai = 9;
  double fontSizeEng = 7;
  // double fontSizeHead = 10;

  pw.Widget buildConCredit(String text, pw.Font traJanPro, double width, {pw.Alignment alignment = pw.Alignment.center}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      height: 15,
      width: width,
      // decoration: pw.BoxDecoration(border: pw.Border.all()),
      alignment: alignment,
      child: pw.Text(text,
        style: pw.TextStyle(font: traJanPro, fontSize: 11, fontWeight: pw.FontWeight.bold))
    );
  }

  return <pw.Widget>[
    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          width: 395,
          decoration: pw.BoxDecoration(
            border: pw.Border.all()
          ),
          child: pw.Column(
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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
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
                ]
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('วันที่  ${dateformat(date: date, type: 'dn')} ',
                          style: pw.TextStyle( font: pgVim, fontSize: fontSizeThai, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 2),
                      pw.Text(' Date',
                        style: pw.TextStyle( font: pgVim, fontSize: fontSizeEng, fontWeight: pw.FontWeight.normal)),
                    ]
                  ),
                ]
              )
                ]
              )
              
            ],
          ),
        )
      ]
    )

    
  ];
}

/* pw.Row(
              children: [
                buildConCredit('rsvn', pgVim, 40),
                buildConCredit('Agent', pgVim, 250),
                // buildConCredit('Voucher', pgVim, 60),
                buildConCredit('Payype', pgVim, 55),
                buildConCredit('Amount', traJanPro, 55),
              ]
            ), */ */

                /* Offset distan = const Offset(18, 18);
    double blur = 20.0; */
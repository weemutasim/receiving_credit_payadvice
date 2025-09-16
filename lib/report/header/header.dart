import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../util/dateformat.dart';

List<pw.Widget> headerReport(pw.Context context, String title, String label, DateTime showdate, pw.ImageProvider logoblack, pw.Font pgVim, pw.Font traJanPro, String? code, String? name) {
  
  String thaiDate = formatThaiDate(showdate);
  return <pw.Widget>[
    pw.Container(
      width: 5,
      // margin: const pw.EdgeInsets.only(left: 15),
      child: pw.Column(
        children: <pw.Widget>[
          pw.Row(
            children: <pw.Widget>[
              pw.Image( logoblack, width: 120),
              pw.SizedBox(height: 90),
              pw.SizedBox(width: 15),
              pw.Container(
                height: 75,
                width: 1,
                decoration: const pw.BoxDecoration(color: PdfColors.black),
              ),
              pw.SizedBox(width: 15),
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 10),
                width: 400,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(title,
                      style: pw.TextStyle( font: pgVim, fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(label,
                      style: pw.TextStyle( font: traJanPro, fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ],
      )
    ),
    pw.SizedBox(height: 10),
    (code!.isNotEmpty && name!.isNotEmpty) ? pw.Container(
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text("$code $name",
                style: pw.TextStyle(font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 5),
              pw.Text('ประจำวันที่ $thaiDate',
                style: pw.TextStyle(font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ]
          ),
          /* pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('วันที่ ${DbClass().dateformat(date: DateTime.now(), ftype: 'dprv')}',
                style: pw.TextStyle( font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.normal))
            ]
          ) */
        ]
      ),
    ) : pw.Text("ประจำวันที่ $thaiDate",
      style: pw.TextStyle(font: pgVim, fontSize: 10, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 5),
  ];
}
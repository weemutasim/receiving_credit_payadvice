import 'package:intl/intl.dart';

class ModelReportHead {
  String? id;
  String? rsvn;
  String? voucher;
  String? showdate;
  String? bookdate;
  String? round;
  String? showtype;
  String? agentcode;
  String? agentname;
  String? tel;
  String? email;
  String? customername;
  String? customertel;
  String? customeremail;
  String? userid;
  String? trandate;
  String? status;
  String? showqty;
  String? buffetqty;
  String? tranfer;
  String? transferstatus;
  String? assignStatus;
  String? ownerBook;
  String? showtime;
  String? exChar;
  String? guidecode;
  String? bookbytype;
  String? seatqty;
  String? accode;
  String? terminal;
  String? paytype;
  String? buffetassign;
  String? invstatus;
  String? accpaytype;
  String? ramt;
  String? acctype;
  String? inftr;
  String? inftraccode;
  List<Datareportdetail>? datareportdetail;

  ModelReportHead(
      {this.id,
      this.rsvn,
      this.voucher,
      this.showdate,
      this.bookdate,
      this.round,
      this.showtype,
      this.agentcode,
      this.agentname,
      this.tel,
      this.email,
      this.customername,
      this.customertel,
      this.customeremail,
      this.userid,
      this.trandate,
      this.status,
      this.showqty,
      this.buffetqty,
      this.tranfer,
      this.transferstatus,
      this.assignStatus,
      this.ownerBook,
      this.showtime,
      this.exChar,
      this.guidecode,
      this.bookbytype,
      this.seatqty,
      this.accode,
      this.terminal,
      this.paytype,
      this.buffetassign,
      this.invstatus,
      this.ramt,
      this.acctype,
      this.inftr,
      this.inftraccode,
      this.accpaytype,
      this.datareportdetail});

  ModelReportHead.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rsvn = json['rsvn'];
    voucher = json['voucher'];
    showdate = json['showdate'];
    bookdate = json['bookdate'];
    round = json['round'];
    showtype = json['showtype'];
    agentcode = json['agentcode'];
    agentname = json['agentname'];
    tel = json['tel'];
    email = json['email'];
    customername = json['customername'];
    customertel = json['customertel'];
    customeremail = json['customeremail'];
    userid = json['userid'];
    trandate = json['trandate'];
    status = json['status'];
    showqty = json['showqty'];
    buffetqty = json['buffetqty'];
    tranfer = json['tranfer'];
    transferstatus = json['transferstatus'];
    assignStatus = json['Assign_Status'];
    ownerBook = json['Owner_Book'];
    showtime = json['showtime'];
    exChar = json['ExChar'];
    guidecode = json['guidecode'];
    bookbytype = json['bookbytype'];
    seatqty = json['seatqty'];
    accode = json['accode'];
    terminal = json['terminal'];
    paytype = json['paytype'];
    buffetassign = json['buffetassign'];
    invstatus = json['invstatus'];
    accpaytype = json['acctype'];
    inftr = json['inftr'] ?? '0.00';
    inftraccode = json['inftraccode'] ?? "";
    ramt = json['ramt'];
    acctype = json['acctype'];
    if (json['datareportdetail'] != null) {
      datareportdetail = <Datareportdetail>[];
      json['datareportdetail'].forEach((v) => datareportdetail?.add(Datareportdetail.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rsvn'] = rsvn;
    data['voucher'] = voucher;
    data['showdate'] = showdate;
    data['bookdate'] = bookdate;
    data['round'] = round;
    data['showtype'] = showtype;
    data['agentcode'] = agentcode;
    data['agentname'] = agentname;
    data['tel'] = tel;
    data['email'] = email;
    data['customername'] = customername;
    data['customertel'] = customertel;
    data['customeremail'] = customeremail;
    data['userid'] = userid;
    data['trandate'] = trandate;
    data['status'] = status;
    data['showqty'] = showqty;
    data['buffetqty'] = buffetqty;
    data['tranfer'] = tranfer;
    data['transferstatus'] = transferstatus;
    data['Assign_Status'] = assignStatus;
    data['Owner_Book'] = ownerBook;
    data['showtime'] = showtime;
    data['ExChar'] = exChar;
    data['guidecode'] = guidecode;
    data['bookbytype'] = bookbytype;
    data['seatqty'] = seatqty;
    data['accode'] = accode;
    data['terminal'] = terminal;
    data['paytype'] = paytype;
    data['buffetassign'] = buffetassign;
    data['invstatus'] = invstatus;
    data['ramt'] = ramt;
    data['acctype'] = acctype;
    if (datareportdetail != null) data['datareportdetail'] = datareportdetail?.map((v) => v.toJson()).toList();
    return data;
  }

  static List<ModelReportHead>? fromJsonList(List list) => list.map((item) => ModelReportHead.fromJson(item)).toList();
}

class Datareportdetail {
  late String typeguest;
  late String p400;
  late String p402;
  late String tr;
  late String trprice;
  late String rs;
  late String rsprice;
  late String codeprice;
  late String amt;
  late String cx;
  late int po;
  late int pb;
  late String amtformat;
  var numformat = NumberFormat("#,###", "en_US");
  Datareportdetail(
      {required this.typeguest,
      required this.p400,
      required this.p402,
      required this.tr,
      required this.trprice,
      required this.rs,
      required this.rsprice,
      required this.codeprice,
      required this.amt,
      required this.cx,
      required this.po,
      required this.pb,
      required this.amtformat});

  Datareportdetail.fromJson(Map<String, dynamic> json) {
    typeguest = json['typeguest'];
    p400 = json['p400'];
    p402 = json['p402'];
    tr = json['tr'];
    trprice = json['trprice'];
    rs = json['rs'];
    rsprice = json['rsprice'];
    codeprice = json['codeprice'];
    amt = json['amt'] ?? "0.00";
    cx = json['cx'];
    po = int.parse(p400);
    pb = int.parse(p402);
    double x = double.parse(amt);
    amtformat = numformat.format(x);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeguest'] = typeguest;
    data['p400'] = p400;
    data['p402'] = p402;
    data['tr'] = tr;
    data['trprice'] = trprice;
    data['rs'] = rs;
    data['rsprice'] = rsprice;
    data['codeprice'] = codeprice;
    data['amt'] = amt;
    data['cx'] = cx;
    return data;
  }
}
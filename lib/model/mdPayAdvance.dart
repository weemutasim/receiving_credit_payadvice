/* class CashAdvance {
  String? id;
  String? rsvn;
  String? voucher;
  String? trdate;
  String? agentcode;
  String? agentname;
  String? userid;
  String? paytype;
  String? amount;
  String? accode;
  String? activeflag;
  String? name;

  CashAdvance(
      {this.id,
      this.rsvn,
      this.voucher,
      this.trdate,
      this.agentcode,
      this.agentname,
      this.userid,
      this.paytype,
      this.amount,
      this.accode,
      this.activeflag,
      this.name});

  CashAdvance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rsvn = json['rsvn'];
    voucher = json['voucher'];
    trdate = json['trdate'];
    agentcode = json['agentcode'];
    agentname = json['agentname'];
    userid = json['userid'];
    paytype = json['paytype'];
    amount = json['amount'];
    accode = json['accode'];
    activeflag = json['activeflag'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rsvn'] = rsvn;
    data['voucher'] = voucher;
    data['trdate'] = trdate;
    data['agentcode'] = agentcode;
    data['agentname'] = agentname;
    data['userid'] = userid;
    data['paytype'] = paytype;
    data['amount'] = amount;
    data['accode'] = accode;
    data['activeflag'] = activeflag;
    data['name'] = name;
    return data;
  }
  static List<CashAdvance>? fromJsonList(List list) => list.map((item) => CashAdvance.fromJson(item)).toList();
} */

class CashAdvance {
  String? id;
  String? rsvn;
  String? voucher;
  String? trdate;
  String? agentcode;
  String? agentname;
  String? userid;
  String? paytype;
  String? amount;
  String? acc;
  String? activeflag;
  String? name;
  String? accode;

  CashAdvance(
      {this.id,
      this.rsvn,
      this.voucher,
      this.trdate,
      this.agentcode,
      this.agentname,
      this.userid,
      this.paytype,
      this.amount,
      this.acc,
      this.activeflag,
      this.name,
      this.accode});

  CashAdvance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rsvn = json['rsvn'];
    voucher = json['voucher'];
    trdate = json['trdate'];
    agentcode = json['agentcode'];
    agentname = json['agentname'];
    userid = json['userid'];
    paytype = json['paytype'];
    amount = json['amount'];
    acc = json['acc'];
    activeflag = json['activeflag'];
    name = json['name'];
    accode = json['accode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rsvn'] = rsvn;
    data['voucher'] = voucher;
    data['trdate'] = trdate;
    data['agentcode'] = agentcode;
    data['agentname'] = agentname;
    data['userid'] = userid;
    data['paytype'] = paytype;
    data['amount'] = amount;
    data['acc'] = acc;
    data['activeflag'] = activeflag;
    data['name'] = name;
    data['accode'] = accode;
    return data;
  }
  static List<CashAdvance>? fromJsonList(List list) =>list.map((item) => CashAdvance.fromJson(item)).toList();
}
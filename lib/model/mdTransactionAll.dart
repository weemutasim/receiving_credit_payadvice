class TransactionAll {
  String? userid;
  String? code;
  String? name;
  List<Creditcard>? creditcard;
  List<Notesandcoins>? notesandcoins;
  List<Payeshop>? payeshop;
  List<Details>? details;
  List<NotesandcoinsDetail>? notesandcoinsDetail;

  TransactionAll(
      {this.userid,
      this.code,
      this.name,
      this.creditcard,
      this.notesandcoins,
      this.payeshop,
      this.details, 
      this.notesandcoinsDetail});

  TransactionAll.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    code = json['code'];
    name = json['name'];
    if (json['creditcard'] != null) {
      creditcard = <Creditcard>[];
      json['creditcard'].forEach((v) {
        creditcard!.add(Creditcard.fromJson(v));
      });
    }
    if (json['notesandcoins'] != null) {
      notesandcoins = <Notesandcoins>[];
      json['notesandcoins'].forEach((v) {
        notesandcoins!.add(Notesandcoins.fromJson(v));
      });
    }
    if (json['payeshop'] != null) {
      payeshop = <Payeshop>[];
      json['payeshop'].forEach((v) {
        payeshop!.add(Payeshop.fromJson(v));
      });
    }
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
    if (json['notesandcoins_detail'] != null) {
      notesandcoinsDetail = <NotesandcoinsDetail>[];
      json['notesandcoins_detail'].forEach((v) {
        notesandcoinsDetail!.add(NotesandcoinsDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['code'] = code;
    data['name'] = name;
    if (creditcard != null) {
      data['creditcard'] = creditcard!.map((v) => v.toJson()).toList();
    }
    if (notesandcoins != null) {
      data['notesandcoins'] = notesandcoins!.map((v) => v.toJson()).toList();
    }
    if (payeshop != null) {
      data['payeshop'] = payeshop!.map((v) => v.toJson()).toList();
    }
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    if (notesandcoinsDetail != null) {
      data['notesandcoins_detail'] = notesandcoinsDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  static List<TransactionAll>? fromJsonList(List list) => list.map((item) => TransactionAll.fromJson(item)).toList();
}

class Creditcard {
  String? idcreditcard;
  String? saledate;
  String? userid;
  String? point;
  String? cardno;
  String? amount;

  Creditcard(
      {this.idcreditcard,
      this.saledate,
      this.userid,
      this.point,
      this.cardno,
      this.amount});

  Creditcard.fromJson(Map<String, dynamic> json) {
    idcreditcard = json['idcreditcard'];
    saledate = json['saledate'];
    userid = json['userid'];
    point = json['point'];
    cardno = json['cardno'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idcreditcard'] = idcreditcard;
    data['saledate'] = saledate;
    data['userid'] = userid;
    data['point'] = point;
    data['cardno'] = cardno;
    data['amount'] = amount;
    return data;
  }
}

class Notesandcoins {
  String? idnotesandcoins;
  String? saledate;
  String? userid;
  String? point;
  String? ntype;
  String? qty;
  String? amount;

  Notesandcoins(
      {this.idnotesandcoins,
      this.saledate,
      this.userid,
      this.point,
      this.ntype,
      this.qty,
      this.amount});

  Notesandcoins.fromJson(Map<String, dynamic> json) {
    idnotesandcoins = json['idnotesandcoins'];
    saledate = json['saledate'];
    userid = json['userid'];
    point = json['point'];
    ntype = json['ntype'];
    qty = json['qty'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idnotesandcoins'] = idnotesandcoins;
    data['saledate'] = saledate;
    data['userid'] = userid;
    data['point'] = point;
    data['ntype'] = ntype;
    data['qty'] = qty;
    data['amount'] = amount;
    return data;
  }
}

class Payeshop {
  String? idpayeshop;
  String? point;
  String? saledate;
  String? salecode;
  String? referno;
  String? amount;
  String? docdate;

  Payeshop(
      {this.idpayeshop,
      this.point,
      this.saledate,
      this.salecode,
      this.referno,
      this.amount,
      this.docdate});

  Payeshop.fromJson(Map<String, dynamic> json) {
    idpayeshop = json['idpayeshop'];
    point = json['point'];
    saledate = json['saledate'];
    salecode = json['salecode'];
    referno = json['referno'];
    amount = json['amount'];
    docdate = json['docdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idpayeshop'] = idpayeshop;
    data['point'] = point;
    data['saledate'] = saledate;
    data['salecode'] = salecode;
    data['referno'] = referno;
    data['amount'] = amount;
    data['docdate'] = docdate;
    return data;
  }
}

class Details {
  String? rsvn;
  String? trrunno;
  String? refno;
  String? amount;
  String? extcode;
  String? accode;

  Details({this.rsvn, this.trrunno, this.refno, this.amount, this.extcode, this.accode});

  Details.fromJson(Map<String, dynamic> json) {
    rsvn = json['rsvn'];
    trrunno = json['trrunno'];
    refno = json['refno'];
    amount = json['amount'];
    extcode = json['extcode'];
    accode = json['accode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rsvn'] = rsvn;
    data['trrunno'] = trrunno;
    data['refno'] = refno;
    data['amount'] = amount;
    data['extcode'] = extcode;
    data['accode'] = accode;
    return data;
  }
}

class NotesandcoinsDetail {
  String? idnotesandcoins;
  String? saledate;
  String? userid;
  String? point;
  String? currencyCode;
  String? rate;
  String? qty;
  String? amount;

  NotesandcoinsDetail(
      {this.idnotesandcoins,
      this.saledate,
      this.userid,
      this.point,
      this.currencyCode,
      this.rate,
      this.qty,
      this.amount});

  NotesandcoinsDetail.fromJson(Map<String, dynamic> json) {
    idnotesandcoins = json['idnotesandcoins'];
    saledate = json['saledate'];
    userid = json['userid'];
    point = json['point'];
    currencyCode = json['currency_code'];
    rate = json['rate'];
    qty = json['qty'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idnotesandcoins'] = idnotesandcoins;
    data['saledate'] = saledate;
    data['userid'] = userid;
    data['point'] = point;
    data['currency_code'] = currencyCode;
    data['rate'] = rate;
    data['qty'] = qty;
    data['amount'] = amount;
    return data;
  }
}

class PayType {
  String? acccode;
  String? shutname;

  PayType({this.acccode, this.shutname});

  PayType.fromJson(Map<String, dynamic> json) {
    acccode = json['acccode'];
    shutname = json['shutname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acccode'] = acccode;
    data['shutname'] = shutname;
    return data;
  }
  static List<PayType>? fromJsonList(List list) => list.map((item) => PayType.fromJson(item)).toList();
}
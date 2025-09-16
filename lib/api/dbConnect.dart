import 'package:credit_payadvice_receiving/model/mdTransactionAll.dart';
import 'package:dio/dio.dart';
import '../model/mdHeadReport.dart';
import '../model/mdPayAdvance.dart';
import '../model/mdPayType.dart';

class Dbconnect {
  String domain = "http://172.2.100.101/cmfrontapp/ticketing/ticketapi/datamodule/mainlib.php";
  String domain1 = 'http://172.2.100.14/clientele_cm/marketing.php';
  String domain2 = 'http://172.2.200.200/cmfrontapp/ticketing/ticketapi/datamodule/selfticketing.php';

  Future<List<ModelReportHead>?> getSaleReportDetail({required String showdate, required String userid}) async {
    FormData formData = FormData.fromMap({
      "param": "getsalereportdetailnew2023",
      "userid": userid,
      "showdate": showdate
    });
    try {
      Response response = await Dio().post(domain, data: formData);
      if (response.statusCode == 200) {
        var reportHead = ModelReportHead.fromJsonList(response.data);
        // print('PayAdvance oK!');
        return reportHead;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<List<CashAdvance>?> payAdvance({required String showdate}) async {
    FormData formData = FormData.fromMap({
      "param": "cashadvance",
      "bookdate": showdate
    });
    try {
      Response response = await Dio().post(domain1, data: formData);
      if (response.statusCode == 200) {
        var payAdvanceData = CashAdvance.fromJsonList(response.data);
        // print('payAdvanceData oK! ${response.data}');
        return payAdvanceData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error cashAdv: $e');
    }
    return null;
  }

  Future<List<PayType>?> payTypeList() async {
    FormData formData = FormData.fromMap({
      "param": "listtypepay",
    });
    try {
      var response = await Dio().post(domain1, data: formData);
      if (response.statusCode == 200) {
        var paytype = PayType.fromJsonList(response.data);
        // print('rsvnData ok! ${response.data}');
        return paytype;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<List<TransactionAll>?> dataTransactionAll({required String date}) async {
    FormData formData = FormData.fromMap({
      "param": "reportpaymentall",
      "showdate": date, //2025-02-10
    });
    try {
      var response = await Dio().post(domain2, data: formData);
      if (response.statusCode == 200) {
        var dataTransactionAll = TransactionAll.fromJsonList(response.data);
        // print('dataTransactionAll ${response.data}');
        return dataTransactionAll;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<dynamic> upActiveFlag({required String flag, required String id, required String accCode, required String cusCode, required String perId, required String date, required String amt, required String refNo, required String payType}) async {
    FormData formData = FormData.fromMap({
      "param": "up_activeflag",
      "id": id,
      "activeflag": flag,
      "accode": accCode,
      "customercode": cusCode,
      "person_id": perId,
      "docdate": date,
      "damt": amt,
      "refno": refNo,
      "paytype": payType //2 credit, 4 payAdv
    });
    print('saveCredit: ${formData.fields}');
    Response response = await Dio().post(domain1, data: formData);
    // print(response.data);
    return "Y";
  }
}
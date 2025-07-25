import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../APIClass.dart';
import '../Response/Exception.dart';
import 'APIService.dart';


class NetworkAPIService extends BaseAPIServices {
APIClass apiClass =APIClass();
  @override
  Future<dynamic> getAPI(String Url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(Url)).timeout(Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        log("My LogData ==>  case 200 $responseJson");
        return responseJson;

      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 403:
        AlertHelper.showToast("${response.statusCode} Forbidden!");
        break;
      case 404:
        AlertHelper.showToast("${response.statusCode} Not found!");
        break;
      case 405:
        AlertHelper.showToast("${response.statusCode} Method not allowed!");
        break;
      case 406:
        AlertHelper.showToast("${response.statusCode} Not accepted!");
        break;
      case 409:
        AlertHelper.showToast("${response.statusCode} Conflict!");
        break;
      case 500:
        AlertHelper.showToast(
            "${response.statusCode} Internal server error!");
        break;
      case 502:
        AlertHelper.showToast("${response.statusCode} Bad gateway!");
        break;


    default:
      throw FeatchDartaException("${response.statusCode}" );

    }

  }

  @override
  Future<dynamic> PostAPI(data, String Url,) async {
    dynamic responseJson;
    try {

      var header  = apiClass.localStorage.read("token") != null ? {
        "Authorization": 'Bearer ${apiClass.localStorage.read("token")}',
        'Accept': "application/json"
      } : {
        // "Authorization": 'Bearer ${apiClass.localStorage.read("token")}',
        'Accept': "application/json"
      } ;
      log("My LogData ==> Send Data ==> $Url \n data $data \n header $header ");

      final response = await http.post(Uri.parse(Url),body: data,headers: header).timeout(Duration(seconds: 20));

      log("My LogData ==> response Post response.body ${response.body}");

      responseJson = returnResponse(response);

    } on SocketException {

      throw InternetException();

    } on TimeoutException {

      throw RequestTimeoutException();
    }

    return responseJson;
  }
}



class AlertHelper {
  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        // backgroundColor: AppColor.appBlackColor,
        // textColor: Colors.white,
        fontSize: 16.0);
  }
}



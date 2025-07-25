import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import '../../../data/exceptions/app_exceptions.dart';
import '../../../local_storage/local_storage.dart';
import 'base_api_services.dart';

class NetworkApiServices implements BaseApiServices {

  @override
  Future<dynamic> getApi(String url) async {
    Map<String, String> getApiheaders = {
      "Authorization": "Bearer ${localStorage.read("access_token")}",
    };

    dynamic jsonResponse;
    try {
      dynamic response = await http.get(Uri.parse(url), headers: getApiheaders).timeout(const Duration(minutes: 2));
      jsonResponse = returnResponse(response);

    } on SocketException {
      throw NoInternetException('');
    }on RequestTimeOutException{
      throw FetchDataException('Time out try again');
    }

    return jsonResponse;
  }

  @override
  Future postApi(String url, data) async{

    Map<String, String> postApiheaders = {
      "Authorization": "Bearer ${localStorage.read("access_token")}",
    };


    dynamic jsonResponse;
    try{

      dynamic response = await http.post(Uri.parse(url),headers: postApiheaders, body: data).timeout(const Duration(minutes: 2));
      jsonResponse = returnResponse(response);

    }on SocketException{
      throw NoInternetException('');
    }on RequestTimeOutException{
      throw FetchDataException('Time out try again') ;
    }

    return jsonResponse;
  }

  @override
  Future<dynamic> deleteApi(String url) async {
    dynamic jsonResponse;
    try {
      dynamic response = await http.delete(Uri.parse(url)).timeout(const Duration(minutes: 2));
      jsonResponse = returnResponse(response);

    } on SocketException {
      throw NoInternetException('');
    }on RequestTimeOutException{
      throw FetchDataException('Time out try again');
    }

    return jsonResponse;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 400:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 401:
        throw UnauthorisedException('');
      case 500:
        throw FetchDataException(
            'Error communicating with server ${response.statusCode}');
      default:
        throw UnauthorisedException('');
    }
  }
}

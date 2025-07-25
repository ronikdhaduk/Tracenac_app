import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:tracenac/features/Assign_Task/AssignTaskModelClass.dart';
import 'package:tracenac/features/login/data/model/login_model_class.dart';
import 'package:tracenac/features/tracenac_get_user/model_class/tracenac_get_user_model_class.dart';

import '../../features/assets/assets_model_class/assets_model_class.dart';
import '../../features/create_report/data/create_asset_report_model_class.dart';
import '../../features/create_report/data/models/report_create.dart';
import '../../features/menu/data/menu_model/menu_model_class.dart';
import '../../features/partner/model_class/PartnerModelClass.dart';
import '../../features/tools/scanner/model_class/check_uni_code_model_class.dart';
import '../../features/tools/scanner/model_class/unicode_details_model_class.dart';
import '../../features/tools/upload_file/model_class/asset_attachments_model_class.dart';
import '../../features/tools/upload_file/model_class/upload_file_model_class.dart';
import 'package:path/path.dart';



class APIClass {
  var tracenacBaseURl = "https://api.tracenac.com/api";
  var response, url, headers;
  final localStorage = GetStorage();

  Future<LoginModelClass> login(email, password) async {
    Map fromBody = {
      "email": "$email",
      "password": "$password",
    };
    url = Uri.parse("$tracenacBaseURl/tenant/authenticate");
    log("My LogData ==> login frombody $fromBody \n url $url ");
    response = await http.post(url, body: fromBody);
    // log("My LogData ==> login response ${response.statuscode}");
    log("My LogData ==> login response ${response.body}");
    return LoginModelClass?.fromJson(jsonDecode(response.body));
  }

  Future<GetMenuModelClass> getDynamicMenuApi() async {
    Map fromBody = {};
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };
    url = Uri.parse("$tracenacBaseURl/tenant/get-menu");

    log("My LogData ==> get menu frombody $fromBody \n token $headers url $url");

    response = await http.get(url, headers: headers);

    log("My LogData ==> getDynamicMenuApi response ${response.body}");
    return GetMenuModelClass?.fromJson(jsonDecode(response.body));
  }

  Future<TracenacUserModelClass> getTracenacUserApi(text) async {
    log("My LogData ==> getTracenacUserApi ");
    Map fromBody = {
      // "searchValue" : "$text",
    };
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    url = Uri.parse("$tracenacBaseURl/user");

    log("My LogData ==> get User frombody $fromBody \n token $headers url $url ");

    response = await http.get(url, headers: headers);


    log("My LogData ==> get User response ${response.body.toString()}");

    return TracenacUserModelClass?.fromJson(jsonDecode(response.body));
  }

  Future<PartnerModelClass> getTracenacPartnerApi(text) async {
    log("My LogData ==> getTracenacPartnerApi ");
    Map fromBody = {
      // "searchValue" : "$text",
    };
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    // url = Uri.parse("$tracenacBaseURl/partner");
    url = Uri.parse("$tracenacBaseURl/partner").replace(queryParameters: {
      'search': '$text',
    });

    log("My LogData ==> Partner frombody $fromBody \n token $headers url $url ");

    response = await http.get(url, headers: headers);


    log("My LogData ==> Partner  response ${response.body.toString()}");

    return PartnerModelClass ?.fromJson(jsonDecode(response.body));
  }

  Future<AssetsModelClass> getTracenacAssetsApi(text) async {
    log("My LogData ==> getTracenacAssetsApi ");
    Map fromBody = {
      // "searchValue" : "$text",
    };
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    url = Uri.parse("$tracenacBaseURl/assets").replace(queryParameters: {
      'search': '$text',
    });

    log("My LogData ==> Assets frombody $fromBody \n token $headers url $url ");

    response = await http.get(url, headers: headers);


    log("My LogData ==> Assets  response ${response.body.toString()}");

    return AssetsModelClass?.fromJson(jsonDecode(response.body));
  }


  Future<CreateAssetReportModelClass> createAssetsReportApi(Map<String, dynamic> data) async {
    log("My LogData ==> createAssetsReportApi ");

    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    url = Uri.parse("$tracenacBaseURl/assets/create-asset-report");

    log("My LogData ==> Assets frombody $data \n token $headers url $url ");

    response = await http.post(url, headers: headers, body: data);


    log("My LogData ==> Assets  response ${response.body.toString()}");

    return CreateAssetReportModelClass?.fromJson(jsonDecode(response.body));
  }


  Future<UploadFileModelClass> uploadFileApi(List<XFile> files) async {
    var uri = Uri.parse("$tracenacBaseURl/assets/upload");

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${localStorage.read("access_token")}'
      ..headers['Accept'] = 'application/json';

    // Add multiple files
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: file.path.split("/").last,
        ),
      );
    }

    log("My LogData ==> uploadFileApi sending to $uri");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log("My LogData ==> uploadFileApi response ${response.body}");

    return UploadFileModelClass.fromJson(jsonDecode(response.body));
  }


  Future<UploadFileModelClass> uploadAudioFile(String filePath) async {
    var uri = Uri.parse("https://api.tracenac.com/api/assets/upload");

    var request = http.MultipartRequest('POST', uri);

    // Attach the audio file
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      filePath,
      filename: basename(filePath),
      // contentType: MediaType('audio', 'mpeg'), // or use correct content-type
    ));

    // Optional: Add headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${localStorage.read("access_token")}'
    });

      // var response = await request.send();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    log("My LogData ==> uploadAudioFile response ${response.body}");

    return UploadFileModelClass.fromJson(jsonDecode(response.body));
  }

  Future<AssetAttachmentsModelClass> assetAttachmentsApi(Map<String, String> data)async{

    final url = '$tracenacBaseURl/assets/asset-attachments';

    final headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    final response = await http.post(Uri.parse(url), body: data, headers: headers);

    log("My LogData ==> assetAttachmentsApi response ${response.body}");

    return AssetAttachmentsModelClass.fromJson(jsonDecode(response.body));

  }


  Future<CheckUniCodeDetailsModelClass> checkUnicodeApi(String unicode) async {
    log("checkUnicodeApi call...");

    final url = 'https://api.tracenac.com/api/report/checkUniqueCode';
    Map<String, String> data = {
      "uniqueCode": unicode
    };
    final headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    final response = await http.post(Uri.parse(url), body: data, headers: headers);

    log("My LogData ==> checkUnicodeApi response ${response.body}");

    return CheckUniCodeDetailsModelClass.fromJson(jsonDecode(response.body));
  }


  Future<UnicodeDetailsModelClass> unicodeApi(String unicode) async {
    log("unicodeApi call...");

    final url = 'https://api.tracenac.com/api/shortcode/$unicode';
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    response = await http.get(Uri.parse(url), headers: headers);

    log("My LogData ==> Assets response ${response.body.toString()}");

    return UnicodeDetailsModelClass.fromJson(jsonDecode(response.body));
  }

  Future<AssignTaskModelClass> getAssignTask( firstDateOfMonth, lastDateOfMonth) async {
    try {

      String endpoint = 'https://api.tracenac.com/api/report/task-get';


      headers = {
        "Authorization": 'Bearer ${localStorage.read("access_token")}',
        'Accept': "application/json"
      };

      Map<String, dynamic> data = {
        "startDate": firstDateOfMonth,
        "endDate": lastDateOfMonth,
      };

      var bodyData = json.encode(data);

      log("My LogData ==> getAssignTask ${bodyData} \n headers $headers");

       response = await http.post(body: bodyData, Uri.parse(endpoint), headers: headers,);
      log("AssignTaskModelClass response==> ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        log("AssignTaskModelClass result==> $result");
        return AssignTaskModelClass.fromJson(result);
      } else {
        var error = jsonDecode(response.body);
        throw Exception(error);
      }
    } catch (e) {
      throw Exception("Error in retrieving or parsing data ${e.toString()}");
    }
  }


  Future<CreateReportModel> createReport(partnerId) async {
    log("My LogData => createReport $partnerId");
    String endpoint = 'https://warranty.lsin.panasonic.com/api/report/create';

    Map<String, dynamic> jsonData = {"partnerId": partnerId, "partnerApproval": true};
    var bodyData = json.encode(jsonData);
    headers = {
      "Authorization": 'Bearer ${localStorage.read("access_token")}',
      'Accept': "application/json"
    };

    response = await http.post(Uri.parse(endpoint), headers: headers, body: bodyData,);

    if (response.statusCode == 200) {
      log('MyLogData createReport 200 ==> ${response.body}');
      final result = jsonDecode(response.body);
      return CreateReportModel.fromJson(result);
    } else {
      log('MyLogData createReport not 200 ==> ${response.body}');
      final result = jsonDecode(response.body)["err"];
      throw Exception("${result} ${response.reasonPhrase}");
    }
  }

  deleteSoftReportId(String? reportId) async {
    log("My LogData ==> deleteSoftReportId reportId $reportId");
    try {

      String endpoint = 'https://warranty.lsin.panasonic.com/api/report/soft-delete/$reportId';
      log("My LogData ==> deleteSoftReportId endpoint $endpoint");
      headers = {
        "Authorization": 'Bearer ${localStorage.read("access_token")}',
        'Accept': "application/json"
      };
      response = await http.put(
        Uri.parse(endpoint),
        headers: headers,
      );
      log("MyLogData Not 200  ==>  deleteSoftReportId ${response.body}");
      log('MyLogData Not 200  ==>  deleteSoftReportId ${response.statusCode}');
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        log('MyLogData Not 200  ==>  ${result.toString()}');
        return result;
      } else {
        var error = jsonDecode(response.body);
        log('MyLogData Not 200  ==>  ${error['err'].toString()}');
        throw Exception(error['err']);
      }
    } catch (e) {
      log('MyLogData Exception  ==>  ${e.toString()}');
      throw Exception("Error in retrieving or parsing data");
    }
  }



}
//
// import 'package:migrante_bloc/config/app_url.dart';
// import 'package:migrante_bloc/data/network/network_api_services.dart';
// import 'package:migrante_bloc/data/repository/login_repository/login_repository.dart';
// import 'package:migrante_bloc/login/model/login_model.dart';
//
// class LoginHttpApiRepository implements LoginRepository{
//   final _api = NetworkApiServices();
//
//   @override
//   Future<LoginModel> loginApi(dynamic data) async{
//     final response = await _api.postApi(AppUrl.loginApi, data);
//     print("response==> $response");
//     return LoginModel.fromJson(response) ;
//   }
//
// }

import '../../../../../core/services/network/network_api_services.dart';
import '../../../../../core/utils/app_url.dart';
import '../../model/login_model_class.dart';
import 'login_repository.dart';

class LoginHttpApiRepository implements LoginRepository{
  final _api = NetworkApiServices();

  @override
  Future<LoginModelClass> loginApi(dynamic data) async{
    final response = await _api.postApi("https://api.tracenac.com/api/tenant/authenticate", data);
    print("response==> $response");
    return LoginModelClass.fromJson(response) ;
  }

}

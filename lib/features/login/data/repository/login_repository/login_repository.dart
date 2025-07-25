import '../../model/login_model_class.dart';

abstract class LoginRepository {
  Future<LoginModelClass> loginApi(dynamic data);
}

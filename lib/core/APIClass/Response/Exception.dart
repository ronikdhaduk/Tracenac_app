class AppException implements Exception{
  String? message;
  String? prefix;
  AppException({this.prefix,this.message});
}

class InternetException extends AppException{
  InternetException ([String? message]) :super (message: "No Internet");
}

class RequestTimeoutException extends AppException{
  RequestTimeoutException ([String? message]) :super (message: "Request Timeout");
}

class InternalServerException extends AppException{
  InternalServerException ([String? message]) :super (message: "Internal Server Error");
}
class InvalidURLException extends AppException{
  InvalidURLException ([String? message]) :super (message: "Invalid URL");
}

class FeatchDartaException extends AppException{
  FeatchDartaException ([String? message]) :super (message: "");
}
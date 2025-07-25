enum Status {LOADING,COMPLATED,ERROR}


class APIResponse<T> {
  Status? status;
  T? data;
  String? message;

  APIResponse(this.status,this.data, this.message);

  APIResponse.loading() : status = Status.LOADING;
  APIResponse.complated(this.data) : status = Status.COMPLATED;
  APIResponse.error (this.message) : status = Status.ERROR;

  @override
  String toString(){
    return "Status : $status \n Message : $message \n data $data";
  }
}